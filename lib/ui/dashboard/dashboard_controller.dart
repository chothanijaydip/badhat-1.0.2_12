import 'package:badhat_b2b/main.dart';
import 'package:badhat_b2b/ui/dashboard/home/home_controller.dart';
import 'package:badhat_b2b/ui/dashboard/message/message_controller.dart';
import 'package:badhat_b2b/ui/dashboard/more/more_controller.dart';
import 'package:badhat_b2b/ui/dashboard/orders/orders_controller.dart';
import 'package:badhat_b2b/ui/dashboard/products/products_controller.dart';
import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // PackageInfo _packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  // );

  String tokenPref;
  var screens = [
    HomeScreen(),
    ProductsScreen(),
    MessagesScreen(),
    OrdersScreen(),
    MoreScreen()
  ];
  var _items = [
    BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
    BottomNavigationBarItem(title: Text("Products"), icon: Icon(Icons.book)),
    BottomNavigationBarItem(title: Text("Chat"), icon: Icon(Icons.chat)),
    BottomNavigationBarItem(
      title: Text("Orders"),
      icon: Icon(Icons.airport_shuttle),
    ),
    BottomNavigationBarItem(title: Text("More"), icon: Icon(Icons.menu)),
  ];
  int screenIndex = 0;
//  BottomNavigationBadge badger;

  @override
  void initState() {
    /* _initPackageInfo();*/
//    badger = new BottomNavigationBadge(
//        backgroundColor: Colors.green,
//        badgeShape: BottomNavigationBadgeShape.circle,
//        textColor: Colors.white,
//        position: BottomNavigationBadgePosition.topRight,
//        textSize: 9);
//
//    orderCountController.stream.listen((value) {
//      if (value != null)
//        badger.setBadge(_items, value.toString(), 3);
//      else
//        badger.setBadge(_items, "0", 3);
//    });

    // Future.delayed(Duration(milliseconds: 1500), () {
    //   if (destinationName != null && destinationPayloadId != null) {
    //     if (destinationName == "product_detail") {
    //       Navigator.of(context).pushNamed("product_detail",
    //           arguments: {"id": destinationPayloadId});
    //     }
    //     if (destinationName == "vendor_profile") {
    //       Navigator.pushNamed(context, "vendor_profile", arguments: {
    //         "user_id": destinationPayloadId,
    //       });
    //     }
    //   }
    // });

    _initPackageInfo();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    var sp = await SharedPreferences.getInstance();
    userId = sp.getInt("user_id");
    token = sp.getString("token");
    super.didChangeDependencies();
  }

  _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    var pref = await SharedPreferences.getInstance();
    String versionFromApi = pref.getString("version");

    if (info.version != versionFromApi) {
      showVersionDialog(context);
    }

    // setState(() {
    //   _packageInfo = info;
    // });
    // if(_packageInfo.version != _packageInfo.version)
    //   checkVersion(context);
  }

  // checkVersion(context) {
  //   if (_packageInfo.version == _packageInfo.version) {
  //     showVersionDialog(context);
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: screenIndex,
          type: BottomNavigationBarType.fixed,
          items: _items,
          onTap: (index) {
            setState(() {
              screenIndex = index;
            });
          },
        ),
        body: screens[screenIndex],
      ),
    );
  }
}
