import 'dart:async';
import 'dart:io';
import 'package:connection_verify/connection_verify.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gsmcelllocation/flutter_gsmcelllocation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:internetspeedapplication/GraphScreen.dart';
import 'package:internetspeedapplication/Shared_Prefe_Helper.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_info/sim_info.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'Config.dart';
import 'DBHelper.dart';
import 'InternetSpeedLists.dart';
import 'NetworksScreen.dart';
import 'UserModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getPermissions().then((value) {
    runApp(MaterialApp(
      home: Home(),
    ));
  });
}

Future getPermissions() async {
  var location = await Permission.location.request();
  if (location.isGranted) {
    print("location is granted");
  } else {
    print("location is denied");
  }
}

class Home extends StatefulWidget {
  // const Splashscreen( {Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferenceHelper _preferenceHelper = SharedPreferenceHelper();
  bool _isVisible = true;
  bool isStart = false;
  bool isStop = false;
  bool testAgain = false;
  var coordinates;
  var con;
  bool isPressed = true;
  int speedTag = 0;
  bool isProgressComplete = false;
  dynamic _platformVersion;
  var current;
  var lon;
  var row;
  var lat;
  var _mobileCountryCode;
  var _mobileNetworkCode;
  var lac;
  var cellid;
  var add;
  int firstAttempt = 1;
  Widget myfuture;
  UserModel fetchedData;
  var selectedIndex = 0;
  bool isanimationComplete = false;
  final internetSpeedTest = InternetSpeedTest();
  int pingrate = 0;
  double downloadRate = 0;
  double uploadRate = 0;
  String downloadProgress = '0';
  String uploadProgress = '0';
  String unitText = '';
  var location;
  double lastDownloadValue;
  double lastUploadValue;

  final dbhelper = DatabaseHelper.instance;

  void insertdata() async {
    try {
      Map<String, dynamic> row = {
        DatabaseHelper.columnping: "$pingrate",
        DatabaseHelper.columnDownload: "${downloadSpeedList.last}",
        DatabaseHelper.columnUpload: "${uploadSpeedList.last}",
      };
      final id = await dbhelper.insert(row);
      print(id);
    } catch (e) {
      print("THIS IS A EXCEPTION FROM INSERTDATA");
      print(e);
    }
  }

  void delete() async {
    var id = await dbhelper.deletedata(row);
    print("deleted idddddddddddddddddd ${id}");
  }

  void queryall() async {
    var allrows = await dbhelper.queryallrows();
    allrows.forEach((rowall) {});
  }

  @override
  Future<void> getSimInfo() async {
    var mobileCountryCode = await SimInfo.getMobileCountryCode;
    var mobileNetworkCode = await SimInfo.getMobileNetworkCode;

    setState(() {
      _mobileCountryCode = mobileCountryCode;
      _mobileNetworkCode = mobileNetworkCode;
    });
  }

  Future<void> initPlatformState() async {
    try {
      _platformVersion = await FlutterGsmcelllocation.getGsmCell;
      lac = _platformVersion['lac'];

      cellid = _platformVersion['cid'];
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = _platformVersion;
    });
  }

  void initState() {
    super.initState();

    initPlatformState();
    getCurrentLocation().then((value) {
      setState(() {
        coordinates = value;
        print("Coordinates are ....  $coordinates");
      });
    });
    getCityName().then((value) {
      setState(() {
        location = value;
      });
    });
    //getSimInfo();
    downloadRate = 0;
    bool isNeedleFarwored = true;

    Timer.periodic(Duration(microseconds: 4000), (timer) {
      if (isNeedleFarwored) {
        setState(() {
          downloadRate += 1;
          // print("Inrement in downloadRate = ${downloadRate}");
        });
        if (downloadRate >= 150) {
          setState(() {
            downloadRate = 149;
          });
          // setState(() {
          //   isNeedleFarwored = false;
          //   // downloadRate = 150;
          // });
          Future.delayed(Duration(milliseconds: 300), () {
            setState(() {
              isNeedleFarwored = false;
              // downloadRate = 150;
            });
          });
        }
      } else {
        setState(() {
          downloadRate -= 1;
          // print("Decrement in downloadRate = ${downloadRate}");
        });
        if (downloadRate <= 0) {
          timer.cancel();
          isanimationComplete = true;
        }
      }
    });
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<bool> netcon(BuildContext context) async {
    if (await ConnectionVerify.connectionStatus()) {
      return true;
    } else {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Connection Alert"),
      //   backgroundColor: Colors.red,
      //   duration: Duration(seconds: 2),
      // ));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text(
                "Error",
                style: TextStyle(fontSize: 20),
              ),
              content: new Text(
                "Test failed to complete.Please check your connection and try again.",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isProgressComplete = false;
                        downloadRate = 0;
                        isanimationComplete = true;
                        isPressed = true;
                      });
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            );
          });
      return false;
    }
  }

/////PING CODE////
  Future<int> ping() async {
    final ping = Ping('google.com', count: 1);
    // Begin ping process and listen for output
    ping.stream.listen((event) {
      if (event.response != null) {
        pingrate = event.response.time.inMilliseconds;
      }
    });

    await Future.delayed(Duration(
      seconds: 2,
    ));

    await ping.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Are you Sure?',
                    style: TextStyle(fontSize: 20),
                  ),
                  content: Text("Do you want to exit an app?"),
                  actions: [
                    RaisedButton(
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: const Color(0xFFFFAC5A), width: 2)),
                        onPressed: () => Navigator.of(context).pop()),
                    RaisedButton(
                        onPressed: () => exit(0),
                        splashColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: const Color(0xFFFFAC5A), width: 2)),
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold
                          ),
                        )),
                  ],
                );
              });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: OrientationBuilder(
            builder: (context, orientation) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                // height: (orientation == Orientation.portrait)
                //     ? MediaQuery.of(context).size.height
                //     : null,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.17, -1.0),
                    end: Alignment(0.16, 1.0),
                    colors: [const Color(0xFF58328C), const Color(0xFF2D155B)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, right: 0, left: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 59.0,
                              height: 60.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF2D155B),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      queryall();
                                      if (downloadRate == 0 &&
                                          uploadRate == 0) {
                                        print("Inkwell is tapped");
                                      } else {
                                        // insertdata();
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GraphScreen(),
                                          ));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF6A3CA8)
                                            .withOpacity(0.84),
                                      ),
                                      child: Container(
                                          width: 32.91,
                                          height: 32.91,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF57318B),
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/history.svg")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/location.svg"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: MarqueeText(
                                      text: current != null
                                          ? '$current'
                                          : 'Loading...',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                      speed: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 59.0,
                              height: 60.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AvailableWifi()));
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 56.0,
                                        height: 56.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF2D155B),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF6A3CA8)
                                            .withOpacity(0.84),
                                      ),
                                      child: Container(
                                          width: 23.16,
                                          height: 19.68,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF57318B),
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/wifi.svg")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      // Download And Upload Button.
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 250,
                                height: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(40.0),
                                  ),
                                  color: const Color(0xFF2D155B),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                left: 5,
                                bottom: 5,
                                child: Container(
                                  width: 250,
                                  height: 60,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    color: Color(0xFF58328C),
                                  ),
                                  child: (selectedIndex == speedTag)
                                      ? Center(
                                          child: Text("Download",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  //color: Color(0xFFB283FB),
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700)))
                                      : Center(
                                          child: Text(
                                          "Upload",
                                          style: TextStyle(
                                              color: Colors.white,
                                              // color: Color(0xFFB283FB),
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        )),

                                  //color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Download and Upload  Current Values.
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (speedTag == 0)
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/download.svg"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${downloadRate.toStringAsFixed(2)} mbps",
                                            style: TextStyle(
                                              color: const Color(0xFFFFAC5A),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset("assets/upload.svg"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${uploadRate.toStringAsFixed(2)} mbps",
                                            style: TextStyle(
                                              color: const Color(0xFFFFAC5A),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                          ]),
                      SizedBox(
                        height: 5,
                      ),
                      //Ping,Download and Upload Record
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 10.0,
                                          color: const Color(0xFFFFAC5A),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "Ping",
                                          style: TextStyle(
                                              color: const Color(0xffFFAC5A),
                                              fontSize: 12.0),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "$pingrate ms",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    (lastDownloadValue != null
                                        ? Text(
                                            "Download: ${lastDownloadValue.toStringAsFixed(2)}",
                                            style: TextStyle(
                                                color: Color(0xFFB283FB)),
                                          )
                                        : Text("")),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        lastUploadValue != null
                                            ? Text(
                                                "Upload: ${lastUploadValue.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffFFAC5A),
                                                ),
                                              )
                                            : Text("")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 0,
                      ),
                      //////Radial Gauge////////
                      Expanded(
                        child: SfRadialGauge(
                            backgroundColor: Colors.transparent,
                            axes: <RadialAxis>[
                              RadialAxis(
                                  //ticksPosition: ElementsPosition.outside,
                                  ticksPosition: ElementsPosition.inside,
                                  canRotateLabels: false,
                                  canScaleToFit: true,
                                  //showLabels: true,
                                  //tickOffset: 7,
                                  labelOffset: -35,
                                  startAngle: 120,
                                  endAngle: 425,
                                  minimum: 0,
                                  maximum: 150,
                                  isInversed: false,
                                  interval: 50,
                                  radiusFactor: 0.90,
                                  showAxisLine: true,
                                  showLastLabel: true,
                                  minorTicksPerInterval: 22,
                                  axisLineStyle: AxisLineStyle(
                                      cornerStyle: CornerStyle.bothFlat,
                                      color: Colors.black12,
                                      thickness: 4),
                                  majorTickStyle: MajorTickStyle(
                                    length: 19,
                                    thickness: 3,
                                    color: Colors.deepPurple,
                                  ),
                                  minorTickStyle: MinorTickStyle(
                                      length: 19,
                                      thickness: 3,
                                      //color: const Color(0xFF280E5A),
                                      color: Colors.deepPurple),
                                  axisLabelStyle: GaugeTextStyle(
                                      color: Colors.white, fontSize: 14),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                        startValue: 0,
                                        endValue: 300,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        startWidth: 0.2,
                                        endWidth: 0.2,
                                        gradient:
                                            SweepGradient(colors: const <Color>[
                                          Colors.deepPurple,
                                          Colors.purple,
                                          //Colors.deepPurpleAccent,
                                        ], stops: const <double>[
                                          0.0,
                                          1.0,
                                          2.0
                                        ])),
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                        animationType: AnimationType.slowMiddle,
                                        animationDuration: 500,
                                        enableAnimation: true,
                                        needleColor: Colors.yellow,
                                        //needleColor: const Color(0xFFFD6C631),
                                        needleLength: 0.95,
                                        enableDragging: false,
                                        needleEndWidth: 5,
                                        needleStartWidth: 3,
                                        knobStyle: KnobStyle(
                                          knobRadius: 0.13,
                                          color: Colors.white,
                                          borderWidth: 0.03,
                                          borderColor: const Color(0xFFF847806),
                                        ),
                                        value: selectedIndex == speedTag
                                            ? downloadRate
                                            : uploadRate,
                                        tailStyle: TailStyle(
                                            length: 0.3,
                                            width: 4,
                                            color: const Color(0xFFFB5AF0C),
                                            borderColor: Colors.yellow)),
                                    RangePointer(
                                      value: selectedIndex == speedTag
                                          ? downloadRate
                                          : uploadRate,
                                      enableDragging: true,
                                      animationDuration: 500,
                                      animationType: AnimationType.slowMiddle,
                                      pointerOffset: -1,
                                      dashArray: [1, 1, 1],
                                      sizeUnit: GaugeSizeUnit.logicalPixel,
                                      gradient:
                                          const SweepGradient(colors: <Color>[
                                        Color(0xFFCC2B5E),
                                        Color(0xFFFFAC5A),
                                      ], stops: <double>[
                                        0.25,
                                        0.75
                                      ]),
                                      width: 25,
                                      enableAnimation: true,
                                    )
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      widget: Container(
                                          child: Text(
                                              '${selectedIndex == speedTag ? downloadRate.toStringAsFixed(2) : uploadRate.toStringAsFixed(2)}$unitText',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                      angle: 90,
                                      verticalAlignment: GaugeAlignment.center,
                                      positionFactor: 1.2,
                                      horizontalAlignment:
                                          GaugeAlignment.center,
                                    )
                                  ])
                            ]),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () async {
                          _preferenceHelper
                              .removeUploadData('doubleUploadList');
                          downloadSpeedList.clear();
                          uploadSpeedList.clear();
                          if (isanimationComplete == true) {
                            // if (isProgressComplete == true) {
                            isProgressComplete = false;
                            //   isStart = true;
                            // }
                            // if (isStart == true) {
                            //   isStart = false;
                            // } else if (isStart == false) {
                            //   isStart = true;
                            // }
                            if (isPressed) {
                              setState(() {});
                              con = await netcon(context);
                              // if (isStart == true) {
                              if (selectedIndex == speedTag) {
                                getDownloadSpeed();
                              } else {
                                getUploadSpeed();
                              }
                              // }
                              setState(() {});
                              if (con) {
                                setState(() {
                                  _isVisible = !_isVisible;
                                  getCityName();
                                  // isStart = !isStart;
                                  // isStop = !isStop;
                                });
                              }

                              print("I AM CHECKING IS START $isStart");
                              ping();
                              lastDownloadValue = 0;
                              lastUploadValue = 0;
                              isPressed = false;
                            } else {}
                            //setState(() {
                            //isClicked = !isClicked;
                            //});

                          }
                        },
                        child: Visibility(
                          visible: _isVisible,
                          child: Container(
                            height: 129.0,
                            width: 130.0,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  //spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              border: Border.all(
                                width: 8,
                                color: const Color(0xFF562C94).withOpacity(0.4),
                              ),
                            ),
                            child: Container(
                              width: 98.0,
                              height: 97.0,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border: Border.all(
                                  width: 3.0,
                                  color: Colors.black,
                                ),
                              ),
                              child: Container(
                                width: 76.0,
                                height: 75.0,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  border: Border.all(
                                    width: 2.7,
                                    color: const Color(0xFF562C94),
                                  ),
                                ),
                                child: Container(
                                  width: 74.0,
                                  height: 73.0,
                                  child: Center(
                                    child: Text(
                                      (isProgressComplete == true)
                                          ? 'Test\nAgain'
                                          : 'Start',
                                      // (isProgressComplete == true)
                                      //     ? 'Test\nAgain'
                                      //     : (isStart == false)
                                      //         ? 'Start'
                                      //         : (isStart == true)
                                      //             ? 'Stop'
                                      //             : 'Start',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Segoe UI',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.288,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 6),
                                    // color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        const Color(0xFF271056),
                                        const Color(0xFF512594),
                                        const Color(0xFF2C213C)
                                      ],
                                      stops: [0.0, 1.0, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void getDownloadSpeed() {
    try {
      var request = internetSpeedTest.startDownloadTesting(
        onDone: (double transferRate, SpeedUnit unit) {
          print('the transfer rate $transferRate');
          setState(() {
            downloadRate = transferRate;
            unitText = unit == SpeedUnit.Kbps ? '\n kbps' : '\n mbps';
            downloadProgress = '100';
            lastDownloadValue = downloadSpeedList.last;
            speedTag = 1;
            getUploadSpeed();
          });
        },

        onProgress: (double percent, double transferRate, SpeedUnit unit) {
          print('the transfer rate $transferRate, the percent $percent');
          setState(() {
            downloadRate = transferRate;
            unitText = unit == SpeedUnit.Kbps ? '\n kbps' : '\n mbps';
            downloadProgress = percent.toStringAsFixed(2);
          });

          downloadSpeedList.add(downloadRate);
          _preferenceHelper.setDoubleListPreferences(downloadSpeedList);
        },
        onError: (String errorMessage, String speedTestError) {
          print(
              'the errorMessage $errorMessage, the speedTestError $speedTestError');
        },
        // testServer:
        // 'http://ipv4.ikoula.testdebit.info/1M.iso',
        // testServer: " https://test.tankionline.com/",
        //testServer: 'http://ipv4.ikoula.testdebit.info/',
        fileSize: 20000000,
      );
    } catch (e) {
      print(e);
    }
  }

  void getUploadSpeed() {
    try {
      // testServer:"https://www.meter.net/",
      internetSpeedTest.startUploadTesting(
        onDone: (double transferRate, SpeedUnit unit) {
          print('I am done getting speed');
          setState(() {
            uploadRate = transferRate;
            unitText = unit == SpeedUnit.Kbps ? '\n kbps' : '\n mbps';
            uploadProgress = '100';
            lastUploadValue = uploadSpeedList.last;
            insertdata();
            speedTag = 0;
            downloadRate = 0;
            isPressed = true;
          });
          isProgressComplete = true;
          _isVisible = true;

          setState(() {});
        },

        onProgress: (double percent, double transferRate, SpeedUnit unit) {
          setState(() {
            uploadRate = transferRate;
            unitText = unit == SpeedUnit.Kbps ? '\n kbps' : '\n mbps';
            uploadProgress = percent.toStringAsFixed(2);
          });

          uploadSpeedList.add(uploadRate);
          _preferenceHelper.setDoubleUploadListPreferences(uploadSpeedList);
        },
        onError: (String errorMessage, String speedTestError) {},
        //    testServer: " https://test.tankionline.com/",
        //testServer: 'http://ipv4.ikoula.testdebit.info/',

        fileSize: 20000000,
      );
    } catch (e) {}
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    // LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.requestPermission();
    }
    return Geolocator.getCurrentPosition();
  }

  Future<String> getCityName() async {
    String addressLine;
    Position position = await determinePosition();
    // final coordinates =
    //     await Coordinates(position.latitude, position.longitude);
    // print("Coordinatesssssssssssssss =${coordinates}");

    try {
      // var addresses =
      //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // if (addresses.isNotEmpty) {
      //   location = addresses.first.subLocality;
      //   return addresses.first.subLocality;
      //   print("Location of Device is $location");
      // }
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      current = placemarks[0].subLocality;
      print(
          "Latitude is ${position.latitude} and Longitude is ${position.longitude}");
    } catch (e) {
      print("Errrrrrrrrrrrrrrrrrrrror = ${e}");
    }
  }
}

class data {
  int pingrate;
  double downloadRate;
  double uploadRate;

  data({this.downloadRate, this.pingrate, this.uploadRate});
}
