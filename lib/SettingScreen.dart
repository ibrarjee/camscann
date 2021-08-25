import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:wifi_configuration/wifi_configuration.dart';

import 'HomeScreen.dart';

class SettingScreen extends StatefulWidget {
  final String wifiName;

  SettingScreen({Key key, this.wifiName}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  TextEditingController _controllerWifiPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void validate() {
    if (_formKey.currentState.validate()) {
      print("ok");
    } else {
      print("Error");
    }
  }

  bool _isHidden;
  String wifiName;
  String value;
  bool isConnectionComplete = false;

  @override
  void initState() {
    // TODO: implement initState
    wifiName = widget.wifiName;
    setState(() {
      setVariable();
    });
    super.initState();
  }

  setVariable() {
    setState(() {
      _isHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: const Color(0xFF58328C),
      backgroundColor: Color(0xFF2D155B),
      body: ProgressHUD(
        backgroundColor: Colors.black26,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.17, -1.0),
              end: Alignment(0.16, 1.0),
              colors: [const Color(0xFF58328C), const Color(0xFF2D155B)],
            ),
          ),
          child: Builder(
            builder: (context) => ListView(
              children: [
                Column(
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF2D155B),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
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
                                      //width: 52.0,
                                      //height: 52.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF57318B),
                                      ),
                                      child: SvgPicture.asset(
                                          "assets/back arrow.svg"),
                                      // Icon(
                                      //   Icons.arrow_back,
                                      //   size: 25,
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
                    Padding(
                        padding: const EdgeInsets.only(left: 40, top: 40),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Center(
                                child: Form(
                                    key: _formKey,
                                    autovalidate: true,
                                    child: Container(
                                      height: 50,
                                      width: 400,
                                      //color: Colors.blue,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter password of "$wifiName"';
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {},

                                              obscureText: _isHidden,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Password',
                                                hintStyle: TextStyle(
                                                    color: Colors.white),
                                                // suffixIcon: IconButton(
                                                //     icon: Icon(Icons.clear),
                                                //     color: Colors.white,
                                                //     onPressed: () {
                                                //       _controllerWifiPassword
                                                //           .clear();
                                                //     }),
                                              ),
                                              // onTap: _togglePasswordView,
                                              controller:
                                                  _controllerWifiPassword,

                                              cursorColor: Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.clear),
                                            iconSize: 20,
                                            color: Colors.white,
                                            splashColor: Colors.purple,
                                            onPressed: () {
                                              _controllerWifiPassword.clear();
                                            },
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            Divider(
                              color: Colors.white38,
                              endIndent: 45,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Checkbox(
                                      value: !_isHidden,
                                      onChanged: (value) {
                                        _togglePasswordView();
                                      },
                                    ),
                                    onTap: _togglePasswordView,
                                  ),
                                  Text(
                                    "Show Password",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 120.0,
                                    height: 54.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(29.0),
                                      color: const Color(0xFF2D155B),
                                      //color:const Color(0xFF58328C)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: InkWell(
                                        onTap: () async {
                                          validate();
                                          // if(!isConnectionComplete){
                                          final progress =
                                              ProgressHUD.of(context);
                                          progress
                                              ?.showWithText('Connecting...');
                                          setState(() {});
                                          // }else{
                                          //   print("Connection completed");
                                          // }

                                          // if(_formKey.currentState.validate()){
                                          //   // Scaffold.of(context)
                                          //   //     .showSnackBar(SnackBar(content: Text('Processing Data')));
                                          // }
                                          if (_controllerWifiPassword
                                              .text.isEmpty) {
                                            // EdgeAlert.show(context,
                                            //     //title: 'Alert',
                                            //     backgroundColor: Colors.red,
                                            //     icon: Icons
                                            //         .error_outline_outlined,
                                            //     description:
                                            //         'Please Enter the Password',
                                            //     gravity: EdgeAlert.TOP);
                                            progress.dismiss();
                                            //print("Enter Password");
                                          } else {
                                            SimpleDialog(
                                              title: new Text('Test'),
                                            );
                                            // WifiConnectionStatus connectionStatus =
                                            //      await
                                            WifiConfiguration.connectToWifi(
                                                    "$wifiName",
                                                    "${_controllerWifiPassword.text}",
                                                    "com.example.themeproject")
                                                .then((value) {
                                              //  progress.dismiss();
                                              print(
                                                  "--------------------Connection status---------------${value.toString()}");
                                              if (value ==
                                                  WifiConnectionStatus
                                                      .connected) {
                                                //print("Connected successfully");
                                                EdgeAlert.show(context,
                                                    //title: 'Alert',
                                                    backgroundColor:
                                                        Colors.blueGrey,
                                                    description:
                                                        '"$wifiName" Connected Sucessfully',
                                                    icon: Icons.check,
                                                    gravity: EdgeAlert.TOP);
                                                Future.delayed(
                                                    Duration(seconds: 2), () {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(),
                                                      ),
                                                      (route) => false);
                                                });
                                                isConnectionComplete = true;
                                              }
                                              if (value ==
                                                  WifiConnectionStatus
                                                      .notConnected) {
                                                EdgeAlert.show(context,
                                                    //title: 'Alert',
                                                    backgroundColor: Colors.red,
                                                    description:
                                                        '"$wifiName"incorrect password',
                                                    icon: Icons.clear,
                                                    gravity: EdgeAlert.TOP);
                                              } else if (value ==
                                                  WifiConnectionStatus
                                                      .alreadyConnected) {
                                                print("alreadyConnected");
                                              } else if (value ==
                                                  WifiConnectionStatus
                                                      .platformNotSupported) {
                                                print("platformNotSupported");
                                              } else if (value ==
                                                  WifiConnectionStatus
                                                      .locationNotAllowed) {
                                                print("locationNotAllowed");
                                              } else if (value ==
                                                  WifiConnectionStatus
                                                      .profileAlreadyInstalled) {
                                                print(
                                                    "profileAlreadyInstalled");
                                              }
                                              progress.dismiss();
                                            });
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 130.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(29.0),
                                            //color: const Color(0xFF58328C),
                                            color: const Color(0xFF2D155B),
                                          ),
                                          child: Text(
                                            "Join",
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 23.0,
                                              color: Colors.white,
                                              letterSpacing: 0.276,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
    print(_isHidden);
  }
}

class ShowDialog {}
