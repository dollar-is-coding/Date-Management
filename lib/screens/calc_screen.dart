import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/controllers/products_controller.dart';
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
                      'asset/icons/search_icon.svg',
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
                      calc.clearScreen();
                    },
                    icon: SvgPicture.asset(
                      'asset/icons/refresh_icon.svg',
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
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
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 0),
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
                            'asset/icons/sku_icon.svg',
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
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
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
                  Row(
                    children: [
                      // mfg
                      Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 0),
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
                                        MediaQuery.of(context).size.height * .5,
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
                                'asset/icons/calendar_icon.svg',
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
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.04),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 0),
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
                                        MediaQuery.of(context).size.height * .5,
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
                                'asset/icons/calendar_icon.svg',
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
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
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
                  // Button
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Color.fromARGB(255, 112, 82, 255),
                      ),
                      onPressed: () {
                        calc.clearAllFocuses(context);
                        calc.showResult(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Tìm kiếm',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  // result
                  !calc.isShowResult
                      ? Container()
                      : Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.04),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(4, -4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  FutureBuilder<List<Product>?>(
                                    future: calc.productApi,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return ListTile(
                                          dense: true,
                                          visualDensity: VisualDensity(
                                            horizontal: -4,
                                            vertical: -2,
                                          ),
                                          contentPadding: EdgeInsets.all(0),
                                          leading: Icon(
                                            Icons.bookmark_rounded,
                                            color: Colors.black12,
                                          ),
                                          title: Container(
                                            height: 12,
                                            color: Colors.black12,
                                          ),
                                          subtitle: Container(
                                            height: 8,
                                            color:
                                                Colors.black12.withOpacity(.06),
                                          ),
                                        );
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.length == 1) {
                                        var product = snapshot.data;
                                        return ListTile(
                                          dense: true,
                                          visualDensity: VisualDensity(
                                            horizontal: -4,
                                            vertical: -2,
                                          ),
                                          contentPadding: EdgeInsets.all(0),
                                          leading: InkWell(
                                            onTap: () async {
                                              calc.saveNewDate(
                                                  product![0].sku.toString(),
                                                  context);
                                            },
                                            child: calc.isSaved
                                                ? SvgPicture.asset(
                                                    'asset/icons/bookmark_done_icon.svg',
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Color.fromARGB(
                                                          255, 38, 58, 150),
                                                      BlendMode.srcIn,
                                                    ),
                                                  )
                                                : SvgPicture.asset(
                                                    'asset/icons/bookmark_icon.svg',
                                                  ),
                                          ),
                                          title: Row(
                                            children: [
                                              Text(
                                                '${product![0].sku} ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              Text(
                                                '(${calc.firstProductDateLength})',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.black
                                                          .withOpacity(.8),
                                                    ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            product[0].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.black54),
                                          ),
                                          trailing: product[0].dates.length > 0
                                              ? InkWell(
                                                  child: SvgPicture.asset(
                                                    'asset/icons/arrow_right_icon.svg',
                                                  ),
                                                  onTap: () {
                                                    Provider.of<ProductsController>(
                                                            context,
                                                            listen: false)
                                                        .searchWithFilter(
                                                      0,
                                                      product[0].sku.toString(),
                                                    );
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        child: ProductsScreen(),
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                      ),
                                                    );
                                                  },
                                                )
                                              : null,
                                        );
                                      }
                                      return ListTile(
                                        dense: true,
                                        visualDensity: VisualDensity(
                                          horizontal: -4,
                                          vertical: -2,
                                        ),
                                        contentPadding: EdgeInsets.all(0),
                                        leading: Icon(
                                          Icons.bookmark_rounded,
                                          color: Colors.black12,
                                        ),
                                        title: Container(
                                          height: 12,
                                          color: Colors.black12,
                                        ),
                                        subtitle: Container(
                                          height: 8,
                                          color:
                                              Colors.black12.withOpacity(.06),
                                        ),
                                      );
                                    },
                                  ),
                                  // Date calced
                                  Row(
                                    children: [
                                      IntrinsicWidth(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 12),
                                              child:
                                                  Text('NSX: ${calc.mfg.text}'),
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
                                            Text(
                                                '40%: ${calc.fourtyPercentLeft}'),
                                            Divider(
                                              color: Colors.grey.shade300,
                                              height: 8,
                                            ),
                                            Text(
                                                '30%: ${calc.thirtyPercentLeft}'),
                                            Divider(
                                              color: Colors.grey.shade300,
                                              height: 8,
                                            ),
                                            Text(
                                                '20%: ${calc.twentyPercentLeft}'),
                                            Divider(
                                              color: Colors.grey.shade300,
                                              height: 8,
                                            ),
                                            Text(
                                                'Còn: ${calc.allowedDay} ngày'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: CircularPercentIndicator(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .14,
                                          animation: true,
                                          animationDuration: 1000,
                                          lineWidth: 10,
                                          percent: calc.currentPercent / 100,
                                          center: Text(
                                            calc.currentPercent.toString() +
                                                '%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          backgroundColor: Color.fromARGB(
                                              255, 210, 225, 255),
                                          progressColor:
                                              Color.fromARGB(255, 112, 82, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // result from API
                            FutureBuilder<List<Product>?>(
                              future: calc.productApi,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 24),
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      color: Color.fromARGB(255, 112, 82, 255),
                                      size: 30,
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  var products = snapshot.data;
                                  return products!.length > 1
                                      ?
                                      // Có nhiều hơn 1 sản phẩm hiển thị
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.04),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: Offset(4, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: List.generate(
                                              products.length,
                                              (index) {
                                                return CheckboxListTile(
                                                  value: calc.checkboxes[index],
                                                  onChanged: (value) =>
                                                      calc.chooseDisplayProduct(
                                                          index),
                                                  dense: true,
                                                  activeColor: Color.fromARGB(
                                                      255, 112, 82, 255),
                                                  visualDensity: VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -2,
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                  checkboxShape:
                                                      RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
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
                                                            color:
                                                                Colors.black54),
                                                  ),
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      :
                                      // Chỉ có 1 sản phẩm
                                      products.length > 0 &&
                                              products[0].dates.length > 0
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(12),
                                                  bottomRight:
                                                      Radius.circular(12),
                                                ),
                                                border: Border(
                                                  top: BorderSide(
                                                    color: Colors.grey.shade300,
                                                    width: 1,
                                                  ),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(.04),
                                                    spreadRadius: 2,
                                                    blurRadius: 3,
                                                    offset: Offset(4, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'NSX',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8),
                                                                  ),
                                                        ),
                                                        Text(
                                                          '20%',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8),
                                                                  ),
                                                        ),
                                                        Text(
                                                          'HSD',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .8),
                                                                  ),
                                                        ),
                                                      ],
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
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  children: [
                                                                    Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          16,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            210,
                                                                            225,
                                                                            255),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          100 *
                                                                          calc.calcCurrentPercent(
                                                                              dates[i].mfg,
                                                                              dates[i].exp),
                                                                      height:
                                                                          16,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            112,
                                                                            82,
                                                                            255),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '${calc.calcCurrentPercent(dates[i].mfg, dates[i].exp)}%',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                )
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 4,
                                                                      bottom:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        dates[i]
                                                                            .mfg
                                                                            .substring(
                                                                              0,
                                                                              5,
                                                                            ),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                      Text(
                                                                        dates[i]
                                                                            .mfg
                                                                            .substring(
                                                                              6,
                                                                              10,
                                                                            ),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        dates[i]
                                                                            .twentyPercent,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                      Text(
                                                                        '(${calc.calcRemainingDays(dates[i].twentyPercent)} ngày)',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        dates[i]
                                                                            .exp
                                                                            .substring(
                                                                              0,
                                                                              5,
                                                                            ),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                      Text(
                                                                        dates[i]
                                                                            .exp
                                                                            .substring(
                                                                              6,
                                                                              10,
                                                                            ),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .bodySmall,
                                                                      ),
                                                                    ],
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
                                            )
                                          : Container();
                                }
                                return Container();
                              },
                            ),
                          ],
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
