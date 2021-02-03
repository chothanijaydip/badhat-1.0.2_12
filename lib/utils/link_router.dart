import 'package:flutter/material.dart';

gotoLinkPage({
  @required String link,
  @required BuildContext context,
  @required VoidCallback onBack,
}) {
  int destinationPayloadId =
      int.parse(link.substring(link.lastIndexOf("/") + 1));
  String destinationName;

  if (link.contains("product")) {
    destinationName = "product_detail";
  } else if (link.contains("user")) {
    destinationName = "vendor_profile";
  }

  if (destinationName != null && destinationPayloadId != null) {
    String argDestinationPayloadId;
    if (destinationName == "product_detail") {
      argDestinationPayloadId = "id";
    } else if (destinationName == "vendor_profile") {
      argDestinationPayloadId = "user_id";
    }

    Navigator.pushNamed(context, destinationName, arguments: {
      argDestinationPayloadId: destinationPayloadId,
    }).then((value) {
      print("callback");
      onBack();
    });
  }
}
