import 'package:badhat_b2b/models/category_product_list_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../utils/extensions.dart';

class CategoryProductView extends StatefulWidget {
  final CategoryProductModel product;
  final bool sameUser;

  const CategoryProductView(this.product, this.sameUser, {key})
      : super(key: key);

  @override
  _CategoryProductViewState createState() => _CategoryProductViewState();
}

class _CategoryProductViewState extends State<CategoryProductView> {
  bool loading = false;
  String token;

  @override
  void didChangeDependencies() async {
    var pref = await SharedPreferences.getInstance();
    token = pref.getString("token");
    super.didChangeDependencies();
  }

  void addProductToCart({bool isOrderNow}) async {
    _updateLoading(true);

    try {
      var response = await dio.post('addToCart',
          data: {
            "product_id": widget.product.id,
            "quantity": widget.product.moq,
            "vendor_id": widget.product.userId,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}));
      _updateLoading(false);
      if (response.statusCode == 200) {
        cartCountController.add(response.data["data"]);
        showAlert(context, "Product added");
        if (isOrderNow == true) {
          Navigator.pushNamed(context, 'cart');
        }
      }
    } on DioError catch (e) {
      _updateLoading(false);
    }
  }

  void _updateLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("product_detail", arguments: {"id": widget.product.id});
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (widget.product.image != null)
                  CachedNetworkImage(
                    imageUrl: widget.product.image,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.withOpacity(0.4),
                      width: 100,
                      height: 100,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(" ${widget.product.name}")
                          .fontSize(15)
                          .fontWeight(FontWeight.w800),
                      Text(" Rs. ${widget.product.price}/set")
                          .fontSize(13)
                          .fontWeight(FontWeight.bold),
                      Padding(padding: const EdgeInsets.all(3)),
                      Text(" MOQ: ${widget.product.moq}"),
                      Padding(padding: const EdgeInsets.all(3)),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 17,
                          ),
                          Text("Within x Km"),
                        ],
                      ),
                    ],
                  ).paddingLeft(16),
                ),
                loading
                    ? CircularProgressIndicator()
                        .container(width: 24, height: 24)
                        .paddingAll(8)
                    : !widget.sameUser
                        ? Column(
                            children: [
                              OutlineButton(
                                child: Text("Add to cart"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () {
                                  addProductToCart();
                                },
                              ),
                              RaisedButton(
                                child: Text("Order now"),
                                color: Color(0xFFFF6F00),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onPressed: () {
                                  addProductToCart(isOrderNow: true);
                                },
                              ),
                            ],
                          )
                        : Container(),
              ],
            ),
          ),
          Divider(
            height: 0,
          )
        ],
      ),
    );
  }
}
