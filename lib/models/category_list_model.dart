class CategoryListModel {
  List<CategoryModel> data;
  String message;

  CategoryListModel({this.data, this.message});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CategoryModel>();
      json['data'].forEach((v) {
        data.add(new CategoryModel.fromJson(v));
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

class CategoryModel {
  int id;
  String name;
  String icon;
  String bgImage;
  String createdAt;
  String updatedAt;

  CategoryModel(
      {this.id,
      this.name,
      this.icon,
      this.bgImage,
      this.createdAt,
      this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    bgImage = json['bg_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['bg_image'] = this.bgImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
