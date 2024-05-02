import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';

class ProductsController extends ChangeNotifier {
  final scrollController = ScrollController();
  Future<List<Product>?>? apiProducts;
  int dataLength = 0;
  final searchController = TextEditingController();
  List<List<bool>>? dateShowed = [];
  List<bool>? proShowed = [];
  List<Product>? proList;

  ProductsController() {
    apiProducts = DioClient().getProductList();
    addDataLength();
    apiProducts!.then(
      (proList) {
        proShowed = List.filled(proList!.length, true);
        for (var i = 0; i < dataLength; i++) {
          var singleList;
          singleList = List.filled(proList[i].dates.length, true);
          dateShowed!.add(singleList);
        }
        print(dateShowed);
      },
    );
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
    dateShowed = [];
    addDataLength();
    apiProducts!.then(
      (proList) {
        proShowed = List.filled(proList!.length, true);
        for (var i = 0; i < dataLength; i++) {
          var singleList;
          singleList = List.filled(proList[i].dates.length, true);
          dateShowed!.add(singleList);
        }
        print(dateShowed);
      },
    );
    notifyListeners();
  }

  Future search(String search) async {
    dataLength = 0;
    dateShowed = [];
    apiProducts = DioClient().getSearches(search);
    addDataLength();
    apiProducts!.then(
      (proList) {
        proShowed = List.filled(proList!.length, true);
        for (var i = 0; i < dataLength; i++) {
          var singleList;
          singleList = List.filled(proList[i].dates.length, true);
          dateShowed!.add(singleList);
        }
        print(dateShowed);
      },
    );
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

  int dayLefts(String twenty_pct) {
    DateTime twenty = DateTime(
      int.parse(twenty_pct.substring(6, 10)),
      int.parse(twenty_pct.substring(3, 5)),
      int.parse(twenty_pct.substring(0, 2)),
    );
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return twenty.difference(now).inDays;
  }

  changeDateList(int id, int dateIndex, int productIndex) async {
    dateShowed![productIndex][dateIndex] = false;
    proShowed![productIndex] =
        dateShowed![productIndex].every((element) => false);
    notifyListeners();
    await DioClient().removeDate(id.toString());
  }
}
