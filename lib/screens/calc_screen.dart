import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/screens/products_screen.dart';

class CalcScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 112, 82, 255),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black12,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                child: ProductsScreen(),
                type: PageTransitionType.rightToLeft,
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'asset/icons/search.svg',
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.transparent,
                            ),
                          ),
                          isDense: true,
                          counterText: '',
                          contentPadding: EdgeInsets.only(left: 10),
                          hintText: 'Tìm kiếm sản phẩm',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<CalcController>(
                builder: (context, calc, child) {
                  return IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      calc.refreshScreen();
                    },
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      body: Consumer<CalcController>(
        builder: (context, calc, child) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  // sku & barcode
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: calc.skuFocus,
                        controller: calc.sku,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          counterText: '',
                          prefixIcon: SvgPicture.asset(
                            'asset/icons/sku.svg',
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(.8),
                              BlendMode.srcIn,
                            ),
                          ),
                          hintText: 'Sku hoặc barcode',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey.shade500),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 227, 227, 227),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // mfg & exp
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        // mfg
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: calc.mfg,
                              focusNode: calc.mfgFocus,
                              readOnly: true,
                              style: Theme.of(context).textTheme.bodyMedium,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .5,
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
                                                          Navigator.pop(
                                                              context),
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
                                                          .bodyMedium,
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
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(.8),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                hintText: 'Ngày sản xuất',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 227, 227, 227),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 12)),
                        // exp
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.04),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              focusNode: calc.expFocus,
                              controller: calc.exp,
                              readOnly: true,
                              style: Theme.of(context).textTheme.bodyMedium,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .5,
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
                                                          Navigator.pop(
                                                              context),
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
                                                          .bodyMedium,
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
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(.8),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                hintText: 'Hạn sử dụng',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 227, 227, 227),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Button
                  Container(
                    width: MediaQuery.of(context).size.width * .4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shadowColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Color.fromARGB(255, 112, 82, 255),
                      ),
                      onPressed: () {
                        calc.clearAllFocus(context);
                        calc.getResult(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'asset/icons/search.svg',
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                            width: 16,
                            height: 16,
                            fit: BoxFit.scaleDown,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Tìm kiếm',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
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
                  // result
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: [
                          // Date calced
                          Row(
                            children: [
                              IntrinsicWidth(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text('NSX: ${calc.mfg.text}'),
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                    Text('HSD: ${calc.exp.text}'),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                    Text('40%: ${calc.fourtyPercentLeft}'),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                    Text('30%: ${calc.thirtyPercentLeft}'),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                    Text('20%: ${calc.twentyPercentLeft}'),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 8,
                                    ),
                                    Text('Còn: ${calc.allowedDay} ngày'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CircularPercentIndicator(
                                  radius:
                                      MediaQuery.of(context).size.width * .14,
                                  animation: true,
                                  animationDuration: 1000,
                                  lineWidth: 10,
                                  percent: calc.currentPercent / 100,
                                  center: Text(
                                    calc.currentPercent.toString() + '%',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  backgroundColor:
                                      Color.fromARGB(255, 210, 225, 255),
                                  progressColor:
                                      Color.fromARGB(255, 112, 82, 255),
                                ),
                              ),
                            ],
                          ),
                          // result ffrom API
                          FutureBuilder<List<Product>?>(
                            future: calc.productApi,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LoadingAnimationWidget.staggeredDotsWave(
                                  color: Color.fromARGB(255, 112, 82, 255),
                                  size: 30,
                                );
                              } else if (snapshot.hasData) {
                                var products = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Column(
                                    children: [
                                      Divider(
                                        color: Colors.grey.shade300,
                                        height: 8,
                                      ),
                                      products!.length > 1
                                          ?
                                          // Có nhiều hơn 1 sản phẩm hiển thị
                                          Column(
                                              children: List.generate(
                                                products.length,
                                                (index) {
                                                  return CheckboxListTile(
                                                    value:
                                                        calc.checkboxes[index],
                                                    onChanged: (value) => calc
                                                        .chooseProduct(index),
                                                    dense: true,
                                                    activeColor: Color.fromARGB(
                                                        255, 112, 82, 255),
                                                    visualDensity:
                                                        VisualDensity(
                                                      horizontal: -4,
                                                      vertical: -2,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    title: Text(
                                                      products[index]
                                                          .sku
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    subtitle: Text(
                                                      products[index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    controlAffinity:
                                                        ListTileControlAffinity
                                                            .leading,
                                                  );
                                                },
                                              ),
                                            )
                                          :
                                          // Chỉ có 1 sản phẩm
                                          Column(
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -2,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  leading: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        calc.saveNewDate(
                                                            products[0]
                                                                .sku
                                                                .toString(),
                                                            context);
                                                      },
                                                      child: Icon(
                                                        calc.isSaved
                                                            ? Icons
                                                                .bookmark_rounded
                                                            : Icons
                                                                .bookmark_outline_rounded,
                                                        color: Color.fromARGB(
                                                            255, 112, 82, 255),
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    '${products[0].sku} (${products[0].dates.length})',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  subtitle: Text(
                                                    products[0].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                            color:
                                                                Colors.black54),
                                                  ),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                    products[0].dates.length,
                                                    (i) {
                                                      var dates =
                                                          products[0].dates;
                                                      return Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              Stack(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 16,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          210,
                                                                          225,
                                                                          255),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        100 *
                                                                        calc.count(
                                                                            dates[i].mfg,
                                                                            dates[i].exp),
                                                                    height: 16,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                '${calc.count(dates[i].mfg, dates[i].exp)}%',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .white),
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 4,
                                                                    bottom: 10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  dates[i].mfg,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                                Text(
                                                                  '${calc.dayLefts(dates[i].twentyPercent)} ngày',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                                Text(
                                                                  dates[i].exp,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
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
