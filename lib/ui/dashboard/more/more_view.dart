import 'package:badhat_b2b/main.dart';
import 'package:badhat_b2b/ui/dashboard/more/more_controller.dart';
import 'package:badhat_b2b/widgets/app_bar.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/extensions.dart';

class MoreView extends WidgetView<MoreScreen, MoreScreenState> {
  MoreView(MoreScreenState state) : super(state);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyAppBar("More").paddingAll(10),
              Divider(
                thickness: 1.1,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.menuItems.length,
                  separatorBuilder: (context, position) {
                    return Divider();
                  },
                  itemBuilder: (context, position) {
                    var item = state.menuItems[position];
                    return Row(
                      children: <Widget>[
                        Expanded(child: Text(item).paddingLeft(16)),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                      ],
                    ).paddingFromLTRB(16, 8, 16, 8).onClick(() async {
                      switch (position) {
                        case 0:
                          Navigator.pushNamed(context, "my_profile");
                          break;
                        case 1:
                          Navigator.pushNamed(context, "vendor_profile",
                              arguments: {
                                "user_id": userId,
                              });
                          break;
                        case 2:
                          Navigator.pushNamed(context, "about");
                          break;
                        case 3:
                          canLaunch("https://badhat.app/privacy-policy.php")
                              .then((value) {
                            if (value)
                              launch("https://badhat.app/privacy-policy.php");
                          });

                          //Navigator.pushNamed(context, "policies");
                          break;
                        case 4:
                          Navigator.pushNamed(context, "how_to");
                          break;
                        case 5:
                          state.navigateToAdminChat();
                          break;
                        default:
                      }
                    });
                  }),
              if (userId != 1)
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 8),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 38, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Container(
                      width: 170,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Share Your Store"),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Image.asset(
                              "assets/images/facebook_logo.png",
                              width: 30,
                            ),
                          ),
                          Image.asset(
                            "assets/images/whatsapp_logo.png",
                            width: 25,
                          )
                        ],
                      ),
                    ),
                    onPressed: () async {
                      await Share.share("https://badhat.app/user/$userId");
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Text("Logout"),
                  onPressed: () async {
                    await state.logout();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
