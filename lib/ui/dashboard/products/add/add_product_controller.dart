import 'dart:io';

import 'package:badhat_b2b/data/category_entity.dart';
import 'package:badhat_b2b/data/user_detail_response_entity.dart';
import 'package:badhat_b2b/generated/json/category_entity_helper.dart';
import 'package:badhat_b2b/generated/json/subcategoryresponse_entity_helper.dart';
import 'package:badhat_b2b/main.dart';
import 'package:badhat_b2b/ui/dashboard/products/add/add_product_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/product_detail_entity.dart';
import '../../../../data/subcategoryresponse_entity.dart';
import '../../../../generated/json/product_detail_entity_helper.dart';
import '../../../../generated/json/subcategoryresponse_entity_helper.dart';

class AddProductScreen extends StatefulWidget {
  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  @override
  Widget build(BuildContext context) => AddProductView(this);

  // variable
  File productImage;
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productMoq = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  int selectedSubCategory, selectedVertical;
  String selectedCategory;
  bool loading = false;
  bool editLoading = false;
  final formKey = GlobalKey<FormState>();
  List<SubcategoryResponseData> subCategories = [];
  List<SubcategoryVertical> verticals = [];
  List<CategoryData> businessCategories = [];
  final picker = ImagePicker();
  String token;
  ProductDetailData product;
  bool editMode;
  int id;
  UserDetailResponseData profileData;
  int status = 1;

  @override
  void didChangeDependencies() {
    //_fetchInitialSubCategories();
    _fetchInitialCategories();
    var arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      id = (arguments as Map)["id"];
      editLoading = true;
      // Future.delayed(Duration(seconds: 2), () {
      //   requestProductDetailApi(id);
      // });
      requestProductDetailApi(id);
    }

    super.didChangeDependencies();
  }

  Future<void> requestUserProfileApi(String token) async {
    try {
      var response = await dio.get('userProfile',
          options: Options(headers: {"Authorization": "Bearer $token"}));
      // profileData = UserDetailResponseData();
      // userDetailResponseDataFromJson(profileData, response.data["data"]);
      //if (mounted)
      //setState(() {
      //selectedCategory = response.data["data"]["business_category"];
      //print(selectedCategory);
      //});
      await _fetchInitialCategories();
      //_fetchInitialSubCategories();
    } on DioError catch (e) {
      print("$e");
    }
  }

  Future<void> _fetchInitialCategories() async {
    await dio.get('categories').then((response) {
      if (response.statusCode == 200) {
        CategoryEntity entity = CategoryEntity();
        categoryEntityFromJson(entity, response.data);
        if (mounted)
          setState(() {
            businessCategories = entity.data;
          });
      } else {}
    }).catchError((e) {});
  }

  void _fetchInitialSubCategories() async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString("token");

    await requestUserProfileApi(token);

    dio
        .get(
      'subCategories',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    )
        .then((response) {
      updateLoading(false);
      if (response.statusCode == 200) {
        if (mounted)
          setState(() {
            SubcategoryResponseEntity entity = SubcategoryResponseEntity();
            subcategoryResponseEntityFromJson(entity, response.data);
            subCategories.addAll(entity.data);
          });
      } else {}
    }).catchError((e) {
      updateLoading(false);
    });
  }

  void fetchSubCategories() async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString("token");
    setState(() => subCategories = []);

    dio
        .get(
      'getsubCategories/${businessCategories.firstWhere((element) => element.name == selectedCategory).id}',
      options: Options(headers: {"Authorization": "Bearer $token"}),
    )
        .then((response) {
      updateLoading(false);
      if (response.statusCode == 200) {
        if (mounted)
          setState(() {
            SubcategoryResponseEntity entity = SubcategoryResponseEntity();
            subcategoryResponseEntityFromJson(entity, response.data);
            subCategories.addAll(entity.data);
          });

        loadVerticals();
      } else {}
    }).catchError((e) {
      updateLoading(false);
    });
  }

  // void fetchVerticals({bool isInitialLoad}) async {
  //   var pref = await SharedPreferences.getInstance();
  //   token = pref.getString("token");
  //   setState(() => verticals = []);

  //   dio
  //       .get(
  //     'getVerticals/$selectedSubCategory',
  //     options: Options(headers: {"Authorization": "Bearer $token"}),
  //   )
  //       .then(
  //     (response) {
  //       updateLoading(false);
  //       if (response.statusCode == 200) {
  //         if (mounted) {
  //           setState(() {
  //             print("${verticals.length} is the length of vertical1");

  //             verticals =
  //                 VerticalListModel.fromJson(json.decode(response.data)).data;
  //             print("Hi test123");

  //             print("${verticals.length} is the length of vertical2");

  //             if (isInitialLoad) {
  //               selectedVertical = verticals
  //                   .firstWhere((element) => element.id == product.verticalId)
  //                   .id;
  //             }
  //           });
  //         }
  //       } else {}
  //     },
  //   ).catchError((e) {
  //     updateLoading(false);
  //   });
  // }

  void updateLoading(bool value) {
    if (!mounted) return;
    setState(() {
      loading = value;
    });
  }

  void requestAddProductApi() async {
    if (productImage == null) {
      showAlert(context, "Add Product Image");
      return;
    }
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return;
    }

    var data = FormData.fromMap({
      "name": productName.text,
      "description": productDescription.text ?? "",
      "moq": productMoq.text,
      "price": productPrice.text,
      //TODO: Inser field & value for product category here
      "category_id": businessCategories
          .firstWhere((element) => element.name == selectedCategory)
          .id,
      "sub_category_id": selectedSubCategory,
      "vertical_id": selectedVertical,
      "image": await MultipartFile.fromFile(productImage.path),
      "status": status,
    });

    updateLoading(true);
    try {
      var response = await dio.post(
        'addProduct',
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      updateLoading(false);
      Navigator.pop(context, {});
    } on DioError catch (e) {
      updateLoading(false);
      showAlert(context, e.response.data["message"]);
    }
  }

  void requestEditProductApi() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return;
    }

    var data = FormData.fromMap({
      "id": product.id,
      "name": productName.text,
      "description": productDescription.text,
      "moq": productMoq.text,
      "price": productPrice.text,
      //"category": selectedCategory,
      "category_id": businessCategories
          .firstWhere((element) => element.name == selectedCategory)
          .id,
      "sub_category_id": selectedSubCategory,
      "vertical_id": selectedVertical,
      "status": status,
      if (productImage != null)
        "image": await MultipartFile.fromFile(productImage.path),
    });

    updateLoading(true);
    try {
      var response = await dio.post(
        'editProduct',
        data: data,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      updateLoading(false);
      Navigator.pop(context);
    } on DioError catch (e) {
      updateLoading(false);
      showAlert(context, e.response.data["message"]);
    }
  }

  void setSelectedVertical(int id) {
    if (!mounted) return;
    setState(() {
      selectedVertical = id;
    });
  }

  void loadVerticals() {
    if (mounted && selectedSubCategory != null) {
      setState(() {
        verticals = subCategories[subCategories
                .indexWhere((element) => element.id == selectedSubCategory)]
            .verticals;
      });
    }
  }

  void launchCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (mounted)
        setState(() {
          productImage = File(croppedFile.path);
        });
    }
  }

  void requestProductDetailApi(id) async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString("token");
    dio
        .get(
          'product/$id',
          options: Options(headers: {"Authorization": "Bearer $token"}),
        )
        .catchError((e) {})
        .then((response) {
      ProductDetailEntity entity = ProductDetailEntity();
      productDetailEntityFromJson(entity, response.data);
      setState(() {
        product = entity.data;
        selectedCategory = product.category["name"];
        editLoading = false;
        selectedSubCategory = product.subCategoryId;
        selectedVertical = product.verticalId;
        if (response.data["data"]["status"] != null)
          status = response.data["data"]["status"];
      });

      fetchSubCategories();
      populateUI();
    }).catchError((e) {});
  }

  void populateUI() {
    productName.text = product.name;
    productDescription.text = product.description;
    productMoq.text = product.moq.toString();
    productPrice.text = product.price;
  }

  void updateStatus(bool value) {
    if (mounted) {
      setState(() {
        status = value ? 1 : 0;
      });
    }
  }

  void nullSubCategories() {
    if (mounted) {
      setState(() => selectedSubCategory = null);
    }
  }

  void nullVerticals() {
    if (mounted) {
      setState(() => selectedVertical = null);
    }
  }

  void selectCategory(String category) {
    if (mounted) {
      setState(() => selectedCategory = category);
    }
  }

  void selectSubCategory(int subCategory) {
    if (mounted) {
      setState(() => selectedSubCategory = subCategory);
    }
  }
}
