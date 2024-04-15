import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class CalcController extends ChangeNotifier {
  final mfg = TextEditingController();
  final exp = TextEditingController();
  final barcode = TextEditingController();
  final sku = TextEditingController();

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
  final expansionController = ExpansionTileController();

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

  calcDate(context) {
    int twentyPercent = 0, thirtyPercent = 0, fourtyPercent = 0;
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final snackBar;
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
    } else {
      isShowed++;
      totalDay = expDate.difference(mfgDate).inDays;
      currentPercent = (expDate.difference(DateTime.now()).inDays /
              expDate.difference(mfgDate).inDays *
              100)
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
          .difference(DateTime.now())
          .inDays;
      if (isShowed >= 2 && !expansionController.isExpanded) {
        expansionController.expand();
      }
      notifyListeners();
    }
  }
}
