import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wifi_configuration/wifi_configuration.dart';
import 'SettingScreen.dart';

class AvailableWifi extends StatefulWidget {
  @override
  _AvailableWifiState createState() => _AvailableWifiState();
}

class _AvailableWifiState extends State<AvailableWifi> {
  String _platformVersion = 'Unknown';
  var listAvailableWifi = List<dynamic>();
  bool isLoading = false;
  double _signalStrength = 0.0;
  bool _isClicked = false;
  bool isConnectioState = true;
  int connectedWifiIndex;

  void _changevalue(double value) {
    setState(() {
      _signalStrength = value;
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    getConnectionState();
    setState(() {});
  }

  @override
  void initState() {
    isLoading = true;
    super.initState();
    getConnectionState().then((value) async {
      for (int i = 0; i < value.length; i++) {
        bool isConnected =
            await WifiConfiguration.isConnectedToWifi("${value[i].toString()}");
        if (isConnected) {
          print("Connected Wifi is -----${listAvailableWifi[i].toString()}");
          connectedWifiIndex = i;
        }
      }
      setState(() {
        isLoading = false;
        // Timer.periodic(Duration(seconds: 3), (timer) {
        //   getConnectionState();
        //   setState(() {});
        // });
      });
    });
  }

  Future<List<dynamic>> getConnectionState() async {
    listAvailableWifi = await WifiConfiguration.getWifiList();
    print("get wifi list : " + listAvailableWifi.toString());
    WifiConnectionStatus connectionStatus =
        await WifiConfiguration.connectToWifi(
            "Developers", "@12345678", "com.example.wifi_connectivity_flutter");
    print("is Connected : $connectionStatus");
    isConnectioState = true;

    // switch (connectionStatus) {
    //   case WifiConnectionStatus.connected:
    //     print("connected");
    //     return "connected";
    //     break;
    //
    //   case WifiConnectionStatus.alreadyConnected:
    //     print("alreadyConnected");
    //     return "alreadyConnected";
    //     break;
    //
    //   case WifiConnectionStatus.notConnected:
    //     print("notConnected");
    //     return "notConnected";
    //     break;
    //
    //   case WifiConnectionStatus.platformNotSupported:
    //     print("platformNotSupported");
    //     return "platformNotSupported";
    //     break;
    //
    //   case WifiConnectionStatus.profileAlreadyInstalled:
    //     print("profileAlreadyInstalled");
    //     return "profileAlreadyInstalled";
    //     break;
    //
    //   case WifiConnectionStatus.locationNotAllowed:
    //     print("locationNotAllowed");
    //     return "locationNotAllowed";
    //     break;
    // }

    return listAvailableWifi;
    // bool isConnected = await WifiConfiguration.isConnectedToWifi("DBWSN5");
    // String connectionState = await WifiConfiguration.connectedToWifi();
    // print("connection status ${connectionState}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF58328C),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                color: const Color(0xFF58328C),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color:
                                    const Color(0xFF6A3CA8).withOpacity(0.84),
                              ),
                              child: Container(
                                //  width: 52.0,
                                //height: 52.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF57318B),
                                ),
                                child:
                                    SvgPicture.asset("assets/back arrow.svg"),
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
                          MaterialButton(
                            height: 56,
                            splashColor: Colors.deepPurple,
                            color: const Color(0xFF6A3CA8).withOpacity(0.84),
                            shape: CircleBorder(),
                            onPressed: () {
                              setState(() {
                                // isConnectioState == false;
                                if (isConnectioState) {
                                  //getConnectionState();
                                  refreshList();
                                  isConnectioState = false;
                                } else {
                                  print(
                                      "button cannot work unless connection completed");
                                }
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(),
                                child: Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.17, -1.0),
                    end: Alignment(0.16, 1.0),
                    colors: [const Color(0xFF58328C), const Color(0xFF2D155B)],
                  ),
                ),
                child: Center(
                  child: isLoading == true
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Column(
                          children: [
                            Expanded(
                                child: RefreshIndicator(
                              onRefresh: refreshList,
                              child: ListView.builder(
                                itemCount: listAvailableWifi.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.000,
                                        //bottom: 5.0,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.07,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.06),
                                    child: Container(
                                      //  height: height * 0.08,
                                      decoration: BoxDecoration(
                                          //color: Theme.of(context).colorScheme.surface,
                                          // borderRadius: BorderRadius.all(
                                          //     Radius.circular(12)),
                                          border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.white24),
                                      )),
                                      child: RefreshIndicator(
                                        onRefresh: refreshList,
                                        child: ListTile(
                                            onTap: () {
                                              //showDialog(context: context, builder: builder)
                                              index != connectedWifiIndex
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              SettingScreen(
                                                                wifiName: listAvailableWifi[
                                                                        index]
                                                                    .toString(),
                                                              )))
                                                  : "";
                                            },
                                            title: Text(
                                              '${listAvailableWifi[index].toString()}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              index == connectedWifiIndex
                                                  ? "Connected"
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.orangeAccent),
                                            ),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/lock.svg"),
                                                // Icon(
                                                //   Icons.lock,
                                                //   color: Colors.white,
                                                // ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                SvgPicture.asset(
                                                    "assets/wifi.svg"),
                                                // SignalStrengthIndicator
                                                //     .sector(
                                                //   // value: wifi.level==1? 0.2:wifi.level==2? 0.4:wifi.level==3?0.7:0,
                                                //   value: _signalStrength == 1
                                                //       ? 0.2
                                                //       : _signalStrength == 2
                                                //           ? 0.4
                                                //           : _signalStrength ==
                                                //                   3
                                                //               ? 0.7
                                                //               : 0,
                                                //   size: 24,
                                                //   barCount: 4,
                                                //   spacing: 0.5,
                                                //   inactiveColor: Colors.grey,
                                                //   activeColor: Colors.white,
                                                // )
                                              ],
                                            )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _refreshed() async {
    setState(() {
      Center(
        child: isLoading == true
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: listAvailableWifi.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.005,
                              //bottom: 5.0,
                              left: MediaQuery.of(context).size.width * 0.08,
                              right: MediaQuery.of(context).size.width * 0.08),
                          child: Container(
                            //  height: height * 0.08,
                            decoration: BoxDecoration(
                                //color: Theme.of(context).colorScheme.surface,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x20000000),
                                      blurRadius: 10.0,
                                      spreadRadius: 10.0,
                                      offset: Offset(0, 3))
                                ]),
                            child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingScreen(
                                                wifiName:
                                                    listAvailableWifi[index]
                                                        .toString(),
                                              )));
                                },
                                title: Text(
                                  '${listAvailableWifi[index].toString()}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.wifi,
                                      color: Colors.white,
                                    ),
                                    // SignalStrengthIndicator.sector(
                                    //   // value: wifi.level==1? 0.2:wifi.level==2? 0.4:wifi.level==3?0.7:0,
                                    //   value: _signalStrength == 1
                                    //       ? 0.2
                                    //       : _signalStrength == 2
                                    //           ? 0.4
                                    //           : _signalStrength == 3
                                    //               ? 0.7
                                    //               : 0,
                                    //   size: 24,
                                    //   barCount: 4,
                                    //   spacing: 0.5,
                                    //   inactiveColor: Colors.grey,
                                    //   activeColor: Colors.white,
                                    // )
                                  ],
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      );
    });
    Completer<Null> completer = new Completer<Null>();
    new Future.delayed(Duration(seconds: 1)).then((_) {
      completer.complete();
    });
    return completer.future;
  }
}






// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:wifi_configuration/wifi_configuration.dart';
// import 'SettingScreen.dart';

// class AvailableWifi extends StatefulWidget {
//   @override
//   _AvailableWifiState createState() => _AvailableWifiState();
// }

// class _AvailableWifiState extends State<AvailableWifi> {
//   String _platformVersion = 'Unknown';
//   var listAvailableWifi = List<dynamic>();
//   bool isLoading = false;
//   double _signalStrength = 0.0;
//   bool _isClicked = false;
//   bool isConnectioState = true;
//   int connectedWifiIndex;

//   void _changevalue(double value) {
//     setState(() {
//       _signalStrength = value;
//     });
//   }

//   Future<Null> refreshList() async {
//     await Future.delayed(Duration(seconds: 2));
//     getConnectionState();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     isLoading = true;
//     super.initState();
//     getConnectionState().then((value) async {
//       for (int i = 0; i < value.length; i++) {
//         bool isConnected =
//             await WifiConfiguration.isConnectedToWifi("${value[i].toString()}");
//         if (isConnected) {
//           print("Connected Wifi is -----${listAvailableWifi[i].toString()}");
//           connectedWifiIndex = i;
//         }
//       }
//       setState(() {
//         isLoading = false;
//         // Timer.periodic(Duration(seconds: 3), (timer) {
//         //   getConnectionState();
//         //   setState(() {});
//         // });
//       });
//     });
//   }

//   Future<List<dynamic>> getConnectionState() async {
//     listAvailableWifi = await WifiConfiguration.getWifiList();
//     print("get wifi list : " + listAvailableWifi.toString());
//     WifiConnectionStatus connectionStatus =
//         await WifiConfiguration.connectToWifi(
//             "Developers", "@12345678", "com.example.wifi_connectivity_flutter");
//     print("is Connected : $connectionStatus");
//     isConnectioState = true;

//     // switch (connectionStatus) {
//     //   case WifiConnectionStatus.connected:
//     //     print("connected");
//     //     return "connected";
//     //     break;
//     //
//     //   case WifiConnectionStatus.alreadyConnected:
//     //     print("alreadyConnected");
//     //     return "alreadyConnected";
//     //     break;
//     //
//     //   case WifiConnectionStatus.notConnected:
//     //     print("notConnected");
//     //     return "notConnected";
//     //     break;
//     //
//     //   case WifiConnectionStatus.platformNotSupported:
//     //     print("platformNotSupported");
//     //     return "platformNotSupported";
//     //     break;
//     //
//     //   case WifiConnectionStatus.profileAlreadyInstalled:
//     //     print("profileAlreadyInstalled");
//     //     return "profileAlreadyInstalled";
//     //     break;
//     //
//     //   case WifiConnectionStatus.locationNotAllowed:
//     //     print("locationNotAllowed");
//     //     return "locationNotAllowed";
//     //     break;
//     // }

//     return listAvailableWifi;
//     // bool isConnected = await WifiConfiguration.isConnectedToWifi("DBWSN5");
//     // String connectionState = await WifiConfiguration.connectedToWifi();
//     // print("connection status ${connectionState}");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xFF58328C),
//         body: Stack(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10),
//               child: Container(
//                 color: const Color(0xFF58328C),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     SizedBox(
//                       width: 59.0,
//                       height: 60.0,
//                       child: Stack(
//                         children: <Widget>[
//                           Positioned(
//                             right: 0,
//                             bottom: 0,
//                             child: Container(
//                               width: 56.0,
//                               height: 56.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: const Color(0xFF2D155B),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.pop(context);
//                               //Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 56.0,
//                               height: 56.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:
//                                     const Color(0xFF6A3CA8).withOpacity(0.84),
//                               ),
//                               child: Container(
//                                 //  width: 52.0,
//                                 //height: 52.0,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: const Color(0xFF57318B),
//                                 ),
//                                 child:
//                                     SvgPicture.asset("assets/back arrow.svg"),
//                                 // Icon(
//                                 //   Icons.arrow_back,
//                                 //   color: Colors.white,
//                                 // ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 59.0,
//                       height: 60.0,
//                       child: Stack(
//                         children: <Widget>[
//                           Positioned(
//                             right: 0,
//                             bottom: 0,
//                             child: Container(
//                               width: 56.0,
//                               height: 56.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: const Color(0xFF2D155B),
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 if (isConnectioState) {
//                                   //getConnectionState();
//                                   refreshList();
//                                   isConnectioState = false;
//                                 } else {
//                                   print(
//                                       "button cannot work unless connection completed");
//                                 }
//                               });
//                             },
//                             child: Container(
//                               alignment: Alignment.center,
//                               width: 56.0,
//                               height: 56.0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color:
//                                     const Color(0xFF6A3CA8).withOpacity(0.84),
//                               ),
//                               child: Container(
//                                 width: 52.0,
//                                 height: 52.0,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: const Color(0xFF57318B),
//                                 ),
//                                 child: (isConnectioState == true)
//                                     ? Icon(
//                                         Icons.refresh,
//                                         color: Colors.white,
//                                       )
//                                     : CircularProgressIndicator(),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 80),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment(0.17, -1.0),
//                     end: Alignment(0.16, 1.0),
//                     colors: [const Color(0xFF58328C), const Color(0xFF2D155B)],
//                   ),
//                 ),
//                 child: Center(
//                   child: isLoading == true
//                       ? Container(
//                           child: Center(
//                             child: CircularProgressIndicator(),
//                           ),
//                         )
//                       : Column(
//                           children: [
//                             Expanded(
//                                 child: RefreshIndicator(
//                               onRefresh: refreshList,
//                               child: ListView.builder(
//                                 itemCount: listAvailableWifi.length,
//                                 itemBuilder: (context, index) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                         top:
//                                             MediaQuery.of(context).size.height *
//                                                 0.000,
//                                         //bottom: 5.0,
//                                         left:
//                                             MediaQuery.of(context).size.width *
//                                                 0.07,
//                                         right:
//                                             MediaQuery.of(context).size.width *
//                                                 0.06),
//                                     child: Container(
//                                       //  height: height * 0.08,
//                                       decoration: BoxDecoration(
//                                           //color: Theme.of(context).colorScheme.surface,
//                                           // borderRadius: BorderRadius.all(
//                                           //     Radius.circular(12)),
//                                           border: Border(
//                                         bottom: BorderSide(
//                                             width: 0.5, color: Colors.white24),
//                                       )),
//                                       child: RefreshIndicator(
//                                         onRefresh: refreshList,
//                                         child: ListTile(
//                                             onTap: () {
//                                               //showDialog(context: context, builder: builder)
//                                               index != connectedWifiIndex
//                                                   ? Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (BuildContext
//                                                                   context) =>
//                                                               SettingScreen(
//                                                                 wifiName: listAvailableWifi[
//                                                                         index]
//                                                                     .toString(),
//                                                               )))
//                                                   : "";
//                                             },
//                                             title: Text(
//                                               '${listAvailableWifi[index].toString()}',
//                                               style: TextStyle(
//                                                   color: Colors.white),
//                                             ),
//                                             subtitle: Text(
//                                               index == connectedWifiIndex
//                                                   ? "Connected"
//                                                   : "",
//                                               style: TextStyle(
//                                                   color: Colors.orangeAccent),
//                                             ),
//                                             trailing: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 SvgPicture.asset(
//                                                     "assets/lock.svg"),
//                                                 // Icon(
//                                                 //   Icons.lock,
//                                                 //   color: Colors.white,
//                                                 // ),
//                                                 SizedBox(
//                                                   width: 20,
//                                                 ),
//                                                 SvgPicture.asset(
//                                                     "assets/wifi.svg"),
//                                                 // SignalStrengthIndicator
//                                                 //     .sector(
//                                                 //   // value: wifi.level==1? 0.2:wifi.level==2? 0.4:wifi.level==3?0.7:0,
//                                                 //   value: _signalStrength == 1
//                                                 //       ? 0.2
//                                                 //       : _signalStrength == 2
//                                                 //           ? 0.4
//                                                 //           : _signalStrength ==
//                                                 //                   3
//                                                 //               ? 0.7
//                                                 //               : 0,
//                                                 //   size: 24,
//                                                 //   barCount: 4,
//                                                 //   spacing: 0.5,
//                                                 //   inactiveColor: Colors.grey,
//                                                 //   activeColor: Colors.white,
//                                                 // )
//                                               ],
//                                             )),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )),
//                           ],
//                         ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<Null> _refreshed() async {
//     setState(() {
//       Center(
//         child: isLoading == true
//             ? Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : Column(
//                 children: [
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: listAvailableWifi.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: EdgeInsets.only(
//                               top: MediaQuery.of(context).size.height * 0.005,
//                               //bottom: 5.0,
//                               left: MediaQuery.of(context).size.width * 0.08,
//                               right: MediaQuery.of(context).size.width * 0.08),
//                           child: Container(
//                             //  height: height * 0.08,
//                             decoration: BoxDecoration(
//                                 //color: Theme.of(context).colorScheme.surface,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(12)),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color(0x20000000),
//                                       blurRadius: 10.0,
//                                       spreadRadius: 10.0,
//                                       offset: Offset(0, 3))
//                                 ]),
//                             child: ListTile(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => SettingScreen(
//                                                 wifiName:
//                                                     listAvailableWifi[index]
//                                                         .toString(),
//                                               )));
//                                 },
//                                 title: Text(
//                                   '${listAvailableWifi[index].toString()}',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.lock,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Icon(
//                                       Icons.wifi,
//                                       color: Colors.white,
//                                     ),
//                                     // SignalStrengthIndicator.sector(
//                                     //   // value: wifi.level==1? 0.2:wifi.level==2? 0.4:wifi.level==3?0.7:0,
//                                     //   value: _signalStrength == 1
//                                     //       ? 0.2
//                                     //       : _signalStrength == 2
//                                     //           ? 0.4
//                                     //           : _signalStrength == 3
//                                     //               ? 0.7
//                                     //               : 0,
//                                     //   size: 24,
//                                     //   barCount: 4,
//                                     //   spacing: 0.5,
//                                     //   inactiveColor: Colors.grey,
//                                     //   activeColor: Colors.white,
//                                     // )
//                                   ],
//                                 )),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//       );
//     });
//     Completer<Null> completer = new Completer<Null>();
//     new Future.delayed(Duration(seconds: 1)).then((_) {
//       completer.complete();
//     });
//     return completer.future;
//   }
// }
