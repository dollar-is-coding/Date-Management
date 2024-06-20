import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/controllers/products_controller.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/models/tag.dart';
import 'package:sg_date/widgets/common_widgets.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsController>(
      builder: (context, parentValue, child) {
        return PopScope(
          onPopInvoked: (didPop) {
            parentValue.searchWithFilter(0, '');
            parentValue.changeSelectedFilter(100);
            parentValue.changeSelectedSort(1);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 112, 82, 255),
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.black12,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
              ),
              title: Row(
                children: [
                  // back screen
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      highlightColor: Colors.transparent,
                      onPressed: () => Navigator.pop(context),
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: SvgPicture.asset(
                        'asset/icons/arrow_left_icon.svg',
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  // input field
                  Expanded(
                    child: Consumer<ProductsController>(
                      builder: (context, pro, child) {
                        return Container(
                          padding: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color.fromARGB(255, 112, 82, 255),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'asset/icons/search2_icon.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(.8),
                                  BlendMode.srcIn,
                                ),
                                fit: BoxFit.scaleDown,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: pro.searchController,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    counterText: '',
                                    contentPadding: EdgeInsets.only(left: 6),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    hintText: 'Tìm kiếm',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.black54),
                                  ),
                                  onSubmitted: (value) async {
                                    if (value.isNotEmpty) {
                                      if (value == 'all')
                                        pro.searchWithFilter(0, '');
                                      else
                                        pro.searchWithFilter(0, value);
                                      pro.changeSelectedFilter(100);
                                      pro.changeSelectedSort(1);
                                      pro.showCountedResult();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // filter
                  Consumer<ProductsController>(
                    builder: (context, pro, child) {
                      return Container(
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            IconButton(
                              constraints: BoxConstraints(),
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                showGeneralDialog(
                                  context: context,
                                  barrierColor: Colors.black.withOpacity(.24),
                                  barrierDismissible: true,
                                  barrierLabel: 'Don\'t tap outside',
                                  pageBuilder:
                                      (context, animation1, animation2) {
                                    return Container();
                                  },
                                  transitionBuilder:
                                      (context, animation1, animation2, child) {
                                    return ScaleTransition(
                                      scale: Tween<double>(begin: 0, end: 1)
                                          .animate(animation1),
                                      child: AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        content: Consumer<ProductsController>(
                                          builder: (context, value, child) {
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .86,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // label
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                24, 12, 24, 0),
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                'Cài đặt',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Icon(
                                                                  Icons.close),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: .6,
                                                      ),
                                                      // sort dropdown
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 24,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Sắp xếp theo',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .7),
                                                                    ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                child:
                                                                    DropdownButton(
                                                                  elevation: 2,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  underline:
                                                                      SizedBox(),
                                                                  value: value
                                                                      .selectedSort,
                                                                  onChanged:
                                                                      (val) {
                                                                    value.changeSelectedSort(
                                                                        val);
                                                                  },
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return List
                                                                        .generate(
                                                                      value
                                                                          .sortOptions
                                                                          .length,
                                                                      (index) {
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            '${value.sortDisplayOptions[index]}',
                                                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  items: List
                                                                      .generate(
                                                                    value
                                                                        .sortOptions
                                                                        .length,
                                                                    (index) {
                                                                      return DropdownMenuItem(
                                                                        value: value
                                                                            .sortOptions[index],
                                                                        child:
                                                                            Text(
                                                                          '${value.sortDisplayOptions[index]}',
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      // filter dropdown
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 24,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Lọc từ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .7),
                                                                    ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                child:
                                                                    DropdownButton(
                                                                  elevation: 1,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  underline:
                                                                      SizedBox(),
                                                                  value: value
                                                                      .selectedFilter,
                                                                  onChanged:
                                                                      (val) {
                                                                    value.changeSelectedFilter(
                                                                        val);
                                                                  },
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return List
                                                                        .generate(
                                                                      value
                                                                          .filterOptions
                                                                          .length,
                                                                      (index) {
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            value.filterDisplayOptions[index],
                                                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  items: List
                                                                      .generate(
                                                                    value
                                                                        .filterOptions
                                                                        .length,
                                                                    (index) {
                                                                      return DropdownMenuItem(
                                                                        value: value
                                                                            .filterOptions[index],
                                                                        child:
                                                                            Text(
                                                                          value.filterDisplayOptions[
                                                                              index],
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // tag
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 24,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                'Chọn thẻ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              .7),
                                                                    ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                child:
                                                                    DropdownButton(
                                                                  elevation: 1,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  underline:
                                                                      SizedBox(),
                                                                  value: value
                                                                      .selectedTag,
                                                                  onChanged:
                                                                      (val) {
                                                                    value.changeSelectedTag(
                                                                        val);
                                                                  },
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return List
                                                                        .generate(
                                                                      value
                                                                          .tagOptions
                                                                          .length,
                                                                      (index) {
                                                                        return Center(
                                                                          child:
                                                                              Text(
                                                                            value.tagDisplayOptions[index],
                                                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                  items: List
                                                                      .generate(
                                                                    value
                                                                        .tagOptions
                                                                        .length,
                                                                    (index) {
                                                                      return DropdownMenuItem(
                                                                        value: value
                                                                            .tagOptions[index],
                                                                        child:
                                                                            Text(
                                                                          value.tagDisplayOptions[
                                                                              index],
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium,
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: .6,
                                                      ),
                                                      // button
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 12),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .32,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                  ),
                                                                  shadowColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    side:
                                                                        BorderSide(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: Text(
                                                                  'Hủy',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            112,
                                                                            82,
                                                                            255),
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .32,
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                  ),
                                                                  shadowColor:
                                                                      Colors
                                                                          .white,
                                                                  elevation: 0,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  pro.searchWithFilter(
                                                                    pro.filterOptions
                                                                        .indexOf(
                                                                            pro.selectedFilter),
                                                                    pro.searchController
                                                                        .text,
                                                                  );
                                                                  pro.showCountedResult();
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Ok',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: SvgPicture.asset(
                                'asset/icons/filter_icon.svg',
                                fit: BoxFit.scaleDown,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            pro.isCountResult
                                ? Container(
                                    margin: EdgeInsets.only(top: 3),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 245, 34, 45),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text(
                                      '${pro.dataLength}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            body: Consumer<ProductsController>(
              builder: (context, pro, child) {
                return LiquidPullToRefresh(
                  showChildOpacityTransition: false,
                  springAnimationDurationInMilliseconds: 800,
                  animSpeedFactor: 2,
                  color: Color.fromARGB(255, 112, 82, 255),
                  backgroundColor: Colors.white.withOpacity(.9),
                  onRefresh: () async {
                    pro.searchWithFilter(
                      pro.selectedFilterIndex,
                      pro.searchController.text,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List<Product>?>(
                      future: pro.apiProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .8,
                            child: Center(
                              child: LoadingAnimationWidget.fourRotatingDots(
                                color: Color.fromARGB(255, 112, 82, 255),
                                size: 30,
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          var products = snapshot.data;
                          if (products!.length > 0) {
                            return ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: pro.scrollController,
                              children: List.generate(
                                pro.displayDataLength + 1,
                                (index) {
                                  if (index < pro.displayDataLength) {
                                    return !pro.proShowed![index]
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(.04),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                12, index == 0 ? 8 : 2, 12, 4),
                                            child: ListTileTheme(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      8, 0, 20, 0),
                                              dense: true,
                                              horizontalTitleGap: 4,
                                              minLeadingWidth: 0,
                                              child: ExpansionTile(
                                                shape: Border(),
                                                dense: true,
                                                childrenPadding:
                                                    EdgeInsets.only(bottom: 12),
                                                visualDensity: VisualDensity(
                                                  horizontal: 0,
                                                  vertical: -4,
                                                ),
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 210, 225, 255),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          color: Color.fromARGB(
                                                              255, 0, 79, 124),
                                                        ),
                                                  ),
                                                ),
                                                title: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Provider.of<CalcController>(
                                                                context,
                                                                listen: false)
                                                            .clearScreen();
                                                        Provider.of<CalcController>(
                                                                context,
                                                                listen: false)
                                                            .setSku(products[
                                                                    index]
                                                                .sku
                                                                .toString());
                                                      },
                                                      child: Text(
                                                        '${products[index].sku} ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        pro.determineCheckedTag(
                                                            products[index]);
                                                        tagModalBottomSheet(
                                                            context,
                                                            products[index],
                                                            index);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: products[index]
                                                                      .tag
                                                                      .id ==
                                                                  1
                                                              ? Color.fromARGB(
                                                                  80,
                                                                  216,
                                                                  216,
                                                                  216)
                                                              : Color.fromARGB(
                                                                  80,
                                                                  210,
                                                                  225,
                                                                  255),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .label_rounded,
                                                              size: 16,
                                                              color: products[index]
                                                                          .tag
                                                                          .id ==
                                                                      1
                                                                  ? Color
                                                                      .fromARGB(
                                                                          160,
                                                                          75,
                                                                          124,
                                                                          139)
                                                                  : Color
                                                                      .fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255),
                                                            ),
                                                            Text(
                                                              products[index]
                                                                          .tag
                                                                          .id ==
                                                                      1
                                                                  ? ' +'
                                                                  : ' ${products[index].tag.name}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .copyWith(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            79,
                                                                            124),
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Row(
                                                  children: [
                                                    Text(
                                                      products[index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Text(
                                                      ' (${products[index].dates.length})',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                children: List.generate(
                                                  products[index].dates.length,
                                                  (i) {
                                                    var dates =
                                                        products[index].dates;
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          16, 0, 16, 0),
                                                      child: IntrinsicHeight(
                                                        child:
                                                            !pro.dateShowed![
                                                                    index][i]
                                                                ? Container()
                                                                : Padding(
                                                                    padding: dates.length >
                                                                                1 &&
                                                                            i !=
                                                                                dates.length -
                                                                                    1
                                                                        ? EdgeInsets.only(
                                                                            bottom:
                                                                                4)
                                                                        : EdgeInsets
                                                                            .all(0),
                                                                    child: Row(
                                                                      children: [
                                                                        // rounded percent chart
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.only(top: 4),
                                                                              decoration: BoxDecoration(
                                                                                color: Color.fromARGB(255, 112, 82, 255).withOpacity(.16),
                                                                                borderRadius: BorderRadius.only(
                                                                                  topLeft: Radius.circular(30),
                                                                                  bottomRight: Radius.circular(30),
                                                                                  bottomLeft: Radius.circular(30),
                                                                                ),
                                                                              ),
                                                                              child: Container(
                                                                                padding: EdgeInsets.all(6),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                ),
                                                                                child: CircularPercentIndicator(
                                                                                  radius: 24.0,
                                                                                  animation: true,
                                                                                  animationDuration: 1200,
                                                                                  lineWidth: 6.0,
                                                                                  percent: pro.calcCurrentPercent(dates[i].mfg, dates[i].exp) / 100,
                                                                                  center: Text(
                                                                                    pro.calcCurrentPercent(dates[i].mfg, dates[i].exp).toString() + '%',
                                                                                    style: Theme.of(context).textTheme.bodySmall,
                                                                                  ),
                                                                                  circularStrokeCap: CircularStrokeCap.round,
                                                                                  backgroundColor: backgroundProgressColor(
                                                                                    percentage: pro.calcCurrentPercent(dates[i].mfg, dates[i].exp),
                                                                                  ),
                                                                                  progressColor: progressColor(
                                                                                    percentage: pro.calcCurrentPercent(dates[i].mfg, dates[i].exp),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Stack(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            children: [
                                                                              Container(
                                                                                padding: EdgeInsets.fromLTRB(14, 4, 0, 4),
                                                                                margin: EdgeInsets.only(top: 4, left: 0, right: 4, bottom: i == dates.length - 1 ? 0 : 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Color.fromARGB(255, 112, 82, 255).withOpacity(.16),
                                                                                  borderRadius: BorderRadius.only(
                                                                                    bottomLeft: Radius.circular(12),
                                                                                    bottomRight: Radius.circular(12),
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${dates[i].mfg} - ${dates[i].exp}',
                                                                                        ),
                                                                                        Text(
                                                                                          '40%: ${dates[i].fourtyPercent}',
                                                                                        ),
                                                                                        Text(
                                                                                          '30%: ${dates[i].thirtyPerrcent}',
                                                                                        ),
                                                                                        Text(
                                                                                          '20%: ${dates[i].twentyPercent}',
                                                                                        ),
                                                                                        Text(
                                                                                          'Còn ${pro.calcDayLefts(dates[i].twentyPercent)} ngày',
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  pro.changeDateList(dates[i].id!, i, index);
                                                                                },
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Color.fromARGB(255, 255, 121, 36),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                    boxShadow: [
                                                                                      BoxShadow(
                                                                                        color: Colors.black.withOpacity(.04),
                                                                                        spreadRadius: 2,
                                                                                        blurRadius: 3,
                                                                                        offset: Offset(0, 0),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(3),
                                                                                    child: Icon(
                                                                                      Icons.close,
                                                                                      size: 22,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                  } else {
                                    return (pro.displayDataLength <= 20 ||
                                            pro.displayDataLength % 20 != 0)
                                        ? Container()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 40),
                                            child: Center(
                                              child: LoadingAnimationWidget
                                                  .staggeredDotsWave(
                                                color: Colors.blue,
                                                size: 30,
                                              ),
                                            ),
                                          );
                                  }
                                },
                              ),
                            );
                          }
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .8,
                            child: Center(
                              child: Text(
                                'Không tìm thấy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black26),
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .8,
                          child: Center(
                            child: Text(
                              'Không tìm thấy',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black26),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void tagModalBottomSheet(context, product, productIndex) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          builder: (context, scrollController) {
            return Consumer<ProductsController>(
              builder: (context, pros, child) {
                return Container(
                  height: MediaQuery.of(context).size.height * .4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: Icon(Icons.close_rounded),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Thẻ',
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
                            child: FutureBuilder<List<Tag>?>(
                              future: pros.apiTags,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingAnimationWidget
                                      .staggeredDotsWave(
                                    color: Color.fromARGB(255, 112, 82, 255),
                                    size: 30,
                                  );
                                }
                                if (snapshot.hasData) {
                                  var tagList = snapshot.data;
                                  return ListView(
                                    controller: scrollController,
                                    children: List.generate(
                                      tagList!.length,
                                      (index) {
                                        return Column(
                                          children: [
                                            index == 0
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      addTagDialog(
                                                          context,
                                                          product,
                                                          productIndex);
                                                    },
                                                    child: ListTile(
                                                      dense: true,
                                                      leading: SvgPicture.asset(
                                                        'asset/icons/bookmark_icon.svg',
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          Colors.black54,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        'Thêm thẻ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                color: Colors
                                                                    .black54),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            index == 0
                                                ? Divider(
                                                    height: 0,
                                                    indent: 55,
                                                    endIndent: 20,
                                                  )
                                                : Container(),
                                            InkWell(
                                              onTap: () {
                                                pros.changeCheckedTag(index);
                                              },
                                              onDoubleTap: () {
                                                Navigator.pop(context);
                                                // ed(context,
                                                //     tagList[index].id!);
                                                // calc.tagName.text =
                                                //     tagList[index].name;
                                                editTagDialog(
                                                    context,
                                                    product,
                                                    productIndex,
                                                    tagList[index].id);
                                                pros.tagController.text =
                                                    tagList[index].name;
                                              },
                                              child: tagList[index].id != 1
                                                  ? ListTile(
                                                      dense: true,
                                                      leading: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: Checkbox(
                                                          activeColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  112,
                                                                  82,
                                                                  255),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6),
                                                          ),
                                                          value:
                                                              pros.checkedTags[
                                                                  index],
                                                          onChanged: (val) {
                                                            pros.changeCheckedTag(
                                                                index);
                                                          },
                                                        ),
                                                      ),
                                                      title: Text(
                                                        '${tagList[index].name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      // trailing: index ==
                                                      //         tagList.length - 1
                                                      //     ? null
                                                      //     : InkWell(
                                                      //         child: SvgPicture.asset(
                                                      //           'asset/icons/trash_icon.svg',
                                                      //         ),
                                                      //         onTap: () {},
                                                      //       ),
                                                    )
                                                  : Container(),
                                            ),
                                            Divider(
                                              height: 0,
                                              indent: 55,
                                              endIndent: 20,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }
                                return Container(
                                  child: Text('No data'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 8,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 112, 82, 255),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Hủy',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color:
                                            Color.fromARGB(255, 112, 82, 255),
                                      ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 112, 82, 255),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  pros.chooseTagForProduct(
                                      product, productIndex,context);
                                },
                                child: Text(
                                  'Xác nhận',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void addTagDialog(context, product, productIndex) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.24),
      barrierDismissible: true,
      barrierLabel: 'Don\'t tap outside',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(animation1),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Consumer<ProductsController>(
              builder: (context, value, child) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .86,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Center(
                                  child: Text(
                                    'Thêm thẻ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    value.tagController.clear();
                                    tagModalBottomSheet(
                                        context, product, productIndex);
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: .6,
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: value.tagController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                counterText: '',
                                prefixIcon: SvgPicture.asset(
                                  'asset/icons/locate_icon.svg',
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(.8),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                hintText: 'Tên thẻ',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 227, 227, 227),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 112, 82, 255),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      value.tagController.clear();
                                      tagModalBottomSheet(
                                          context, product, productIndex);
                                    },
                                    child: Text(
                                      'Hủy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Color.fromARGB(
                                                255, 112, 82, 255),
                                          ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 112, 82, 255),
                                    ),
                                    onPressed: () async {
                                      if (value.tagController.text
                                          .trim()
                                          .isNotEmpty) {
                                        value.createNewTag();
                                        Navigator.of(context).pop();
                                        tagModalBottomSheet(
                                            context, product, productIndex);
                                      }
                                    },
                                    child: Text(
                                      'Xác nhận',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void editTagDialog(context, product, productIndex, tagId) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.24),
      barrierDismissible: true,
      barrierLabel: 'Don\'t tap outside',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0, end: 1).animate(animation1),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Consumer<ProductsController>(
              builder: (context, value, child) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .86,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Center(
                                  child: Text(
                                    'Sửa thẻ',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    tagModalBottomSheet(
                                        context, product, productIndex);
                                    value.tagController.clear();
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: .6,
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              style: Theme.of(context).textTheme.bodyMedium,
                              controller: value.tagController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                counterText: '',
                                prefixIcon: SvgPicture.asset(
                                  'asset/icons/locate_icon.svg',
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(.8),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                hintText: 'Tên thẻ',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.grey.shade500),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 227, 227, 227),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(255, 112, 82, 255),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      tagModalBottomSheet(
                                          context, product, productIndex);
                                      value.tagController.clear();
                                    },
                                    child: Text(
                                      'Hủy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Color.fromARGB(
                                                255, 112, 82, 255),
                                          ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .32,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 112, 82, 255),
                                    ),
                                    onPressed: () async {
                                      if (value.tagController.text
                                          .trim()
                                          .isNotEmpty) {
                                        Navigator.of(context).pop();
                                        value.editTag(tagId);
                                        value.tagController.clear();
                                        tagModalBottomSheet(
                                            context, product, productIndex);
                                      }
                                    },
                                    child: Text(
                                      'Xác nhận',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
