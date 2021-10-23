import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hkun/helpers/size_config.dart';
import 'package:hkun/screens/home/home_screen.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:progress_indicators/progress_indicators.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HKUN',
      theme: ThemeData(
        primaryColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: FutureBuilder(
        future: setupRemoteConfig(),
        builder: (context, snapshot) {
          SizeConfig().init(context);
          if (snapshot.hasData) {
            if (snapshot.data as bool) {
              return HomeScreen();
            } else {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A new version is available!'.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      Text(
                        'Please update your app to continue using it.',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.1),
                      InkWell(
                        onTap: () {
                          LaunchReview.launch();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Color(0xFFEEEEEE)),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              'UPDATE NOW',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEEEEEE)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: SizeConfig.paddingTop),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HeartbeatProgressIndicator(
                    child: Image.asset('assets/images/tata_bull_logo.png',
                        width: 100.0),
                  ),
                  SizedBox(height: 32.0),
                  Text('Checking app version...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    final _appVersion = remoteConfig.getString('app_version');
    final _codeVersion = remoteConfig.getString('code_version');

    final packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final code = packageInfo.buildNumber;
    print('$_appVersion version. $_codeVersion code.');

    // return (_appVersion == version);
    if (_appVersion == null || _appVersion == '') return true;
    return (_appVersion == version && _codeVersion == code);
  }
}
