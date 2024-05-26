import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';

class ProductsController extends ChangeNotifier {
  Future<List<Product>?>? apiProducts;
  int displayDataLength = 0;
  int dataLength = 0;

  final searchController = TextEditingController();
  final scrollController = ScrollController();

  bool isCountResult = false;
  List<List<bool>>? dateShowed = [];
  List<bool>? proShowed = [];
  int selectedSort = 1;
  int selectedSortIndex = 0;
  List<int> sortOptions = [1, 2];
  List<String> sortDisplayOptions = ['Mã sku', 'Tên sản phẩm'];
  int selectedFilter = 100;
  int selectedFilterIndex = 0;
  List<int> filterOptions = [100, 40, 35, 30, 20];
  List<String> filterDisplayOptions = ['100%', '40%', '35%', '30%', '20%'];

  ProductsController() {
    apiProducts = DioClient().searchForDatedProductsWithFilter('', 100, 1);
    addDisplayDataLength();
    apiProducts!.then(
      (proList) {
        dataLength = proList!.length;
        proShowed = List.filled(proList.length, true);
        for (var i = 0; i < proList.length; i++) {
          var singleList;
          singleList = List.filled(proList[i].dates.length, true);
          dateShowed!.add(singleList);
        }
      },
    );
    scrollController.addListener(scrollListener);
  }

  Future searchWithFilter(int optionIndex, String product) async {
    apiProducts!.then((value) => value!.clear());
    searchController.text = product;
    apiProducts = DioClient().searchForDatedProductsWithFilter(
      product,
      filterOptions[optionIndex],
      selectedSort,
    );
    displayDataLength = 0;
    dataLength = 0;
    proShowed = [];
    dateShowed = [];
    addDisplayDataLength();
    apiProducts!.then(
      (proList) {
        dataLength = proList!.length;
        proShowed = List.filled(proList.length, true);
        for (var i = 0; i < proList.length; i++) {
          var singleList;
          singleList = List.filled(proList[i].dates.length, true);
          dateShowed!.add(singleList);
        }
        notifyListeners();
      },
    );
    notifyListeners();
  }

  scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      addDisplayDataLength();
      print('scroll to end');
      notifyListeners();
    } else
      print('scroll');
  }

  addDisplayDataLength() {
    displayDataLength += 20;
    apiProducts!.then(
      (value) {
        if (value != null && value.length < displayDataLength) {
          displayDataLength = value.length;
        }
      },
    );
    notifyListeners();
  }

  int calcCurrentPercent(String mfg, exp) {
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

  int calcDayLefts(String twenty_pct) {
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
    int count = 0;
    dateShowed![productIndex][dateIndex] = false;
    for (var i = 0; i < dateShowed![productIndex].length; i++) {
      if (dateShowed![productIndex][i]) {
        count++;
        break;
      }
    }
    if (count == 0) {
      proShowed![productIndex] = false;
    }
    notifyListeners();
    await DioClient().removeDateFromSheet(id.toString());
  }

  changeSelectedSort(displayValue) {
    selectedSortIndex = sortOptions.indexOf(displayValue);
    selectedSort = sortOptions[selectedSortIndex];
    notifyListeners();
  }

  changeSelectedFilter(displayValue) {
    selectedFilterIndex = filterOptions.indexOf(displayValue);
    selectedFilter = filterOptions[selectedFilterIndex];
    notifyListeners();
  }

  showCountedResult() {
    isCountResult = true;
    notifyListeners();
  }
}
