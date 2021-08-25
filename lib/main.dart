import 'dart:async';
import 'package:connection_verify/connection_verify.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internetspeedapplication/SettingScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_provider/theme_provider.dart';
import 'HomeScreen.dart';
import 'NetworksScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  getPermissions().then((value) {
    runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: false,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        String savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        } else {
          Brightness platformBrightness =
              SchedulerBinding.instance?.window.platformBrightness ??
                  Brightness.light;
          if (platformBrightness == Brightness.dark) {
            controller.setTheme('dark');
          } else {
            controller.setTheme('light');
          }
          controller.forgetSavedTheme();
        }
      },
      themes: <AppTheme>[
        AppTheme.light(id: 'light'),
        AppTheme.dark(id: 'dark'),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.themeOf(themeContext).data,
            title: 'Material App',
            home: Splashscreen(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  static final String customAppThemeId = 'custom_theme';

  AppTheme customAppTheme() {
    return AppTheme(
      id: customAppThemeId,
      description: "Custom Color Scheme",
      data: ThemeData(
        accentColor: Colors.yellow,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.yellow[200],
        buttonColor: Colors.amber,
        dialogBackgroundColor: Colors.yellow,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(primary: Colors.red),
        ),
      ),
    );
  }

  Future<bool> netcon() async {
    if (await ConnectionVerify.connectionStatus()) {
      return true;
      // print("I have network connection!");
      //Do your online stuff here
    } else {
      return false;
      // print("I don't have network connection!");
      //Do your offline stuff here
    }
  }

  @override
  Widget build(BuildContext context) {
    var controller = ThemeProvider.controllerOf(context);
    bool con = false;

    return Scaffold(
      appBar: AppBar(title: Text("Example App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current theme: ${controller.theme.id}'),
            RaisedButton(
                child: Text("Go setting"),
                onPressed: () async {
                  con = await netcon();
                  if (con) {
                  } else {
                    EdgeAlert.show(context,
                        title: 'Connection Alert',
                        description:
                            'You are not connected to internet at this time',
                        gravity: EdgeAlert.TOP);
                  }
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                })
          ],
        ),
      ),
    );
  }
}

class Splashscreen extends StatefulWidget {
  // const Splashscreen({Key key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool con = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () async {
      con = await netcon();
      if (con) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
    });
  }

  Future<bool> netcon() async {
    if (await ConnectionVerify.connectionStatus()) {
      return true;
      // print("I have network connection!");
      //Do your online stuff here
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.17, -1.0),
            end: Alignment(0.16, 1.0),
            colors: [const Color(0xFF58328C), const Color(0xFF2D155B)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/splash icon.svg"),
            SizedBox(
              height: 20,
            ),
            Text(
              'Internet Speed App',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 29.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        // child: SizedBox(
        //   width: 250.0,
        //   height: 926.0,
        //   child: Column(
        //     children: <Widget>[
        //       Spacer(flex: 201),
        //       Container(
        //         width: 250.0,
        //         height: 250.0,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: const Color(0xFF6D7EFF),
        //         ),
        //       ),
        //       Spacer(flex: 22),
        //       Container(
        //         width: 250.0,
        //         height: 250.0,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: const Color(0xFFAF8EFF),
        //         ),
        //       ),
        //       Spacer(flex: 203),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
