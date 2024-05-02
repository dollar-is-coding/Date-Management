import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/products_controller.dart';
import 'package:sg_date/models/product.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
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
                          'asset/icons/search.svg',
                          width: 20,
                          height: 20,
                          color: Colors.black.withOpacity(.8),
                          fit: BoxFit.scaleDown,
                        ),
                        Expanded(
                          child: TextField(
                            controller: pro.searchController,
                            textAlignVertical: TextAlignVertical.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 13,
                            keyboardType: TextInputType.number,
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
                            onChanged: (value) async {
                              pro.search(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                padding: EdgeInsets.only(left: 12),
                constraints: BoxConstraints(),
                highlightColor: Colors.transparent,
                onPressed: () {},
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                ),
              ),
            ),
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
              pro.refresh();
            },
            child: FutureBuilder<List<Product>?>(
              future: pro.apiProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  var products = snapshot.data;
                  if (products!.length > 0) {
                    return ListView(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: pro.scrollController,
                      children: List.generate(
                        pro.dataLength + 1,
                        (index) {
                          if (index < pro.dataLength) {
                            return !pro.proShowed![index]
                                ? Container()
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.04),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    margin: index == 0
                                        ? EdgeInsets.fromLTRB(12, 12, 12, 4)
                                        : EdgeInsets.fromLTRB(12, 4, 12, 4),
                                    child: ExpansionTile(
                                      shape: Border(),
                                      dense: true,
                                      childrenPadding:
                                          EdgeInsets.only(bottom: 16),
                                      visualDensity: VisualDensity(
                                        horizontal: 0,
                                        vertical: -4,
                                      ),
                                      title: Text(
                                        products[index].sku.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      subtitle: Text(
                                        products[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.black54),
                                      ),
                                      children: List.generate(
                                        products[index].dates.length,
                                        (i) {
                                          var dates = products[index].dates;
                                          return Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 0, 16, 0),
                                            child: IntrinsicHeight(
                                              child: !pro.dateShowed![index][i]
                                                  ? Container()
                                                  : Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(top: 8),
                                                              child:
                                                                  CircularPercentIndicator(
                                                                radius: 24.0,
                                                                animation: true,
                                                                animationDuration:
                                                                    1200,
                                                                lineWidth: 6.0,
                                                                percent: pro.count(
                                                                        dates[i]
                                                                            .mfg,
                                                                        dates[i]
                                                                            .exp) /
                                                                    100,
                                                                center: Text(
                                                                  pro
                                                                          .count(
                                                                              dates[i].mfg,
                                                                              dates[i].exp)
                                                                          .toString() +
                                                                      '%',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodySmall,
                                                                ),
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .round,
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        210,
                                                                        225,
                                                                        255),
                                                                progressColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        112,
                                                                        82,
                                                                        255),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Stack(
                                                            alignment: Alignment
                                                                .topRight,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            14,
                                                                            8,
                                                                            0,
                                                                            8),
                                                                margin: EdgeInsets.only(
                                                                    top: 8,
                                                                    left: 12,
                                                                    right: 4,
                                                                    bottom: i ==
                                                                            dates.length -
                                                                                1
                                                                        ? 0
                                                                        : 12),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color.fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255)
                                                                      .withOpacity(
                                                                          .16),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            28),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
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
                                                                          'Còn ${pro.dayLefts(dates[i].twentyPercent)} ngày',
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  pro.changeDateList(
                                                                      dates[i]
                                                                          .id!,
                                                                      i,
                                                                      index);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              3),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            121,
                                                                            36),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(.04),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            3,
                                                                        offset: Offset(
                                                                            0,
                                                                            3),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            3),
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 22,
                                                                      color: Colors
                                                                          .white,
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
                                          );
                                        },
                                      ),
                                    ),
                                  );
                          } else {
                            return (pro.dataLength < 20 ||
                                    pro.dataLength % 2 != 0)
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                          }
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'No data',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black26),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'No data',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.black26),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
