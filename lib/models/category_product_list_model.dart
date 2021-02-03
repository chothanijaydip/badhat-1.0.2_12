class CategoryProductListModel {
  List<CategoryProductModel> data;
  String message;

  CategoryProductListModel({this.data, this.message});

  CategoryProductListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CategoryProductModel>();
      json['data'].forEach((v) {
        data.add(new CategoryProductModel.fromJson(v));
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

class CategoryProductModel {
  int id;
  String name;
  int categoryId;
  int subCategoryId;
  int verticalId;
  String image;
  int userId;
  String description;
  int moq;
  int price;
  int status;
  int isDeleted;
  String createdAt;
  String updatedAt;
  bool canDelete;
  Category category;
  Subcategory subcategory;
  Vertical vertical;

  CategoryProductModel(
      {this.id,
      this.name,
      this.categoryId,
      this.subCategoryId,
      this.verticalId,
      this.image,
      this.userId,
      this.description,
      this.moq,
      this.price,
      this.status,
      this.isDeleted,
      this.createdAt,
      this.updatedAt,
      this.canDelete,
      this.category,
      this.subcategory,
      this.vertical});

  CategoryProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    verticalId = json['vertical_id'];
    image = json['image'];
    userId = json['user_id'];
    description = json['description'];
    moq = json['moq'];
    price = json['price'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    canDelete = json['can_delete'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subcategory = json['subcategory'] != null
        ? new Subcategory.fromJson(json['subcategory'])
        : null;
    vertical = json['vertical'] != null
        ? new Vertical.fromJson(json['vertical'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['vertical_id'] = this.verticalId;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['moq'] = this.moq;
    data['price'] = this.price;
    data['status'] = this.status;
    data['isDeleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['can_delete'] = this.canDelete;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory.toJson();
    }
    if (this.vertical != null) {
      data['vertical'] = this.vertical.toJson();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  String icon;
  String bgImage;
  String createdAt;
  String updatedAt;

  Category(
      {this.id,
      this.name,
      this.icon,
      this.bgImage,
      this.createdAt,
      this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
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

class Subcategory {
  int id;
  String name;
  int categoryId;
  String updatedAt;
  String createdAt;

  Subcategory(
      {this.id, this.name, this.categoryId, this.updatedAt, this.createdAt});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Vertical {
  int id;
  String name;
  int subcategoryId;
  String updatedAt;
  String createdAt;

  Vertical(
      {this.id, this.name, this.subcategoryId, this.updatedAt, this.createdAt});

  Vertical.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    subcategoryId = json['subcategory_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['subcategory_id'] = this.subcategoryId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
