import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/models/tag.dart';
import 'package:sg_date/services/dio_client.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class CalcController extends ChangeNotifier {
  GlobalKey positionedKey = GlobalKey();
  var snackBar;
  final mfg = TextEditingController();
  final exp = TextEditingController();
  final sku = TextEditingController();
  final tagName = TextEditingController();
  final mfgFocus = FocusNode();
  final expFocus = FocusNode();
  final skuFocus = FocusNode();
  Future<List<Product>?>? productApi;
  Future<List<Product>?>? productApiForTag;
  Future<List<Tag>?>? tagApi;
  List<bool> tagList = [];
  Future<bool>? tagExisted;
  var xPosition;
  var yPosition;
  int totalDay = 0;
  int currentPercent = 0;
  int allowedDay = 0;
  int dataLength = 0;
  bool isSaved = false;
  bool isShowResult = false;
  bool isExistedDate = false;
  bool isResultFound = false;
  int focusCounted = 0;
  int firstProductDateLength = 0;
  int? selectedProductId = 0;
  int? selectedTagId = 0;
  String mfgIcon = 'asset/icons/calendar_icon.svg';
  String expIcon = 'asset/icons/calendar_icon.svg';
  List<bool> checkboxes = [];
  late String twentyPercentLeft = '';
  late String thirtyPercentLeft = '';
  late String fourtyPercentLeft = '';
  DateTime mfgDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime expDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String tempMfg = '';
  String tempExp = '';

  CalcController() {
    skuFocus.addListener(() {
      if (skuFocus.hasFocus && focusCounted == 0) {
        sku.selection = TextSelection(
          baseOffset: 0,
          extentOffset: sku.text.length,
        );
      } else if (skuFocus.hasFocus && focusCounted > 1) {
        sku.selection = TextSelection.collapsed(offset: sku.text.length);
      } else {
        focusCounted = 0;
      }
      print(focusCounted);
    });
  }

  countFocus() {
    focusCounted++;
  }

  setSku(String sku) {
    this.sku.text = sku;
  }

  showResult(context) async {
    isSaved = false;
    isExistedDate = false;
    tempExp = exp.text;
    tempMfg = mfg.text;
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (mfg.text.isEmpty || exp.text.isEmpty) {
      snackBar = snackBarWidget(
        context: context,
        text: 'Không được để trống NSX và HSD',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (mfgDate.isAfter(expDate)) {
      snackBar = snackBarWidget(
        context: context,
        text: 'NSX không được lớn hơn HSD',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (mfgDate.isAfter(now)) {
      snackBar = snackBarWidget(
        context: context,
        text: 'NSX không được lớn hơn ngày hiện tại',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (expDate.isBefore(now)) {
      snackBar = snackBarWidget(
        context: context,
        text: 'HSD không được nhỏ hơn ngày hiện tại',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (expDate == now && mfgDate == now) {
      snackBar = snackBarWidget(
        context: context,
        text: 'NSX và HSD không được bằng nhau',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (expDate.difference(mfgDate).inDays < 10) {
      snackBar = snackBarWidget(
        context: context,
        text: 'Thời hạn sử dụng không được nhỏ hơn 10 ngày',
        icon: 'asset/icons/warning_icon.svg',
        color: Color.fromARGB(255, 255, 121, 36),
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (sku.text.isEmpty) {
      calcThingsAboutDate();
      isShowResult = true;
    } else {
      calcThingsAboutDate();
      getProducts();
      isShowResult = true;
      isResultFound = dataLength > 0 ? true : false;
    }
    notifyListeners();
  }

  calcThingsAboutDate() {
    productApi!.then(
      (value) {
        if (value!.length > 0) {
          value.clear();
        }
      },
    );
    int twentyPercent = 0, thirtyPercent = 0, fourtyPercent = 0;
    totalDay = expDate.difference(mfgDate).inDays;
    currentPercent = (expDate
                .difference(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ))
                .inDays /
            expDate.difference(mfgDate).inDays *
            100)
        .round()
        .toInt();
    twentyPercent = (totalDay * .8).toInt();
    thirtyPercent = (totalDay * .7).toInt();
    fourtyPercent = (totalDay * .6).toInt();
    twentyPercentLeft = DateFormat('dd/MM/yyyy')
        .format(mfgDate.add(Duration(days: twentyPercent)));
    thirtyPercentLeft = DateFormat('dd/MM/yyyy')
        .format(mfgDate.add(Duration(days: thirtyPercent)));
    fourtyPercentLeft = DateFormat('dd/MM/yyyy')
        .format(mfgDate.add(Duration(days: fourtyPercent)));
    allowedDay = mfgDate
        .add(Duration(days: twentyPercent))
        .difference(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ))
        .inDays
        .round();
    notifyListeners();
  }

  getProducts() async {
    firstProductDateLength = 0;
    productApi = DioClient().getAnyProducts(sku.text, 0);
    tagApi = DioClient().getAllTags();
    await productApi!.then((value) async {
      dataLength = value!.length;
      checkboxes = List.filled(dataLength, false);
      if (dataLength == 1) {
        Product tempItem;
        firstProductDateLength = value[0].dates.length;
        tempItem = value[0];
        selectedProductId = tempItem.id;
        await tagApi!.then(
          (tags) {
            tagList = List.filled(tags!.length, false);
            for (var i = 0; i < tags.length; i++) {
              if (tags[i].id == value[0].tag.id) {
                tagList[i] = true;
                break;
              }
            }
          },
        );
      }
    });
    notifyListeners();
  }

  saveNewDate(String sku, context) async {
    int numberNewMfg = 0, numberNewExp = 0;
    var splittedNewMfg = tempMfg.split('/');
    var splittedNewExp = tempExp.split('/');
    numberNewMfg = int.parse(splittedNewMfg.join(''));
    numberNewExp = int.parse(splittedNewExp.join(''));
    await productApi!.then(
      (products) {
        for (var i = 0; i < products![0].dates.length; i++) {
          var splittedMfg = products[0].dates[i].mfg.split('/');
          var splittedExp = products[0].dates[i].exp.split('/');
          var numberMfg = int.parse(splittedMfg.join(''));
          var numberExp = int.parse(splittedExp.join(''));
          if (numberMfg == numberNewMfg && numberExp == numberNewExp) {
            isExistedDate = true;
            break;
          }
        }
        if (isExistedDate == false) {
          isSaved = true;
          isExistedDate = true;
          firstProductDateLength = products[0].dates.length;
          firstProductDateLength += 1;
          DioClient().addNewDateToSheet(
            sku,
            tempMfg,
            tempExp,
            twentyPercentLeft,
            thirtyPercentLeft,
            fourtyPercentLeft,
          );
          snackBar = snackBarWidget(
            context: context,
            text: 'Đã lưu date mới',
            icon: 'asset/icons/info_icon.svg',
            color: Color.fromARGB(255, 94, 18, 99),
            textColor: Colors.white,
          );
        } else {
          snackBar = snackBarWidget(
            context: context,
            text: 'Date đã tồn tại',
            icon: 'asset/icons/warning_icon.svg',
            color: Color.fromARGB(255, 255, 121, 36),
            textColor: Colors.white,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    notifyListeners();
  }

  chooseDisplayProduct(int index) async {
    Product tempItem;
    await productApi!.then((value) async {
      tempItem = value![index];
      value.clear();
      value.add(tempItem);
      firstProductDateLength = value[0].dates.length;
      tempItem = value[0];
      selectedProductId = tempItem.id;
      print(selectedProductId);
      await tagApi!.then(
        (tags) {
          tagList = List.filled(tags!.length, false);
          for (var i = 0; i < tags.length; i++) {
            if (tags[i].id == value[0].tag.id) {
              tagList[i] = true;
              break;
            }
          }
        },
      );
    });
    checkboxes.fillRange(0, dataLength, false);
    checkboxes[index] = true;
    notifyListeners();
  }

  clearScreen() {
    sku.clear();
    mfg.clear();
    exp.clear();
    isShowResult = false;
    mfgDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    expDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    mfgIcon = expIcon = 'asset/icons/calendar_icon.svg';
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

  int calcRemainingDays(String twenty_pct) {
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

  clearAllFocuses(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  changeMfg(DateTime date) {
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    mfgDate = date;
    mfg.text = DateFormat('dd/MM/yyyy').format(mfgDate);
    mfgDate.isAfter(now)
        ? mfgIcon = 'asset/icons/calendar_unaccepted_icon.svg'
        : mfgIcon = 'asset/icons/calendar_accepted_icon.svg';
    notifyListeners();
  }

  changeExp(DateTime date) {
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    expDate = date;
    exp.text = DateFormat('dd/MM/yyyy').format(expDate);
    expDate.isBefore(now)
        ? expIcon = 'asset/icons/calendar_unaccepted_icon.svg'
        : expIcon = 'asset/icons/calendar_accepted_icon.svg';
    notifyListeners();
  }

  getPosition() {
    RenderBox box =
        positionedKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    xPosition = position.dx;
    yPosition = position.dy;
    print('x: ${xPosition} - y: ${yPosition}');
  }

  checkTag(int index) {
    int currentCheckedIndex = tagList.indexOf(true);
    tagList = List.filled(tagList.length, false);
    if (currentCheckedIndex == index) {
      tagList[0] = true;
    } else
      tagList[index] = true;
    notifyListeners();
  }

  chooseTagForProduct(context) async {
    await productApi!.then(
      (products) async {
        await tagApi!.then(
          (tags) {
            if (products![0].tag.id == tags![tagList.indexOf(true)].id) {
              print('same tag');
            } else {
              print('diff tag');
              products[0].tag.id = tags[tagList.indexOf(true)].id;
              products[0].tag.name = tags[tagList.indexOf(true)].name;
              DioClient().replaceTagToProduct(
                products[0].id.toString(),
                products[0].tag.id.toString(),
              );
              snackBar = snackBarWidget(
                context: context,
                text: 'Thêm thẻ cho sản phẩm thành công',
                icon: 'asset/icons/info_icon.svg',
                color: Color.fromARGB(255, 94, 18, 99),
                textColor: Colors.white,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        );
      },
    );
    notifyListeners();
  }

  addNewTag() async {
    String newTag = tagName.text.trim();
    DioClient().addTagToSheet(tagName.text.trim());
    tagApi = DioClient().getAllTags();
    await tagApi!.then((tags) async {
      tagList = List.filled(tags!.length, false);
      for (var i = 0; i < tags.length; i++) {
        if (tags[i].name == newTag) {
          tagList[i] = true;
          break;
        }
      }
    });
    notifyListeners();
  }

  replaceTag(int id) async {
    String newTag = tagName.text.trim();
    print(newTag);
    DioClient().replaceTagFromSheet(id.toString(), tagName.text.trim());
    await productApi!.then(
      (value) {
        if (value![0].tag.id == id) value[0].tag.name = newTag;
      },
    );
    tagApi = DioClient().getAllTags();
    await tagApi!.then((tags) {
      tagList = List.filled(tags!.length, false);
      for (var i = 0; i < tags.length; i++) {
        if (tags[i].name == newTag) {
          tagList[i] = true;
          break;
        }
      }
    });
    notifyListeners();
  }

  Future<bool> getTagExist(int tagId, Product p) async {
    print(tagId);
    tagExisted = Future.value(false);
    bool tempExist = false;
    productApiForTag = DioClient().getAnyProducts('', tagId);
    await productApiForTag!.then(
      (pros) {
        for (var i = 0; i < pros!.length; i++) {
          if (pros[i].tag.id == tagId) {
            tagExisted = Future.value(true);
            break;
          }
        }
      },
    );
    await tagExisted!.then(
      (value) async {
        tempExist = value;
        if (!tempExist) {
          DioClient().removeTagFromSheet(tagId.toString());
          tagApi = DioClient().getAllTags();
          await tagApi!.then((tags) {
            tagList = List.filled(tags!.length, false);
            for (var i = 0; i < tags.length; i++) {
              if (tags[i].id == p.tag.id) {
                tagList[i] = true;
                break;
              }
            }
          });
        }
      },
    );
    return tagExisted!;
  }
}
