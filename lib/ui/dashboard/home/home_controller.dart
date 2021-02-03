import 'dart:convert';

import 'package:badhat_b2b/models/banner_list_model.dart';
import 'package:badhat_b2b/models/category_list_model.dart';
import 'package:badhat_b2b/ui/dashboard/home/home_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/favorite_response_entity.dart';
import '../../../generated/json/favorite_response_entity_helper.dart';
import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

TextEditingController searchController = TextEditingController();
List<FavoriteResponseData> favorites = <FavoriteResponseData>[];
List<FavoriteResponseDataVendor> recommended = <FavoriteResponseDataVendor>[];

List<CategoryModel> categories = <CategoryModel>[];
List<BannerModel> banners = <BannerModel>[];

List<Color> colors = [
  Color.fromRGBO(115, 25, 37, 1),
  Color.fromRGBO(2, 121, 101, 1),
  Color.fromRGBO(186, 80, 54, 1),
  Color.fromRGBO(0, 93, 121, 1),
  Color.fromRGBO(204, 146, 0, 1),
  Color.fromRGBO(26, 0, 91, 1),
  Color.fromRGBO(0, 89, 23, 1),
  Color.fromRGBO(254, 141, 63, 1),
];
int categoryColorIndex = 0;

bool favoritesLoading = true;
bool recommendationsLoading = true;

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => HomeView(this);

  @override
  void initState() {
    requestFavoritesApi();
    requestRecomendationApi();
    requestCategoryApi();
    requestBannerApi();
    super.initState();
  }

  void requestRecomendationApi() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    print(token);
    /*_updateLoading(true);*/
    try {
      var response = await dio.get('iButton/$userId',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      print(response.data);
      print(" : recomendation response");

      RecommendedResponseEntity rEntity = RecommendedResponseEntity();
      recommendedResponseEntityFromJson(rEntity, response.data);
      _updateRecommendationsLoading(false);
      if (mounted) setState(() => recommended = rEntity.data);
    } on DioError catch (e) {
      print("$e");
      _updateRecommendationsLoading(false);
    }
  }

  void requestFavoritesApi() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    /*_updateLoading(true);*/
    try {
      var response = await dio.get('favorites',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      FavoriteResponseEntity fEntity = FavoriteResponseEntity();
      favoriteResponseEntityFromJson(fEntity, response.data);
      _updateFavoritesLoading(false);
      if (mounted) setState(() => favorites = fEntity.data ?? []);
    } on DioError catch (e) {
      print("$e");
      _updateFavoritesLoading(false);
    }
  }

  void requestCategoryApi() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    try {
      var response = await dio.get('categories',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      CategoryListModel category = CategoryListModel.fromJson(response.data);
      setState(() => categories = category.data ?? []);
    } on DioError catch (e) {
      print("$e");
    }
  }

  void requestBannerApi() async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    try {
      var response = await dio.get('getBanners',
          options: Options(headers: {"Authorization": "Bearer $token"}));

      BannerListModel banner = BannerListModel.fromJson(response.data);
      setState(() => banners = banner.data ?? []);
    } on DioError catch (e) {
      print("$e");
    }
  }

  void _updateRecommendationsLoading(bool value) {
    if (mounted) setState(() => recommendationsLoading = value);
  }

  void _updateFavoritesLoading(bool value) {
    if (mounted) setState(() => favoritesLoading = value);
  }
}
