import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class CalcController extends ChangeNotifier {
  final mfg = TextEditingController();
  final exp = TextEditingController();
  final sku = TextEditingController();
  Future<List<Product>?>? apiProducts;
  List<Product>? list;
  int dataLength = 0;
  var checkboxes;
  var snackBar;
  var isResultShowed = false;
  var isSaved = false;

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
  final mfgFocus = FocusNode();
  final expFocus = FocusNode();
  final barcodeFocus = FocusNode();
  final skuFocus = FocusNode();
  int isShowed = 0;
  int totalDay = 0;
  int currentPercent = 0;
  int dayLeft = 0;
  late String twentyPercentLeft = '';
  late String thirtyPercentLeft = '';
  late String fourtyPercentLeft = '';
  int allowedDay = 0;
  ExpansionTileController? expansionController = ExpansionTileController();

  clearAllFocus(context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  changeMfg(DateTime date) {
    mfgDate = date;
    mfg.text = DateFormat('dd/MM/yyyy').format(mfgDate);
    notifyListeners();
  }

  changeExp(DateTime date) {
    expDate = date;
    exp.text = DateFormat('dd/MM/yyyy').format(expDate);
    notifyListeners();
  }

  getResult(context) async {
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (expDate == now && mfgDate == now) {
      snackBar = snackBarWidget(
        context: context,
        warningText: 'Chọn ngày sản xuất và hạn sử dụng',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (expDate.isBefore(mfgDate) ||
        expDate.difference(mfgDate).inDays < 10) {
      snackBar = snackBarWidget(
        context: context,
        warningText: expDate.isBefore(mfgDate)
            ? 'Hạn sử dụng nhỏ hơn ngày sản xuất'
            : 'Hạn sử dụng nhỏ hơn 10 ngày',
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (sku.text.isEmpty) {
      isResultShowed = true;
      apiProducts = Future.value([]);
      calcDate();
    } else {
      isResultShowed = true;
      isSaved = false;
      calcDate();
      search(sku.text);
    }
    notifyListeners();
  }

  calcDate() {
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
    print('calc date: ${expDate.difference(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        )).inDays} ${expDate.difference(mfgDate).inDays}');
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

  Future search(String search) async {
    apiProducts = DioClient().getCalc(search);
    list = await apiProducts;
    dataLength = list!.length;
    checkboxes = List.filled(dataLength, false);
    notifyListeners();
  }

  getProduct(int index) async {
    List<Product>? tempList;
    tempList = list;
    list = [];
    list!.add(tempList![index]);
    print(list);
    apiProducts = Future.value(list);
    calcDate();
    notifyListeners();
  }

  addNewDate(
    context,
    String sku,
    String mfg,
    String exp,
    String twenty_pct,
    String thirty_pct,
    String fourty_pct,
  ) async {
    DioClient().setDate(sku, mfg, exp, twenty_pct, thirty_pct, fourty_pct);
    isSaved = true;
    snackBar = snackBarWidget(
      context: context,
      warningText: 'Đã thêm date mới',
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    notifyListeners();
  }

  refreshScreen() {
    sku.clear();
    mfg.clear();
    exp.clear();
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
    apiProducts = Future.value([]);
    isResultShowed = false;
    notifyListeners();
  }
}
