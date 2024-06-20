import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/models/tag.dart';
import 'package:sg_date/services/dio_client.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class ProductsController extends ChangeNotifier {
  Future<List<Product>?>? apiProducts;
  Future<List<Tag>?>? apiTags;
  int displayDataLength = 0;
  int dataLength = 0;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final tagController = TextEditingController();

  bool isCountResult = false;
  List<List<bool>>? dateShowed = [];
  // 0: remove - 1: add - 2:change
  int changeTagState = -1;
  List<bool>? proShowed = [];
  int selectedSort = 1;
  int selectedSortIndex = 0;
  List<int> sortOptions = [1, 2];
  List<bool> checkedTags = [];
  List<String> sortDisplayOptions = ['Mã sku', 'Tên sản phẩm'];
  int selectedFilter = 100;
  int selectedFilterIndex = 0;
  List<int> filterOptions = [100, 40, 35, 30, 20];
  List<String> filterDisplayOptions = ['100%', '40%', '35%', '30%', '20%'];
  int selectedTagIndex = 0;
  int selectedTag = 0;
  List<int> tagOptions = [0];
  List<String> tagDisplayOptions = ['Tất cả'];

  ProductsController() {
    apiProducts = DioClient().getAnyProductsWithDate('', 100, 0, 1);
    apiTags = DioClient().getAllTags();
    getTagsForFilter();
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

  getTagsForFilter() async {
    await apiTags!.then(
      (value) {
        selectedTag = 0;
        for (var i = 0; i < value!.length; i++) {
          tagDisplayOptions.add(value[i].name);
          tagOptions.add(value[i].id!);
        }
      },
    );
    notifyListeners();
  }

  determineCheckedTag(Product p) async {
    await apiTags!.then(
      (tags) {
        checkedTags = List.filled(tags!.length, false);
        for (var i = 0; i < tags.length; i++) {
          if (tags[i].id == p.tag.id) {
            checkedTags[i] = true;
            break;
          }
        }
      },
    );
    notifyListeners();
  }

  Future searchWithFilter(int optionIndex, String product) async {
    await apiProducts!.then((value) => value!.clear());
    searchController.text = product;
    apiProducts = DioClient().getAnyProductsWithDate(
      product,
      filterOptions[optionIndex],
      0,
      selectedSort,
    );
    displayDataLength = 0;
    dataLength = 0;
    proShowed = [];
    dateShowed = [];
    addDisplayDataLength();
    await apiProducts!.then(
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

  changeSelectedTag(value) {
    selectedTagIndex = tagOptions.indexOf(value);
    selectedTag = tagOptions[selectedTagIndex];
    print(value);
    notifyListeners();
  }

  showCountedResult() {
    isCountResult = true;
    notifyListeners();
  }

  changeCheckedTag(int index) {
    int currentCheckedIndex = checkedTags.indexOf(true);
    checkedTags = List.filled(checkedTags.length, false);
    if (currentCheckedIndex == index) {
      checkedTags[0] = true;
    } else {
      checkedTags[index] = true;
    }
    notifyListeners();
  }

  chooseTagForProduct(Product p, int productIndex, context) async {
    String textInfo = '';
    await apiTags!.then(
      (tags) async {
        if (p.tag.id != tags![checkedTags.indexOf(true)].id) {
          if (p.tag.id == 1 && tags[checkedTags.indexOf(true)].id != 1)
            textInfo = 'Đã thêm thẻ vào sản phẩm';
          else if (p.tag.id != 1 && tags[checkedTags.indexOf(true)].id != 1)
            textInfo = 'Đã chỉnh sửa thẻ của sản phẩm';
          else if (p.tag.id != 1 && tags[checkedTags.indexOf(true)].id == 1)
            textInfo = 'Đã xóa thẻ khỏi sản phẩm';
          await apiProducts!.then(
            (pros) {
              pros![productIndex].tag.id = tags[checkedTags.indexOf(true)].id;
              pros[productIndex].tag.name =
                  tags[checkedTags.indexOf(true)].name;
              DioClient().replaceTagToProduct(
                p.id.toString(),
                tags[checkedTags.indexOf(true)].id.toString(),
              );
              SnackBar snackBar = snackBarWidget(
                context: context,
                text: textInfo,
                icon: 'asset/icons/info_icon.svg',
                color: Color.fromARGB(255, 94, 18, 99),
                textColor: Colors.white,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          );
        }
      },
    );
    notifyListeners();
  }

  createNewTag() async {
    String newTag = tagController.text.trim();
    DioClient().addTagToSheet(newTag);
    apiTags = DioClient().getAllTags();
    await apiTags!.then(
      (tags) {
        checkedTags = List.filled(tags!.length, false);
        for (var i = 0; i < tags.length; i++) {
          if (tags[i].name == newTag) {
            checkedTags[i] = true;
          }
        }
      },
    );
    tagController.clear();
    notifyListeners();
  }

  editTag(int tagId) async {
    String newTag = tagController.text.trim();
    DioClient().replaceTagFromSheet(tagId.toString(), newTag);
    apiTags = DioClient().getAllTags();
    await apiProducts!.then(
      (pros) {
        for (var i = 0; i < pros!.length; i++) {
          if (pros[i].tag.id == tagId) {
            pros[i].tag.name = newTag;
          }
        }
      },
    );
    await apiTags!.then(
      (tags) {
        checkedTags = List.filled(tags!.length, false);
        for (var i = 0; i < tags.length; i++) {
          if (tags[i].id == tagId) {
            checkedTags[i] = true;
            break;
          }
        }
      },
    );
    notifyListeners();
  }
}
