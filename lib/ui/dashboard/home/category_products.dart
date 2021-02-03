import 'dart:convert';

import 'package:badhat_b2b/data/category_entity.dart';
import 'package:badhat_b2b/data/state_district_model_entity.dart';
import 'package:badhat_b2b/data/subcategory_entity.dart';
import 'package:badhat_b2b/data/vertical_entity.dart';
import 'package:badhat_b2b/generated/json/category_entity_helper.dart';
import 'package:badhat_b2b/generated/json/state_district_model_entity_helper.dart';
import 'package:badhat_b2b/generated/json/subcategory_entity_helper.dart';
import 'package:badhat_b2b/generated/json/vertical_entity_helper.dart';
import 'package:badhat_b2b/models/category_product_list_model.dart';
import 'package:badhat_b2b/utils/contants.dart';
import 'package:badhat_b2b/utils/link_router.dart';
import 'package:badhat_b2b/widgets/app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:badhat_b2b/utils/extensions.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import 'category_product_view.dart';

class CategoryProductsSreen extends StatefulWidget {
  @override
  _CategoryProductsSreenState createState() => _CategoryProductsSreenState();
}

class _CategoryProductsSreenState extends State<CategoryProductsSreen> {
  bool loadingProducts = true;
  List<CategoryProductModel> products = <CategoryProductModel>[];
  var id;

  List<StateDistrictModelState> states = [];
  List<String> districts = [];
  List<CategoryData> categories = [];
  List<SubcategoryData> subcategories = [];
  List<VerticalData> verticals = [];
  String selectedState, selectedDistrict, selectedBusinessType;
  int selectedCategoryId = -1;
  bool showFilter = true;
  int selectedCategory;
  int selectedSubcategory;
  int selectedVertical;
  bool loading = false;

  @override
  void didChangeDependencies() {
    var arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null) {
      if (mounted)
        setState(() {
          id = (arguments as Map)["id"];
        });
      loadProducts(id);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _fetchCategories();

    StateDistrictModelEntity entity = StateDistrictModelEntity();
    stateDistrictModelEntityFromJson(entity, jsonDecode(stateDistrict));
    states.addAll(entity.states);
    super.initState();
  }

  loadProducts(var id) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");

    try {
      var response = await dio.get(
        'categoryProduct/$id', //TODO://
        queryParameters: {
          "business_category": selectedCategory,
          "business_type": selectedBusinessType,
          "state": selectedState,
          "district": selectedDistrict
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      CategoryProductListModel product =
          CategoryProductListModel.fromJson(response.data);
      setState(() {
        products = product.data;
        loadingProducts = false;
      });
    } on DioError catch (e) {
      print("$e");
    }
  }

  Widget bottomSheet(context) {
    return showFilter
        ? AnimatedContainer(
            duration: Duration(seconds: 2),
            child: Card(
              elevation: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Apply Filter")
                      .fontSize(20)
                      .fontWeight(FontWeight.bold)
                      .paddingAll(8),
                  Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField(
                                validator: (value) {
                                  if (value == null) return "Select State";
                                  return null;
                                },
                                isExpanded: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "State"),
                                onChanged: (stateName) {
                                  if (mounted)
                                    setState(() {
                                      selectedState = stateName;
                                      loadDistrict(stateName);
                                    });
                                },
                                value: selectedState,
                                items: states
                                    .map((e) => DropdownMenuItem(
                                          value: e.state,
                                          child: Text(
                                            e.state.trim(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList())
                            .paddingAll(4),
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          validator: (district) {
                            if (district == null) return "Select District";
                            return null;
                          },
                          isExpanded: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "District"),
                          onChanged: (district) {
                            selectedDistrict = district;
                          },
                          value: selectedDistrict,
                          items: districts
                              .map((e) => DropdownMenuItem(
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                        ).paddingAll(4),
                      ),
                    ],
                  ),
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Business Type"),
                          onChanged: (x) {
                            selectedBusinessType = x;
                          },
                          value: selectedBusinessType,
                          items: userType
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList())
                      .paddingAll(4),
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Category"),
                          onChanged: (x) {
                            selectedCategory = x;
                            if (mounted)
                              setState(() {
                                fetchsubCategory(selectedCategory);
                              });
                          },
                          value: selectedCategory,
                          items: categories
                              .map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.name)))
                              .toList())
                      .paddingAll(4),
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "SubCategories"),
                          onChanged: (x) {
                            selectedSubcategory = x;
                            if (mounted)
                              setState(() {
                                fetchVertical(selectedSubcategory);
                              });
                          },
                          value: selectedSubcategory,
                          items: subcategories
                              .map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.name)))
                              .toList())
                      .paddingAll(4),
                  DropdownButtonFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Verticals"),
                          onChanged: (x) {
                            selectedVertical = x;
                          },
                          value: selectedVertical,
                          items: verticals
                              .map((e) => DropdownMenuItem(
                                  value: e.id, child: Text(e.name)))
                              .toList())
                      .paddingAll(4),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blue.withOpacity(0.5),
                          child: Text("Reset"),
                          onPressed: () {
                            selectedState = null;
                            selectedDistrict = null;
                            selectedBusinessType = null;
                            selectedCategory = null;
                            loadProducts(id);
                            Navigator.pop(context);
                          },
                        ).container(height: 40).paddingAll(4),
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.green.withOpacity(0.5),
                          child: Text("Apply"),
                          onPressed: () {
                            loadProducts(id);
                            Navigator.pop(context);
                          },
                        ).container(height: 40).paddingAll(4),
                      ),
                    ],
                  ).paddingAll(16)
                ],
              ),
            ),
          )
        : Container();
  }

  void _fetchCategories() {
    dio
        .get(
          'categories',
        )
        .catchError((e) {})
        .then((response) {
      if (response.statusCode == 200) {
        CategoryEntity entity = CategoryEntity();
        categoryEntityFromJson(entity, response.data);
        categories = entity.data;
      } else {}
    }).catchError((e) {});
  }

  void fetchsubCategory(int selectedCategory) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    dio
        .get('getsubCategories/$selectedCategory',
            options: Options(headers: {"Authorization": "Bearer $token"}))
        .catchError((e) {})
        .then((response) {
      if (response.statusCode == 200) {
        SubcategoryEntity entity = SubcategoryEntity();
        subcategoryEntityFromJson(entity, response.data);
        if (mounted) {
          setState(() {
            subcategories = entity.data;
            selectedSubcategory = null;
            selectedVertical = null;
          });

          Navigator.pop(context);
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return bottomSheet(context);
            },
          );
        }
      } else {}
    }).catchError((e) {});
  }

  void fetchVertical(int selectedVertical) async {
    var pref = await SharedPreferences.getInstance();
    var token = pref.getString("token");
    dio
        .get('getVerticals/$selectedVertical',
            options: Options(headers: {"Authorization": "Bearer $token"}))
        .catchError((e) {})
        .then((response) {
      if (response.statusCode == 200) {
        VerticalEntity entity = VerticalEntity();
        verticalEntityFromJson(entity, response.data);

        print(entity.data);
        if (mounted) {
          setState(() {
            verticals = entity.data;
          });

          Navigator.pop(context);
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return bottomSheet(context);
            },
          );
        }
      } else {}
    }).catchError((e) {});
  }

  void loadDistrict(stateName) {
    if (mounted)
      setState(() {
        updateSelectedState(stateName);
        int stateIndex =
            states.indexWhere((element) => element.state == stateName);
        districts.clear();
        districts.addAll(states[stateIndex].districts);
        updateSelectedDistrict(districts[0]);
        /*selectedDistrict = districts[0];*/
        print("${jsonEncode(districts)} : districts test list");

        Navigator.pop(context);

        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return bottomSheet(context);
          },
        );
        //bottomSheet(context);
      });
  }

  void _updateLoading(bool value) {
    if (mounted)
      setState(() {
        loading = value;
      });
  }

  void updateSelectedState(String state) {
    selectedState = state;
  }

  void updateSelectedDistrict(String district) {
    selectedDistrict = district;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              "Badhat",
              showSearchBar: true,
            ).paddingFromLTRB(10, 10, 10, 4),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${products.length > 0 ? products.first.category.name : ""}",
                    ),
                    BannerSwiper(
                      //TODO: complete banner
                      width: 250,
                      height: MediaQuery.of(context).size.width.toInt(),
                      length: 1,
                      getwidget: (i) {
                        //BannerModel thisBanner = banners[i % banners.length];
                        return GestureDetector(
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://via.placeholder.com/728x300.png?text=PlaceHolder%20BAnner", //thisBanner.bannerImage,
                            fit: BoxFit.fill,
                            placeholder: (context, url) {
                              return Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          ),
                          onTap: () {
                            gotoLinkPage(
                              link: "thisBanner.bannerUrl",
                              context: context,
                              onBack: () {
                                print("reached back");
                              },
                            );
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          label: Text("Sort"),
                          icon: Icon(Icons.sort),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return bottomSheet(context);
                              },
                            );
                          },
                          icon: Icon(Icons.filter_list),
                          label: Text("Filter"),
                        ),
                        Padding(padding: const EdgeInsets.all(5)),
                      ],
                    ),
                    Container(
                      child: loadingProducts
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, position) {
                                CategoryProductModel thisProduct =
                                    products[position];
                                return CategoryProductView(thisProduct, false);
                              },
                              itemCount: products.length,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
