import 'package:badhat_b2b/ui/dashboard/cart/cart_controller.dart';
import 'package:badhat_b2b/ui/dashboard/cart/cart_item_view.dart';
import 'package:badhat_b2b/widgets/widget_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../data/cart_response_entity.dart';
import '../../../utils/extensions.dart';

class CartView extends WidgetView<CartController, CartControllerState> {
  CartView(CartControllerState state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: state.loading
                  ? CircularProgressIndicator().center()
                  : state.cartList.isEmpty
                      ? Text("Cart is empty").center()
                      : ListView.separated(
                          itemBuilder: (context, pos) {
                            CartResponseData v = state.cartList[pos];
                            CartResponseDataProduct product = v.product;

                            return CartItemView(
                              key: Key(pos.toString()),
                              v: v,
                              callback: () {
                                state.requestCartApi();
                              },
                            );
                          },
                          separatorBuilder: (context, pos) {
                            return Divider(
                              thickness: 1.2,
                            );
                          },
                          itemCount: state.cartList.length),
            ),
            if (state.loading)
              SizedBox()
            else
              state.placingOrder
                  ? CircularProgressIndicator().paddingAll(16)
                  : state.cartList.isEmpty
                      ? Container()
                      : Text("Place Order")
                          .color(Colors.white)
                          .roundedBorder(Theme.of(context).accentColor,
                              height: 40)
                          .onClick(() {
                          state.requestPlaceOrderApi();
                        }).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
