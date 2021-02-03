import 'package:badhat_b2b/ui/login/login_controller.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:truecaller_sdk/truecaller_sdk.dart';

import '../../utils/extensions.dart';

class LoginView extends WidgetView<LoginScreen, LoginScreenState> {
  LoginView(LoginScreenState state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: state.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/badhat_logo.png",
              width: 80,
              height: 80,
            ).center(),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Enter Mobile number";
                if (value.length != 10) return "Enter 10 digit mobile number";
                return null;
              },
              keyboardType: TextInputType.numberWithOptions(signed: true),
              controller: state.username,
              maxLength: 10,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Mobile",
                prefix: Text("+91"),
              ),
            ).paddingAll(4),
            /*   TextFormField(
              validator: (value) {
                if (value.isEmpty) return "Enter valid password";
                return null;
              },
              controller: state.password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Password"),
            ).paddingAll(4),*/
            /* Text("Forgot Password?")
                .alignTo(Alignment.centerRight)
                .paddingTop(8)
                .onClick(() {
              Navigator.pushNamed(context, "forgot_password");
            }),*/
            if (state.loading)
              CircularProgressIndicator().container(height: 35).paddingAll(16)
            else
              Text("Send OTP")
                  .color(Colors.white)
                  .roundedBorder(
                    Theme.of(context).accentColor,
                    height: 44,
                  )
                  .onClick(() {
                state.requestOtp();
              }).paddingAll(16),
            if (state.isTruecallerUsable)
              StreamBuilder<TruecallerSdkCallback>(
                stream: state.truecallerStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data.result) {
                      case TruecallerSdkCallbackResult.success:
                        if (!state.alreadyVerifyingwithTruecaller) {
                          state.loginUsingTruecaller(
                            snapshot.data.profile.phoneNumber.substring(3),
                            snapshot.data.profile.payload,
                          );
                        }

                        return Text(
                          "Loging in with truecaller",
                        );
                      case TruecallerSdkCallbackResult.failure:
                        print("Oops!! Error type ${snapshot.data.error.code}");
                        return Text(
                          "error login with truecaller, please login with your mobile number",
                        );
                      default:
                        return Text("");
                    }
                  } else
                    return Text("");
                },
              )
          ],
        ).paddingAll(24),
      ),
    );
  }
}
