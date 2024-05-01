import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/screens/noti_screen.dart';
import 'package:sg_date/screens/products_screen.dart';

class CalcScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: InkWell(
                overlayColor: WidgetStateColor.transparent,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ProductsScreen(),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                },
                child: TextField(
                  enabled: false,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.transparent,
                      ),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SvgPicture.asset(
                        'asset/icons/search.svg',
                        width: 16,
                        height: 16,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    hintText: 'Tìm kiếm sản phẩm',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black54),
                  ),
                ),
              ),
            ),
            IconButton(
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
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
            )
          ],
        ),
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
                      focusNode: calc.skuFocus,
                      controller: calc.sku,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                      style: Theme.of(context).textTheme.bodyMedium,
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
                            .bodySmall!
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
                                'asset/icons/mfg.svg',
                                fit: BoxFit.scaleDown,
                                color: Colors.black87,
                              ),
                              hintText: 'Ngày sản xuất',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
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
                                'asset/icons/exp.svg',
                                fit: BoxFit.scaleDown,
                                color: Colors.black87,
                              ),
                              hintText: 'Hạn sử dụng',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
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
                        calc.getResult(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'asset/icons/search.svg',
                            color: Colors.white,
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
                  FutureBuilder<List<Product>?>(
                    future: calc.apiProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        var products = snapshot.data;
                        return products!.length > 1
                            ? Column(
                                children: List.generate(
                                  products.length,
                                  (index) {
                                    print(products.length);
                                    return InkWell(
                                      onTap: () async {
                                        calc.getProduct(index);
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          dense: true,
                                          visualDensity: VisualDensity(
                                            horizontal: 0,
                                            vertical: -4,
                                          ),
                                          leading: Checkbox(
                                            value: calc.checkboxes[index],
                                            onChanged: (val) async {
                                              calc.getProduct(index);
                                            },
                                          ),
                                          title: Text(
                                              products[index].sku.toString()),
                                          subtitle: Text(products[index].name),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : products.length == 1
                                ? Card(
                                    color: Colors.white,
                                    child: ExpansionTile(
                                      shape: Border(),
                                      dense: true,
                                      controller: calc.expansionController,
                                      childrenPadding:
                                          EdgeInsets.only(bottom: 12),
                                      visualDensity: VisualDensity(
                                        horizontal: 0,
                                        vertical: -4,
                                      ),
                                      leading: Icon(
                                        Icons.bookmark_outline_outlined,
                                      ),
                                      title: Text(products[0].sku.toString()),
                                      subtitle: Text(products[0].name),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'NSX: ${calc.mfg.text}',
                                                    ),
                                                    Text(
                                                      'HSD: ${calc.exp.text}',
                                                    ),
                                                    Text(
                                                      '40%: ${calc.fourtyPercentLeft}',
                                                    ),
                                                    Text(
                                                      '30%: ${calc.thirtyPercentLeft}',
                                                    ),
                                                    Text(
                                                      '20%: ${calc.twentyPercentLeft}',
                                                    ),
                                                    Text(
                                                      'Còn: ${calc.allowedDay} ngày',
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 50.0,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    lineWidth: 8.0,
                                                    percent:
                                                        calc.currentPercent /
                                                            100,
                                                    center: Text(
                                                      calc.currentPercent
                                                              .toString() +
                                                          '%',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 210, 225, 255),
                                                    progressColor:
                                                        Color.fromARGB(
                                                            255, 255, 121, 36),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Card(
                                    color: Colors.white,
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      shape: Border(),
                                      dense: true,
                                      controller: calc.expansionController,
                                      childrenPadding:
                                          EdgeInsets.only(bottom: 12),
                                      visualDensity: VisualDensity(
                                        horizontal: 0,
                                        vertical: -4,
                                      ),
                                      leading: Icon(
                                        Icons.bookmark_outline_outlined,
                                      ),
                                      title: Text('not found'),
                                      subtitle: Text('not found'),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'NSX: ${calc.mfg.text}',
                                                    ),
                                                    Text(
                                                      'NSX: ${calc.mfg.text}',
                                                    ),
                                                    Text(
                                                      '40%: ${calc.fourtyPercentLeft}',
                                                    ),
                                                    Text(
                                                      '30%: ${calc.thirtyPercentLeft}',
                                                    ),
                                                    Text(
                                                      '20%: ${calc.twentyPercentLeft}',
                                                    ),
                                                    Text(
                                                      'Còn: ${calc.allowedDay} ngày',
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  child:
                                                      CircularPercentIndicator(
                                                    radius: 50.0,
                                                    animation: true,
                                                    animationDuration: 1000,
                                                    lineWidth: 8.0,
                                                    percent: 0.4,
                                                    center: Text(
                                                      calc.currentPercent
                                                              .toString() +
                                                          '%',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall,
                                                    ),
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 210, 225, 255),
                                                    progressColor:
                                                        Color.fromARGB(
                                                            255, 255, 121, 36),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                      }
                      return Center(
                        child: Text('No data'),
                      );
                    },
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
