import 'dart:convert';
import 'dart:io';

import 'package:badhat_b2b/data/user_detail_response_entity.dart';
import 'package:badhat_b2b/generated/json/category_entity_helper.dart';
import 'package:badhat_b2b/generated/json/user_detail_response_entity_helper.dart';
import 'package:badhat_b2b/ui/dashboard/more/profile/my_profile_view.dart';
import 'package:badhat_b2b/utils/contants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/category_entity.dart';
import '../../../../data/state_district_model_entity.dart';
import '../../../../generated/json/state_district_model_entity_helper.dart';
import '../../../../main.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) => MyProfileView(this);

  bool isEditing = false;

  // variables
  List<StateDistrictModelState> states = [];
  List<String> districts = [];
  List<CategoryData> businessCategories = [];
  var businessNameController = TextEditingController();
  var ownerNameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  var pincodeController = TextEditingController();
  var gstinController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();

  String selectedState,
      selectedDistrict,
      selectedBusinessType,
      selectedBusinessCategory;

  var userType = [
    "Retailer",
    "Distributor",
    "Stockist",
    "Manufacturer",
    "Agent",
    "Brand",
    "Supplier",
    "Online Seller",
    "Reseller",
  ];
  UserDetailResponseData profileData;
  bool loading = true;
  bool saving = false;
  String token;
  final formKey = new GlobalKey<FormState>();

  File avatar;
  final picker = ImagePicker();

  @override
  void initState() {
    StateDistrictModelEntity entity = StateDistrictModelEntity();
    stateDistrictModelEntityFromJson(entity, jsonDecode(stateDistrict));
    states.addAll(entity.states);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (profileData == null) {
      var pref = await SharedPreferences.getInstance();
      token = pref.getString("token");
      requestUserProfileApi();
    }

    super.didChangeDependencies();
  }

  Future<void> _fetchCategories() async {
    await dio
        .get(
          'categories',
        )
        .catchError((e) {})
        .then((response) {
      if (response.statusCode == 200) {
        CategoryEntity entity = CategoryEntity();
        categoryEntityFromJson(entity, response.data);
        setState(() {
          businessCategories = entity.data;
        });
      } else {}
    }).catchError((e) {});
  }

  void launchImagePicker() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
        //CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    if (mounted)
      setState(() {
        avatar = File(croppedFile.path);
      });
  }

  void requestUserProfileApi() async {
    _updateLoading(true);
    try {
      var response = await dio.get('userProfile',
          options: Options(headers: {"Authorization": "Bearer $token"}));
      profileData = UserDetailResponseData();
      userDetailResponseDataFromJson(profileData, response.data["data"]);
      await _fetchCategories();
      populateData();
    } on DioError catch (e) {
      _updateLoading(false);
    }
  }

  void _updateLoading(bool value) {
    if (!mounted) return;
    setState(() {
      loading = value;
    });
  }

  void loadDistrict(String stateName) {
    setState(() {
      updateSelectedState(stateName);
      int stateIndex =
          states.indexWhere((element) => element.state == stateName);
      districts.clear();
      districts.addAll(states[stateIndex].districts);
      updateSelectedDistrict(districts[0]);
    });
  }

  void loadBusinessTypeAndCategory() {
    setState(() {
      selectedBusinessType = profileData.businessType;
      selectedBusinessCategory = profileData.businessCategory;
    });
  }

  void updateSelectedBusinessType(String value) {
    setState(() {
      selectedBusinessType = value;
    });
  }

  void updateSelectedBusinessCategory(String value) {
    setState(() {
      selectedBusinessCategory = value;
    });
  }

  void updateSelectedState(String state) {
    selectedState = state;
  }

  void updateSelectedDistrict(String district) {
//    print("distr:" + district);
    selectedDistrict = district;
  }

  void populateData() {
    print(jsonEncode(profileData));
    businessNameController.text = profileData.businessName;
    ownerNameController.text = profileData.name;
    mobileController.text = profileData.mobile;
    pincodeController.text = profileData.pincode;
    emailController.text = profileData.email;
    gstinController.text = profileData.gstin;
    addressController.text = profileData.address;
    cityController.text = profileData.city;
    selectedState = profileData.state;
    loadDistrict(selectedState);
    selectedDistrict = profileData.district;
    loadBusinessTypeAndCategory();
    avatar = null;

    _updateLoading(false);
  }

  void updateEditState(bool val) {
    setState(() => isEditing = val);
  }

  void updateProfile() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
    } else {
      return;
    }

    if (!mounted) return;
    setState(() {
      saving = true;
    });

    FormData data = FormData.fromMap({
      "id": profileData.id,
      "name": ownerNameController.text,
      "business_name": businessNameController.text,
      "mobile": mobileController.text,
      "email": emailController.text,
      "state": selectedState,
      "district": selectedDistrict,
      "gstin": gstinController.text.toUpperCase(),
      "pincode": pincodeController.text,
      "address": addressController.text,
      "city": cityController.text,
      "business_type": selectedBusinessType,
      "business_category": selectedBusinessCategory,
      "image":
          (avatar == null) ? null : await MultipartFile.fromFile(avatar.path),
    });

    try {
      var response = await dio.post('updateProfile',
          data: data,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      Navigator.pop(context);
    } on DioError catch (e) {
      if (!mounted) return;
      setState(() {
        saving = false;
      });
      showAlert(context, e.response.data["message"]);
    }
  }
}
