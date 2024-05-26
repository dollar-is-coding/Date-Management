import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class CalcController extends ChangeNotifier {
  GlobalKey key = GlobalKey();
  var snackBar;
  final mfg = TextEditingController();
  final exp = TextEditingController();
  final sku = TextEditingController();
  final mfgFocus = FocusNode();
  final expFocus = FocusNode();
  final skuFocus = FocusNode();
  Future<List<Product>?>? productApi;
  int totalDay = 0;
  double xPosition = 0;
  double yPosition = 0;
  int currentPercent = 0;
  int allowedDay = 0;
  int dataLength = 0;
  bool isSaved = false;
  bool isShowResult = false;
  bool isExistedDate = false;
  bool isResultFound = false;
  bool isAreaShowed = false;
  int firstProductDateLength = 0;
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

  showResult(context) async {
    isSaved = false;
    isExistedDate = false;
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

  getProducts() {
    productApi = DioClient().getAnyProducts(sku.text);
    productApi!.then((value) {
      dataLength = value!.length;
      checkboxes = List.filled(dataLength, false);
      if (dataLength == 1) firstProductDateLength = value[0].dates.length;
    });
    notifyListeners();
  }

  saveNewDate(String sku, context) async {
    int numberNewMfg = 0, numberNewExp = 0;
    var splittedNewMfg = mfg.text.split('/');
    var splittedNewExp = exp.text.split('/');
    numberNewMfg = int.parse(splittedNewMfg.join(''));
    numberNewExp = int.parse(splittedNewExp.join(''));
    productApi!.then(
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
            mfg.text,
            exp.text,
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

  chooseDisplayProduct(int index) {
    var tempItem;
    productApi!.then((value) {
      tempItem = value![index];
      value.clear();
      value.add(tempItem);
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

  selectAllText() {
    sku.selection = TextSelection(
      baseOffset: 0,
      extentOffset: sku.text.length,
    );
    notifyListeners();
  }

  getPosition() {
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    isAreaShowed = true;
    xPosition = position.dx - 20;
    yPosition = position.dy + 30;
    print('x: ${position.dx}');
    notifyListeners();
  }
}
