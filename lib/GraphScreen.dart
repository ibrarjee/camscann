import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internetspeedapplication/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DBHelper.dart';
import 'InternetSpeedLists.dart';

class GraphScreen extends StatefulWidget {
  double downloadRate;
  double uploadRate;
  int pingRate;
  double downLoadSpeedListLength;
  double uploadSpeedListLength;
  final dbhelper = DatabaseHelper.instance;

  // List<double> downloadSpeedList = [];
  // List<double> uploadSpeedList = [];

  GraphScreen({
    this.uploadRate,
    this.downloadRate,
    this.pingRate,
    //this.downloadSpeedList,
    // this.uploadSpeedList,
    this.uploadSpeedListLength,
    this.downLoadSpeedListLength,
  });

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  List<String> ping = [];
  List<String> downloadRate = [];
  List<String> uploadRate = [];
  List<String> tempPing = [];
  List<String> tempDownloadRate = [];
  List<String> tempUploadRate = [];
  List<String> tempId = [];
  List<String> id = [];
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  bool isShowingMainData;
  final List<Color> gradientColors = [
    const Color(
      0xFF58328C,
    ),
    const Color(0xFF58328C),
  ];

  DateTime pickedDate = DateTime.now();

  String downloadProgress = '0';
  String uploadProgress = '0';

  String unitText = '';
  List<FlSpot> lineChartPointList = [];
  List<FlSpot> lineChartUploadPointList = [];

  ///Download List Initialization....
  initializeList() async {
    List<double> downloadList = [];
    List<String> tempList = [];
    print("I AM FROM GRAPH SCREEN $downloadSpeedList");
    if (downloadSpeedList != null) {
      if (downloadSpeedList.length > 0) {
        print(";;;;;;;;;;;;;;;List not is null ");
        for (int i = 0; i < downloadSpeedList.length; i++) {
          //print("=========Values =============${downloadSpeedList[i]}");
          //print(List);
          lineChartPointList.add(FlSpot(i.toDouble(), downloadSpeedList[i]));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        print("I AM IN ELSE");
        List<double> downloadList = [];
        List<String> tempList = [];
        SharedPreferences _pref = await SharedPreferences.getInstance();

        tempList = _pref.getStringList('doubleList');
        if (tempList != null) {
          tempList.forEach((element) {
            downloadSpeedList.add(double.parse(element));
          });
          print("MY DOWNLOAD LiST $downloadSpeedList");
          for (int i = 0; i < downloadSpeedList.length; i++) {
            lineChartPointList.add(FlSpot(i.toDouble(), downloadSpeedList[i]));
          }
        }

        setState(() {
          isLoading = false;
        });
        print(";;;;;;;;;;;;;;;List  is null ");
        lineChartPointList.add(FlSpot(0.0, 0.0));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(";;;;;;;;;;;;;;;List  is null ");
      lineChartPointList.add(FlSpot(0.0, 0.0));
      setState(() {
        isLoading = false;
      });
    }
  }

//UploadList Initialization...
  InitializeUploadList() async {
    List<double> uploadList = [];
    List<String> tempList = [];
    print("I AM FROM GRAPH SCREEN UPLOADLIST $uploadSpeedList");
    if (uploadSpeedList != null) {
      if (uploadSpeedList.length > 0) {
        print(";;;;;;;;;;;;;;;List not is null ");
        for (int i = 0; i < uploadSpeedList.length; i++) {
          //print("=========Values =============${downloadSpeedList[i]}");
          //print(List);
          lineChartPointList.add(FlSpot(i.toDouble(), uploadSpeedList[i]));
        }
        setState(() {
          isLoading = false;
        });
      } else {
        List<double> uploadList = [];
        List<String> tempList = [];
        SharedPreferences _pref = await SharedPreferences.getInstance();
        tempList = _pref.getStringList('doubleUploadList');

        if (tempList != null) {
          tempList.forEach((element) {
            uploadSpeedList.add(double.parse(element));
          });
          print("MY UPLOAD LiST $uploadSpeedList");
          for (int i = 0; i < uploadSpeedList.length; i++) {
            lineChartPointList.add(FlSpot(i.toDouble(), uploadSpeedList[i]));
          }
          setState(() {
            isLoading = false;
          });
        }
        print(";;;;;;;;;;;;;;;List  is null ");
        lineChartPointList.add(FlSpot(0.0, 0.0));
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(";;;;;;;;;;;;;;;List  is null ");
      lineChartPointList.add(FlSpot(0.0, 0.0));
      setState(() {
        isLoading = false;
      });
    }
  }

  void delete() async {
    var id = await databaseHelper.deletedata(ping.length);
  }

  ///Upload List Initialization....

  // InitializeUploadList() {
  //   if (uploadSpeedList != null) {
  //     if (uploadSpeedList.length > 0) {
  //       print(";;;;;;;;;;;;;;;List not is null ");
  //       for (int i = 0; i < uploadSpeedList.length; i++) {
  //         print("=========Values =============${uploadSpeedList[i]}");
  //         print(List);
  //         lineChartUploadPointList
  //             .add(FlSpot(i.toDouble(), uploadSpeedList[i]));
  //       }
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       print(";;;;;;;;;;;;;;;List  is null ");
  //       lineChartUploadPointList.add(FlSpot(0.0, 0.0));
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } else {
  //     print(";;;;;;;;;;;;;;;List  is null ");
  //     lineChartUploadPointList.add(FlSpot(0.0, 0.0));
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  bool isLoading = false;
  List<Feature> list = [];
  double i = 1.0;

  @override
  void initState() {
    isLoading = true;
    // downloadSpeedList.insert(0, 0.0);s
    // _Highestvalue();
    //pickDate();
    initializeList();
    InitializeUploadList();
    //InitializeUploadList();
    getdata().then((value) {
      value.forEach((element) {
        tempId?.add(element['id'].toString());
        tempPing?.add(element['ping'].toString());
        tempUploadRate?.add(element['uploadrate'].toString());
        tempDownloadRate?.add(element['downloadrate'].toString());

        // setValues(element);
      });
      print("id is");
      print(tempId);
      setValuePing(tempPing);
      setValueDownload(tempDownloadRate);
      setValueUpload(tempUploadRate);
    });
    super.initState();
  }

  setValuePing(List<String> data) {
    setState(() {
      ping = data;
    });
  }

  setValueId(List<String> data) {
    setState(() {
      id = data;
    });
  }

  setValueDownload(List<String> data) {
    setState(() {
      downloadRate = data;
    });
  }

  setValueUpload(List<String> data) {
    setState(() {
      uploadRate = data;
    });
  }

  setValues(Map<String, dynamic> values) {
    setState(() {
      ping = tempPing;
      tempUploadRate = uploadRate;
      tempDownloadRate = downloadRate;
    });
  }

  Future<List<Map<String, dynamic>>> getdata() async {
    var data = await databaseHelper.queryallrows();
    //    .then((value) {
    //
    //   data= value;
    //   print(value);
    //   return value;
    //
    // }
    // );
    print(data);
    return data;
  }

  var height, width;

  @override
  void dispose() {
    // TODO: implement dispose

    // widget.downloadSpeedList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          body: isLoading == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.17, -1.0),
                      end: Alignment(0.16, 1.0),
                      colors: [
                        const Color(0xFF58328C),
                        const Color(0xFF2D155B)
                      ],
                    ),
                  ),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: false,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
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
                                      Navigator.pop(context);
                                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
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
                                        // width: 52.0,
                                        //   height: 52.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF57318B),
                                        ),
                                        child: SvgPicture.asset(
                                            "assets/back arrow.svg"),
                                        // Icon(
                                        //   Icons.arrow_back,
                                        //   color: Colors.white,
                                        // ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: new Container(
                                      //Adjust it using Media Query
                                      // width: 300,
                                      // height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: LineChart(LineChartData(
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: false,
                                          drawHorizontalLine: false,
                                          getDrawingHorizontalLine: (value) {
                                            return FlLine(
                                              color: const Color(0xFF6A3CA8),
                                              strokeWidth: 1,
                                            );
                                          },
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles:
                                              SideTitles(showTitles: false),
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            getTextStyles: (value) =>
                                                const TextStyle(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                            getTitles: (value) {
                                              switch (value.toInt()) {
                                                // case 0:
                                                //   return '0';
                                                // case 1:
                                                //   return '10';
                                                // case 2:
                                                //   return '20';
                                                // case 3:
                                                //   return '30';
                                                // case 4:
                                                //   return "40";
                                                // case 5:
                                                //   return "50";
                                              }

                                              return '';
                                            },
                                            reservedSize: 20,
                                            //interval: 1,
                                            //  margin: 8,
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: true,
                                          border: Border.all(
                                              color: Colors.black12,
                                              // color: const Color(0xff37434d),
                                              width: 1),
                                        ),
                                        minX: 0,
                                        //maxX: 85,
                                        minY: 0,
                                        //maxY: 6,

                                        ///DOWNLOAD  SPOTS/////
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: List.generate(
                                                downloadSpeedList.isNotEmpty
                                                    ? downloadSpeedList.length
                                                    : 1, (index) {
                                              if (downloadSpeedList.isNotEmpty)
                                                return FlSpot(index.toDouble(),
                                                    downloadSpeedList[index]);
                                              else
                                                //   {
                                                //    // downloadSpeedList.clear();
                                                return FlSpot(1.0, 1.0);
                                              //
                                              //   }
                                            }),
                                            isCurved: true,
                                            colors: [Color(0xffB283FB)],
                                            barWidth: 2,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: false,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: true,
                                              colors: [Color(0xFF793CD6)],
                                              // gradientColors
                                              //     .map((color) =>
                                              //         color.withOpacity(0.8))
                                              //     .toList(),
                                            ),
                                          ),
                                          LineChartBarData(
                                            spots: List.generate(
                                                uploadSpeedList.isNotEmpty
                                                    ? uploadSpeedList.length
                                                    : 1, (index) {
                                              if (uploadSpeedList.isNotEmpty)
                                                return FlSpot(index.toDouble(),
                                                    uploadSpeedList[index]);
                                              else
                                                //   {
                                                //    // downloadSpeedList.clear();
                                                return FlSpot(1.0, 1.0);
                                              //
                                              //   }
                                            }),
                                            dashArray: [4, 4],
                                            isCurved: true,
                                            colors: [Color(0xFFFFAC5A)],
                                            barWidth: 2,
                                            isStrokeCapRound: true,
                                            dotData: FlDotData(
                                              show: false,
                                            ),
                                            belowBarData: BarAreaData(
                                              show: false,
                                              colors: gradientColors
                                                  .map((color) =>
                                                      color.withOpacity(0.3))
                                                  .toList(),
                                            ),
                                          )
                                        ],
                                      ))),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                //Date........
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 8, left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDate(DateTime.now(),
                                            [d, ' ', M, ',', yyyy]),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2D155B),
                                              //color: Colors.blue,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                  30,
                                                ),
                                                topRight: Radius.circular(
                                                  30,
                                                ),
                                              ),
                                            ),
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: new Text(
                                                          "Type",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFB283FB)),
                                                        ),
                                                        width: 40,
                                                      ),
                                                      Container(
                                                        width: 40,
                                                        child: new Text(
                                                          "Ping",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFB283FB)),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 80,
                                                        child: new Text(
                                                          "Upload",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFB283FB)),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        child: new Text(
                                                          "Download",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFFB283FB)),
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                  ),
                                                ),
                                                (downloadRate.isNotEmpty ||
                                                        uploadRate.isNotEmpty)
                                                    ? ConstrainedBox(
                                                        child: ListView.builder(
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Card(
                                                              color: const Color(
                                                                  0xFF2D155B),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                      width: 40,
                                                                      child: SvgPicture
                                                                          .asset(
                                                                              "assets/wifi.svg")),
                                                                  Container(
                                                                    width: 40,
                                                                    child:
                                                                        new Text(
                                                                      ping[
                                                                          index],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Color(0xffFFAC5A)),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 80,
                                                                    child:
                                                                        new Text(
                                                                      uploadRate[
                                                                          index],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 60,
                                                                    child:
                                                                        new Text(
                                                                      downloadRate[
                                                                          index],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                              ),
                                                            );
                                                          },
                                                          itemCount:
                                                              ping?.length,
                                                        ),
                                                        constraints:
                                                            BoxConstraints(
                                                          minHeight: 0,
                                                          maxHeight:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  2.5,
                                                        ),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                              "There is no available history",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          SizedBox(
                                                            width: 40,
                                                          ),
                                                          FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Start",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                              ))
                                                        ],
                                                      )
                                                //InkWell(child: Text("There is no  History Please Start",style: TextStyle(color: Colors.white),),onTap: (){
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                                                // },),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: 1,
                                )

                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   itemBuilder: (context, index) {
                                //     return Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Card(
                                //         color: Colors.transparent,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(50.0),
                                //         ),
                                //         elevation: 0,
                                //         child: Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Container(
                                //               decoration: BoxDecoration(
                                //                 color: const Color(0xFF2D155B),
                                //                 //color: Colors.blue,
                                //                 borderRadius: BorderRadius.only(
                                //                   topLeft: Radius.circular(
                                //                     30,
                                //                   ),
                                //                   topRight: Radius.circular(
                                //                     30,
                                //                   ),
                                //                 ),
                                //               ),
                                //               height: 300,
                                //               // height: MediaQuery.of(context)
                                //               //     .size
                                //               //     .height,

                                //               width: MediaQuery.of(context)
                                //                   .size
                                //                   .width,
                                //               child: Column(
                                //                 children: [
                                //                   Container(
                                //                     child: Padding(
                                //                       padding:
                                //                           const EdgeInsets.all(
                                //                               15.0),
                                //                       child: Row(
                                //                         children: [
                                //                           Container(
                                //                             child: new Text(
                                //                               "Type",
                                //                               style: TextStyle(
                                //                                   color: Color(
                                //                                       0xFFB283FB)),
                                //                             ),
                                //                             width: 40,
                                //                           ),
                                //                           Container(
                                //                             width: 40,
                                //                             child: new Text(
                                //                               "Ping",
                                //                               style: TextStyle(
                                //                                   color: Color(
                                //                                       0xFFB283FB)),
                                //                             ),
                                //                           ),
                                //                           Container(
                                //                             width: 80,
                                //                             child: new Text(
                                //                               "Upload",
                                //                               style: TextStyle(
                                //                                   color: Color(
                                //                                       0xFFB283FB)),
                                //                             ),
                                //                           ),
                                //                           Container(
                                //                             width: 70,
                                //                             child: new Text(
                                //                               "Download",
                                //                               style: TextStyle(
                                //                                   color: Color(
                                //                                       0xFFB283FB)),
                                //                             ),
                                //                           ),
                                //                         ],
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .spaceBetween,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                   (downloadRate.isNotEmpty ||
                                //                           uploadRate.isNotEmpty)
                                //                       ? Container(
                                //                           child: ConstrainedBox(
                                //                             child: ListView
                                //                                 .builder(
                                //                               itemBuilder:
                                //                                   (context,
                                //                                       index) {
                                //                                 return Card(
                                //                                   color: const Color(
                                //                                       0xFF2D155B),
                                //                                   child:
                                //                                       Dismissible(
                                //                                     background:
                                //                                         Container(
                                //                                       color: Colors
                                //                                           .red,
                                //                                       alignment:
                                //                                           Alignment
                                //                                               .centerLeft,

                                //                                       //child: Icon(Icons.cancel,color: Colors.white,),
                                //                                     ),
                                //                                     secondaryBackground:
                                //                                         Container(
                                //                                       color: Colors
                                //                                           .red,
                                //                                       alignment:
                                //                                           Alignment
                                //                                               .centerRight,
                                //                                       child:
                                //                                           Icon(
                                //                                         Icons
                                //                                             .delete,
                                //                                         color: Colors
                                //                                             .white,
                                //                                       ),
                                //                                     ),
                                //                                     //key: UniqueKey(),
                                //                                     key: Key(
                                //                                         uploadRate[
                                //                                             index]),
                                //                                     direction:
                                //                                         DismissDirection
                                //                                             .horizontal,
                                //                                     onDismissed:
                                //                                         (_) {
                                //                                       setState(
                                //                                           () {
                                //                                         delete();
                                //                                         var item =
                                //                                             uploadRate.removeAt(index);
                                //                                         Scaffold.of(context)
                                //                                             .showSnackBar(
                                //                                           SnackBar(
                                //                                             content:
                                //                                                 Text("Record Deleted"),
                                //                                             action:
                                //                                                 SnackBarAction(
                                //                                               label: 'Undo',
                                //                                               onPressed: () {
                                //                                                 setState(() {
                                //                                                   uploadRate.insert(index, item);
                                //                                                 });
                                //                                               },
                                //                                             ),
                                //                                             duration:
                                //                                                 Duration(seconds: 3),
                                //                                           ),
                                //                                         );
                                //                                       });
                                //                                     },
                                //                                     child: Row(
                                //                                       children: [
                                //                                         Container(
                                //                                             width:
                                //                                                 40,
                                //                                             child:
                                //                                                 SvgPicture.asset("assets/wifi.svg")),
                                //                                         Container(
                                //                                           width:
                                //                                               40,
                                //                                           child:
                                //                                               new Text(
                                //                                             ping[index],
                                //                                             style:
                                //                                                 TextStyle(color: Color(0xffFFAC5A)),
                                //                                           ),
                                //                                         ),
                                //                                         Container(
                                //                                           width:
                                //                                               80,
                                //                                           child:
                                //                                               new Text(
                                //                                             uploadRate[index],
                                //                                             style:
                                //                                                 TextStyle(color: Colors.white),
                                //                                           ),
                                //                                         ),
                                //                                         Container(
                                //                                           width:
                                //                                               60,
                                //                                           child:
                                //                                               new Text(
                                //                                             downloadRate[index],
                                //                                             style:
                                //                                                 TextStyle(color: Colors.white),
                                //                                           ),
                                //                                         ),
                                //                                       ],
                                //                                       mainAxisAlignment:
                                //                                           MainAxisAlignment
                                //                                               .spaceBetween,
                                //                                     ),
                                //                                   ),
                                //                                 );
                                //                               },
                                //                               itemCount:
                                //                                   ping?.length,
                                //                             ),
                                //                             constraints:
                                //                                 BoxConstraints(
                                //                                     maxHeight:
                                //                                         250),
                                //                           ),
                                //                           width: MediaQuery.of(
                                //                                   context)
                                //                               .size
                                //                               .width,
                                //                           height: 190,
                                //                         )
                                //                       : Row(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment
                                //                                   .end,
                                //                           children: [
                                //                             Text(
                                //                                 "There is no available history",
                                //                                 style: TextStyle(
                                //                                     color: Colors
                                //                                         .white)),
                                //                             SizedBox(
                                //                               width: 40,
                                //                             ),
                                //                             FlatButton(
                                //                                 onPressed: () {
                                //                                   Navigator.pop(
                                //                                       context);
                                //                                 },
                                //                                 child: Text(
                                //                                   "Start",
                                //                                   style:
                                //                                       TextStyle(
                                //                                     fontSize:
                                //                                         20,
                                //                                     color: Colors
                                //                                         .blueAccent,
                                //                                     decoration:
                                //                                         TextDecoration
                                //                                             .underline,
                                //                                   ),
                                //                                 ))
                                //                           ],
                                //                         )
                                //                   //InkWell(child: Text("There is no  History Please Start",style: TextStyle(color: Colors.white),),onTap: (){
                                //                   //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                                //                   // },),
                                //                 ],
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     );
                                //   },
                                //   itemCount: 1,
                                // )
                                ,
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

// void _Highestvalue(){
//     widget.downloadSpeedList.sort();
//     setState(() {
//
//     });
//     print("List all values are------${widget.downloadSpeedList}");
//     print("Highest value in the list is ${widget.downloadSpeedList.last}");
// }

}

class Feature {
  String title;
  Color color;
  List<double> data;

  Feature({
    this.title = "",
    this.color = Colors.black,
    @required this.data,
  });
}
