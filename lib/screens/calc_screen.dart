import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/screens/noti_screen.dart';
import 'package:sg_date/screens/product_screen.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class CalcScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Color.fromARGB(255, 249, 251, 253),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SG Date'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ProductScreen(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    'asset/icons/data.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: NotiScreen(),
                        type: PageTransitionType.rightToLeft,
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    'asset/icons/no_noti.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<CalcController>(
        builder: (context, calc, child) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      focusNode: calc.barcodeFocus,
                      controller: calc.barcode,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      maxLength: 13,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        prefixIcon: SvgPicture.asset(
                          'asset/icons/barcode.svg',
                          fit: BoxFit.scaleDown,
                          color: Colors.black87,
                        ),
                        hintText: 'Barcode',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1.6,
                            color: Color.fromARGB(255, 227, 227, 227),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1.6,
                            color: Color.fromARGB(255, 173, 173, 173),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      focusNode: calc.skuFocus,
                      controller: calc.sku,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        counterText: '',
                        prefixIcon: SvgPicture.asset(
                          'asset/icons/sku.svg',
                          fit: BoxFit.scaleDown,
                          color: Colors.black87,
                        ),
                        hintText: 'SKU',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade500),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1.6,
                            color: Color.fromARGB(255, 227, 227, 227),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            width: 1.6,
                            color: Color.fromARGB(255, 173, 173, 173),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: calc.mfg,
                            focusNode: calc.mfgFocus,
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height * .4,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: Icon(
                                                        Icons.close_rounded),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Ngày sản xuất',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Localizations.override(
                                              context: context,
                                              locale: const Locale('vi'),
                                              child: CupertinoDatePicker(
                                                initialDateTime: calc.mfgDate,
                                                dateOrder:
                                                    DatePickerDateOrder.dmy,
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                minimumYear: 2015,
                                                maximumYear: 2030,
                                                onDateTimeChanged: (date) {
                                                  calc.changeMfg(date);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: SvgPicture.asset(
                                'asset/icons/mfg.svg',
                                fit: BoxFit.scaleDown,
                                color: Colors.black87,
                              ),
                              hintText: 'Ngày sản xuất',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey.shade500),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1.6,
                                  color: Color.fromARGB(255, 227, 227, 227),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1.6,
                                  color: Color.fromARGB(255, 173, 173, 173),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 12)),
                        Flexible(
                          child: TextField(
                            focusNode: calc.expFocus,
                            controller: calc.exp,
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height:
                                        MediaQuery.of(context).size.height * .4,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Colors.grey.shade400,
                                              ),
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: Icon(
                                                        Icons.close_rounded),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Hạn sử dụng',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Localizations.override(
                                              context: context,
                                              locale: const Locale('vi'),
                                              child: CupertinoDatePicker(
                                                initialDateTime: calc.expDate,
                                                dateOrder:
                                                    DatePickerDateOrder.dmy,
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                minimumYear: 2015,
                                                maximumYear: 2030,
                                                onDateTimeChanged: (date) =>
                                                    calc.changeExp(date),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: SvgPicture.asset(
                                'asset/icons/exp.svg',
                                fit: BoxFit.scaleDown,
                                color: Colors.black87,
                              ),
                              hintText: 'Hạn sử dụng',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.grey.shade500),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1.6,
                                  color: Color.fromARGB(255, 227, 227, 227),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1.6,
                                  color: Color.fromARGB(255, 173, 173, 173),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shadowColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color.fromARGB(255, 255, 121, 36),
                      ),
                      onPressed: () {
                        calc.clearAllFocus(context);
                        calc.calcDate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'asset/icons/search.svg',
                            color: Colors.white,
                            fit: BoxFit.scaleDown,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Tìm kiếm',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  calc.isShowed < 1
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            controller: calc.expansionController,
                            childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                            shape: Border(), // remove 2 line when collapse
                            title: Text(
                              'Tên sản phẩm',
                              textAlign: TextAlign.justify,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            children: [
                              rowWidget(
                                text: calc.fourtyPercentLeft,
                                label: '40%',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text: calc.thirtyPercentLeft,
                                label: '30%',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text: calc.twentyPercentLeft,
                                label: '20%',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text:
                                    '${calc.currentPercent == 0 ? 0 : calc.currentPercent}%',
                                label: '% hiện tại',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text: '${calc.allowedDay} ngày',
                                label: 'Còn bán',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text:
                                    '${calc.totalDay == 0 ? 0 : calc.totalDay} ngày',
                                label: 'Ngày sử dụng',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text: '097465',
                                label: 'SKU',
                                context: context,
                              ),
                              Divider(),
                              rowWidget(
                                text: '09846537254, 9237564899, 746574647',
                                label: 'Barcode',
                                context: context,
                              )
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
