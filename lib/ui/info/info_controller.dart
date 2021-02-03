import 'package:badhat_b2b/ui/info/info_view.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatefulWidget {
  @override
  InfoScreenState createState() => InfoScreenState();
}

class InfoScreenState extends State<InfoScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  @override
  Widget build(BuildContext context) => InfoView(this);

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    if(_packageInfo.version != _packageInfo.version)
      checkVersion(context);
  }
    checkVersion(context){
      if(_packageInfo.version == _packageInfo.version){
        showVersionDialog(context);
      }
    }

    showVersionDialog( context) async {
      await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: ( context) {
          String title = "New Update Available";
          String message =
              "There is a newer version of app available please update it now.";
          String btnLabel = "Update Now";

          return
            AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    child: Text(btnLabel),
                    onPressed: () {
                      _launchURL();
                    }
                ),

              ],
            );
        },
      );
    }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }



  // variables

  // methods


}
