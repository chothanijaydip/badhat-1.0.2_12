import 'dart:async';

import 'package:badhat_b2b/main.dart';
import 'package:badhat_b2b/utils/link_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isNavigatedToNewPage = false;
  String tokenPref;
  double version;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  StreamSubscription _uniLinkStreamSub;

  Future<Null> initUniLinks() async {
    try {
      String initialLink = await getInitialLink();

      _uniLinkStreamSub = getLinksStream().listen(
        (String link) {
          if (link != null) initialLink = link;
        },
        //onError: (err) {},
      );

      if (initialLink == null) {
        return;
      } else {
        setState(() => isNavigatedToNewPage = true);
        gotoLinkPage(
          link: initialLink,
          context: context,
          onBack: () {
            setState(() => isNavigatedToNewPage = false);
            navigateToLogin();
          },
        );
      }

//       print(initialLink);
//       destinationPayloadId =
//           int.parse(initialLink.substring(initialLink.lastIndexOf("/") + 1));
//       if (initialLink.contains("product")) {
// //        print(destinationPayloadId);
//         destinationName = "product_detail";
//       }
//       if (initialLink.contains("user")) {
//         destinationName = "vendor_profile";
//       }
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  void navigateToLogin() async {
    Timer(Duration(microseconds: 20), () async {
      await requestAppStateApi();
      await requestDetailsApi();
      if (tokenPref == null || tokenPref.isEmpty) {
        _initPackageInfo();
        if (!isNavigatedToNewPage)
          Navigator.of(context).pushReplacementNamed("info");
      } else {
        _initPackageInfo();
        if (!isNavigatedToNewPage)
          Navigator.of(context).pushReplacementNamed("dashboard");
      }
    });
  }

  _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    if (_packageInfo.version != _packageInfo.version) checkVersion(context);
  }

  checkVersion(context) {
    if (_packageInfo.version == _packageInfo.version) {
      showVersionDialog(context);
    }
  }

  showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                child: Text(btnLabel),
                onPressed: () {
                  _launchURL();
                }),
          ],
        );
      },
    );
  }

  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.badhat.app';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> requestDetailsApi() async {
    Response response = await dio.get('appDetails',
        options: Options(headers: {"Authorization": "Bearer $tokenPref"}));

    if (response.statusCode == 200) {
      await setVersion(response.data);
    } else {}

    return Future.value(null);
  }

  Future<void> requestAppStateApi() {
    if (tokenPref != null) {
      return dio
          .get('appState',
              options: Options(headers: {"Authorization": "Bearer $tokenPref"}))
          .catchError((e) {})
          .then((response) {
        if (response.statusCode == 200) {
          print(response.data["data"]["notification"]);
          notificationCountController
              .add(response.data["data"]["notification"]);
          cartCountController.add(response.data["data"]["cart"]);
          orderCountController.add(response.data["data"]["order"]);
        } else {}
      }).catchError((e) {});
    }
    return Future.value(null);
  }

  @override
  void didChangeDependencies() async {
    await loadToken();
    if (tokenPref != null) await initUniLinks();
    navigateToLogin();
    super.didChangeDependencies();
  }

  Future<Null> loadToken() async {
    var pref = await SharedPreferences.getInstance();
    tokenPref = pref.getString("token");
  }

  Future<Null> setVersion(version) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("version", version["data"]["app_details"][0]['version']);
  }

  // @override
  // void dispose() {
  //   _uniLinkStreamSub.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: Center(
            child: Image.asset(
              "assets/images/badhat.png",
              fit: BoxFit.none,
            ),
          )),
    );
  }
}
