import 'dart:math';
import 'dart:ui';

import 'package:badhat_b2b/data/favorite_response_entity.dart';
import 'package:badhat_b2b/models/banner_list_model.dart';
import 'package:badhat_b2b/ui/dashboard/home/home_controller.dart';
import 'package:badhat_b2b/utils/link_router.dart';
import 'package:badhat_b2b/widgets/app_bar.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';

import '../../../data/chat_room_response_entity.dart';
import '../../../utils/extensions.dart';

class HomeView extends WidgetView<HomeScreen, HomeScreenState> {
  HomeView(HomeScreenState state) : super(state);

  Widget _buildFavoriteStoresListView() {
    return Container(
      child: favoritesLoading
          ? CircularProgressIndicator().center()
          : RefreshIndicator(
              onRefresh: () async {
                state.requestFavoritesApi();
                state.requestRecomendationApi();
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    favorites.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 25),
                            child: Text(
                              "Like a store to see here.",
                              style: TextStyle(fontSize: 25),
                            ),
                          )
                        : Container(
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: favorites.length,
                                padding: const EdgeInsets.all(0),
                                separatorBuilder: (context, position) {
                                  return Divider(
                                    indent: 90,
                                    thickness: 1,
                                  );
                                },
                                itemBuilder: (context, position) {
                                  var data = favorites[position].vendor;
                                  // print(
                                  //     "${favorites[position].vendorRetailer[""]} vendor retailer");
                                  if (data == null) {
                                    FavoriteResponseDataVendor vendorRetailer =
                                        new FavoriteResponseDataVendor();
                                    vendorRetailer.businessCategory =
                                        favorites[position]
                                            .vendorRetailer["category"];
                                    vendorRetailer.businessType =
                                        favorites[position]
                                            .vendorRetailer["business_type"];
                                    vendorRetailer.businessName =
                                        favorites[position]
                                            .vendorRetailer["org_name"];
                                    vendorRetailer.id = favorites[position]
                                        .vendorRetailer["id"];
                                    vendorRetailer.mobile = favorites[position]
                                        .vendorRetailer["org_phone"]
                                        .toString();
                                    vendorRetailer.district =
                                        favorites[position]
                                            .vendorRetailer["district"];
                                    vendorRetailer.state = favorites[position]
                                        .vendorRetailer["state"];
                                    vendorRetailer.pincode = favorites[position]
                                        .vendorRetailer["pin_code"];
                                    vendorRetailer.status = favorites[position]
                                        .vendorRetailer["status"];

                                    data = vendorRetailer;
                                  }
                                  return Visibility(
                                    visible: data != null,
                                    child: StoresTile(data),
                                  );
                                }),
                          ),

                    //TODO: categories
                    if (categories.length > 0)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, bottom: 8, top: 30),
                        child: Text(
                          "Categories",
                          style: Theme.of(state.context).textTheme.headline6,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    if (categories.length > 0)
                      Container(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(8),
                          crossAxisSpacing: 13,
                          mainAxisSpacing: 13,
                          children: categories.map((e) {
                            categoryColorIndex++;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: e.bgImage == null
                                        ? colors[categoryColorIndex > 8
                                            ? Random().nextInt(8)
                                            : categoryColorIndex]
                                        : Colors.black,
                                  ),
                                  child: e.bgImage == null
                                      ? null
                                      : Opacity(
                                          opacity: 0.7,
                                          child: CachedNetworkImage(
                                            imageUrl: e.bgImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (e.icon != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: e.icon,
                                            width: 40,
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          "${e.name}",
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(state.context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        state.context, "category_products",
                                        arguments: {
                                          "id": e.id,
                                        });
                                  },
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    if (banners.length > 0)
                      BannerSwiper(
                        width: 250,
                        height: MediaQuery.of(state.context).size.width.toInt(),
                        length: banners.length,
                        getwidget: (i) {
                          BannerModel thisBanner = banners[i % banners.length];
                          return GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: thisBanner.bannerImage,
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return Container(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                            ),
                            onTap: () {
                              gotoLinkPage(
                                link: thisBanner.bannerUrl,
                                context: state.context,
                                onBack: () {
                                  print("reached back");
                                },
                              );
                            },
                          );
                        },
                      ),
                    Padding(padding: const EdgeInsets.all(5)),
                    //TODO: type2banners

                    if (!recommendationsLoading && recommended.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 17),
                        child: Text(
                          "Nearby Stores",
                          style: Theme.of(state.context).textTheme.headline5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    if (!recommendationsLoading && recommended.length > 0)
                      Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recommended.length,
                          padding: const EdgeInsets.all(0),
                          separatorBuilder: (context, position) {
                            return Divider(
                              indent: 90,
                              thickness: 1,
                            );
                          },
                          itemBuilder: (context, position) {
                            FavoriteResponseDataVendor data =
                                recommended[position];
                            return data != null
                                ? StoresTile(data)
                                : Container();
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRecommendedStoresListView() {
    return Container(
      child: recommendationsLoading
          ? CircularProgressIndicator().center()
          : recommended.length == 0
              ? Text("View all your Store Recommendations here").center()
              : RefreshIndicator(
                  onRefresh: () async {
                    state.requestRecomendationApi();
                  },
                  child: ListView.separated(
                    itemCount: recommended.length,
                    padding: const EdgeInsets.all(0),
                    separatorBuilder: (context, position) {
                      return Divider(
                        indent: 90,
                        thickness: 1,
                      );
                    },
                    itemBuilder: (context, position) {
                      FavoriteResponseDataVendor data = recommended[position];
                      return data != null ? StoresTile(data) : Container();
                    },
                  ),
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyAppBar(
                "Badhat",
                showSearchBar: true,
              ).paddingFromLTRB(10, 10, 10, 4),
              Container(
                child: TabBar(
                  unselectedLabelColor: Colors.green,
                  labelColor: Colors.amber[600],
                  indicatorColor: Colors.amber[600],
                  tabs: [
                    Tab(
                      //icon: new Icon(Icons.favorite),
                      child: Text("Liked Stores")
                          .fontWeight(FontWeight.bold)
                          .fontSize(17),
                    ),
                    Tab(
                      //icon: new Icon(Icons.recommend),
                      child: Text("Nearby Stores")
                          .fontWeight(FontWeight.bold)
                          .fontSize(17),
                    ),
                  ],
                ),
              ),
              // ListView Showing Liked Stores Or Recommended Stores
              Expanded(
                child: TabBarView(
                  children: [
                    _buildFavoriteStoresListView(),
                    _buildRecommendedStoresListView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoresTile extends StatelessWidget {
  final FavoriteResponseDataVendor data;

  StoresTile(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ClipRRect(
          child: (data == null || (data.image == null || data.image.isEmpty))
              ? Container(
                  child: Center(
                      child: Text(
                    "${data.businessName[0]}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  color: Colors.white,
                  width: 60,
                  height: 60,
                )
              : CachedNetworkImage(
                  imageUrl: data.image ?? "",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.circular(8),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(data == null ? "" : data.businessType)
                      .fontSize(10)
                      .color(Colors.white)
                      .paddingAll(4)
                      .roundedBorder(Colors.purple.withOpacity(0.7),
                          cornerRadius: 4),
                  Text(data == null ? "" : data.businessCategory)
                      .fontSize(10)
                      .color(Colors.white)
                      .paddingAll(4)
                      .roundedBorder(Colors.pink.withOpacity(0.7),
                          cornerRadius: 4)
                      .paddingLeft(4),
                ],
                mainAxisSize: MainAxisSize.min,
              ),
              Text(data == null ? "" : data.businessName)
                  .fontWeight(FontWeight.bold)
                  .paddingTop(4),
              Visibility(
                visible: (data != null),
                child: Text(
                        "${data == null || data.name == null ? "" : data.name + ','}${data == null ? "" : " " + data.district}")
                    .paddingTop(4),
              ),
            ],
          ).paddingFromLTRB(12, 0, 8, 0),
        ),
        Icon(Icons.chat).onClick(() {
          print(data.toJson());
          ChatRoomResponseDataVendor d = ChatRoomResponseDataVendor(
              id: data == null ? "" : data.id,
              name: data == null ? "" : data.name,
              businessName: data == null ? "" : data.businessName,
              image: data == null ? "" : data.image,
              roomId: data == null ? "" : data.roomId);
          Navigator.pushNamed(context, "chat", arguments: {
            "vendor": (d),
          });
        }),
      ],
    ).onClick(() {
      Navigator.pushNamed(context, "vendor_profile", arguments: {
        "user_id": data == null ? "" : data.id,
      });
    }).paddingFromLTRB(16, 4, 16, 4);
  }
}
