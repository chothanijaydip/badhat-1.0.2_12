import 'package:badhat_b2b/ui/dashboard/search/search_controller.dart';
import 'package:badhat_b2b/utils/contants.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../utils/extensions.dart';

class SearchView extends WidgetView<SearchController, SearchControllerState> {
  SearchView(SearchControllerState state) : super(state);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                ).paddingRight(4).onClick(() {
                  Navigator.pop(context, {});
                }),
                Expanded(
                  child: TextField(
                    controller: state.searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.fromLTRB(8, 6, 8, 18),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ).roundedStroke(Colors.grey.withOpacity(0.5),  40),
                ),
                Column(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 32,
                    ).onClick(() {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return state.bottomSheet(context);
                          });
                      /*showFilterSheet(context);*/
                     /* state.showFilterSheet();*/
                    }),
                    Text("Filter")
                        .fontSize(10)
                        .alignTo(Alignment.center)
                  ],
                ),
                Text("Search")
                    .color(Colors.white)
                    .fontSize(10)
                    .roundedBorder(Theme.of(context).accentColor,
                        height: 40, width: 60)
                    .onClick(() {
                  state.doSearch();
                }).paddingLeft(8)
              ],
            ).paddingFromLTRB(8, 10, 4, 4),
            Divider(
              thickness: 1.5,
            ),
            Expanded(
              child: state.loading
                  ? CircularProgressIndicator().center()
                  : ListView.separated(
                      itemBuilder: (context, position) {
                        var data = state.searchResults[position];
                        return Row(
                          children: <Widget>[
                            (data.image == null || data.image.isEmpty)
                                ? Image.asset(
                              "assets/images/no-image.jpg", width: 60, height: 60,)
                                :
                            ClipRRect(
                              child: CachedNetworkImage(
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
                                      Text(data.businessType)
                                          .fontSize(10)
                                          .color(Colors.white)
                                          .paddingAll(4)
                                          .roundedBorder(
                                              Colors.purple.withOpacity(0.7),
                                              cornerRadius: 4),
                                      Text(data.businessCategory)
                                          .fontSize(10)
                                          .color(Colors.white)
                                          .paddingAll(4)
                                          .roundedBorder(
                                              Colors.pink.withOpacity(0.7),
                                              cornerRadius: 4)
                                          .paddingLeft(4),
                                    ],
                                    mainAxisSize: MainAxisSize.min,
                                  ),
                                  Text(data.businessName)
                                      .fontWeight(FontWeight.bold)
                                      .paddingTop(4),
                                  Row(
                                    children: [
                                      Visibility(
                                        visible:(data.name!=null),
                                        child: Text("${data.name}, ${data.district}")
                                            .paddingTop(4),
                                      ),
                                      Visibility(
                                        visible:(data.name!=null),
                                        child: Text(",")
                                            .paddingTop(4),
                                      ),
                                      Text(" ${data.district}")
                                          .paddingTop(4),
                                    ],
                                  ),
                                ],
                              ).paddingFromLTRB(12, 0, 8, 0),
                            ),
                            Icon(Icons.arrow_right),
                          ],
                        ).onClick(() {
                          Navigator.pushNamed(context, "vendor_profile",
                              arguments: {
                                "user_id": data.id,
                              });
                        }).paddingFromLTRB(16, 4, 16, 4);
                      },
                      separatorBuilder: (context, position) {
                        return Divider(
                          indent: 90,
                          thickness: 1.2,
                        );
                      },
                      itemCount: state.searchResults.length),
            )
          ],
        ),
      ),
    );
  }


  void showFilterSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return state.bottomSheet(context);
        });
  }

  Widget bottomSheet(context) {
    return state.showFilter
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

                        state.selectedState = stateName;
                        state.loadDistrict(stateName);



                      },
                      value: state.selectedState,
                      items:
                      state.states
                          .map((e) => DropdownMenuItem(
                        value:  e.state,
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

                      state.selectedDistrict = district;


                    },
                    value: state.selectedDistrict,
                    items: state.districts
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
                  state.selectedBusinessType = x;
                },
                value: state.selectedBusinessType,
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
                  state.selectedCategory = x;

                    state.fetchsubCategory(state.selectedCategory);


                },
                value: state.selectedCategory,
                items: state.categories
                    .map((e) => DropdownMenuItem(
                    value: e.id, child: Text(e.name)))
                    .toList())
                .paddingAll(4),
            DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "SubCategories"),
                onChanged: (x) {
                  state.selectedSubcategory = x;

                    state.fetchVertical(state.selectedSubcategory);

                },
                value: state.selectedSubcategory,
                items: state.subcategories
                    .map((e) => DropdownMenuItem(
                    value: e.id, child: Text(e.name)))
                    .toList())
                .paddingAll(4),
            DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Verticals"),
                onChanged: (x) {
                  state.selectedVertical = x;
                },
                value: state.selectedVertical,
                items: state.verticals
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
                      state.selectedState = null;
                      state.selectedDistrict = null;
                      state.selectedBusinessType = null;
                      state.selectedCategory = null;
                     state.doSearch();
                      Navigator.pop(context);
                    },
                  ).container(height: 40).paddingAll(4),
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.green.withOpacity(0.5),
                    child: Text("Apply"),
                    onPressed: () {
                      state.doSearch();
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

}


