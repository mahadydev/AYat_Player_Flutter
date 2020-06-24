import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IAP {
  ///List of items from managed store
  List<IAPItem> _items = [];
  List<IAPItem> get items => _items;

  ///Stream subscription for changes listening
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  ///List of item purchased as non consumable
  List<PurchasedItem> _purchases = [];
  List<PurchasedItem> get purchases => _purchases;
  String connectionResult;

  initIAPs() async {
    connectionResult = await FlutterInappPurchase.instance.initConnection;
    print("Established IAP Connection..." + connectionResult);

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
      (productItem) {
        print('purchase-updated: $productItem');
        FlutterInappPurchase.instance
            .acknowledgePurchaseAndroid(productItem.purchaseToken);
        Fluttertoast.showToast(
            msg: 'Thank You ! You are the best <3',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      },
    );

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(
      (purchaseError) {
        print('purchase-error: $purchaseError');
        Fluttertoast.showToast(
            msg: purchaseError.message ?? 'Error',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.red,
            fontSize: 16.0);
      },
    );
  }

  ///get the list of products from google console managed product
  getProducts() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(['donate_80']);
    for (var item in items) {
      print('${item.toString()}');
      this._items.add(item);
    }
  }

  ///request of a purchase
  requestPurchase(IAPItem item) async {
    await FlutterInappPurchase.instance.requestPurchase(item.productId);
  }

  ///Consume all item for re-purchase
  consumeAllItems() async {
    try {
      String msg = await FlutterInappPurchase.instance.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }
  }

  ///End all billing connection
  Future<void> endBillingConnection() async {
    print('ending billing connection');
    await FlutterInappPurchase.instance.endConnection;
    if (_conectionSubscription != null) {
      _conectionSubscription.cancel();
      _conectionSubscription = null;
    }
    if (_purchaseUpdatedSubscription != null) {
      _purchaseUpdatedSubscription.cancel();
      _purchaseUpdatedSubscription = null;
    }
    if (_purchaseErrorSubscription != null) {
      _purchaseErrorSubscription.cancel();
      _purchaseErrorSubscription = null;
    }
    print('ended billing connection');
  }
}
