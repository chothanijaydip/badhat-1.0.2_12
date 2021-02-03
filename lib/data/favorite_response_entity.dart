import 'package:badhat_b2b/generated/json/base/json_convert_content.dart';
import 'package:badhat_b2b/generated/json/base/json_filed.dart';

class FavoriteResponseEntity with JsonConvert<FavoriteResponseEntity> {
  List<FavoriteResponseData> data;
  String message;
}

class RecommendedResponseEntity with JsonConvert<RecommendedResponseEntity> {
  List<FavoriteResponseDataVendor> data;
  String message;
}

class FavoriteResponseData with JsonConvert<FavoriteResponseData> {
  int id;
  @JSONField(name: "user_id")
  int userId;
  @JSONField(name: "vendor_id")
  int vendorId;
  @JSONField(name: "created_at")
  String createdAt;
  @JSONField(name: "updated_at")
  String updatedAt;
  FavoriteResponseDataVendor vendor;
  @JSONField(name: "vendor_retailer")
  Map vendorRetailer;
}

class FavoriteResponseDataVendor with JsonConvert<FavoriteResponseDataVendor> {
  int id;
  String name;
  dynamic email;
  String image;
  @JSONField(name: "business_name")
  String businessName;
  String mobile;
  String state;
  String district;
  dynamic pincode;
  String latitude;
  String longitude;
  @JSONField(name: "business_type")
  String businessType;
  @JSONField(name: "business_category")
  String businessCategory;
  int status;
  @JSONField(name: "created_at")
  String createdAt;
  @JSONField(name: "updated_at")
  String updatedAt;
  @JSONField(name: "room_id")
  int roomId;
}

// class FavoriteResponseDataVendorRetailer
//     with JsonConvert<FavoriteResponseDataVendor> {
//   int id;
//   @JSONField(name: "org_name")
//   String name;
//   dynamic email;
//   String image;
//   @JSONField(name: "business_name")
//   String businessName;
//   @JSONField(name: "org_phone")
//   String mobile;
//   String state;
//   String district;
//   dynamic pincode;
//   String latitude;
//   String longitude;
//   @JSONField(name: "business_type")
//   String businessType;
//   @JSONField(name: "business_category")
//   String businessCategory;
//   int status;
//   @JSONField(name: "created_at")
//   String createdAt;
//   @JSONField(name: "updated_at")
//   String updatedAt;
//   @JSONField(name: "room_id")
//   int roomId;
// }
