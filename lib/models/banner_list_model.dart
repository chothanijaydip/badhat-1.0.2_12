class BannerListModel {
  List<BannerModel> data;
  String message;

  BannerListModel({this.data, this.message});

  BannerListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BannerModel>();
      json['data'].forEach((v) {
        data.add(new BannerModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class BannerModel {
  int id;
  String bannerTitle;
  String bannerImage;
  String bannerUrl;
  int status;
  String createdAt;
  String updatedAt;

  BannerModel(
      {this.id,
      this.bannerTitle,
      this.bannerImage,
      this.bannerUrl,
      this.status,
      this.createdAt,
      this.updatedAt});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerTitle = json['banner_title'];
    bannerImage = json['banner_image'];
    bannerUrl = json['banner_url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_title'] = this.bannerTitle;
    data['banner_image'] = this.bannerImage;
    data['banner_url'] = this.bannerUrl;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
