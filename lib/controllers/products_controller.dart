import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';

class ProductsController extends ChangeNotifier {
  final scrollController = ScrollController();
  Future<List<Product>?>? apiProducts;
  int dataLength = 0;
  final searchController = TextEditingController();

  ProductsController() {
    apiProducts = DioClient().getProductList();
    addDataLength();
    scrollController.addListener(scrollListener);
  }

  scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      addDataLength();
      print('scrolled to end + ${dataLength}');
      notifyListeners();
    } else
      print('scroll');
  }

  addDataLength() {
    dataLength += 20;
    apiProducts!.then((value) {
      if (value != null && value.length < dataLength) {
        dataLength = value.length;
      }
    });
    notifyListeners();
  }

  Future refresh() async {
    apiProducts = DioClient().getProductList();
    dataLength = 0;
    addDataLength();
    notifyListeners();
  }

  Future search(String search) async {
    dataLength = 0;
    apiProducts = DioClient().getSearches(search);
    addDataLength();
    notifyListeners();
  }

  int count(String mfg, exp) {
    DateTime start = DateTime(
      int.parse(mfg.substring(6, 10)),
      int.parse(mfg.substring(3, 5)),
      int.parse(mfg.substring(0, 2)),
    );
    DateTime end = DateTime(
      int.parse(exp.substring(6, 10)),
      int.parse(exp.substring(3, 5)),
      int.parse(exp.substring(0, 2)),
    );
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    int fullRangeTime = end.difference(start).inDays;
    int leftRangeTime = end.difference(now).inDays;
    return (leftRangeTime / fullRangeTime * 100).round().toInt();
  }
}
