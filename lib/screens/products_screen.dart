import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/products_controller.dart';
import 'package:sg_date/models/product.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
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
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: Consumer<ProductsController>(
                builder: (context, pro, child) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
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
                          color: Colors.black87,
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
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<ProductsController>(
        builder: (context, pro, child) {
          return RefreshIndicator(
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
                  return ListView(
                    physics: BouncingScrollPhysics(),
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
                                        EdgeInsets.only(bottom: 12),
                                    visualDensity: VisualDensity(
                                      horizontal: 0,
                                      vertical: -4,
                                    ),
                                    title: Text(
                                      products![index].sku.toString(),
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4),
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
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          210,
                                                                          225,
                                                                          255),
                                                              progressColor:
                                                                  Color
                                                                      .fromARGB(
                                                                          255,
                                                                          112,
                                                                          82,
                                                                          255),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  12, 8, 0, 8),
                                                          margin: EdgeInsets.only(
                                                              left: 12,
                                                              bottom: i ==
                                                                      dates.length -
                                                                          1
                                                                  ? 0
                                                                  : 12),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    239,
                                                                    249,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(20),
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
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
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    pro.changeDateList(
                                                                        dates[i]
                                                                            .id!,
                                                                        i,
                                                                        index);
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .playlist_remove_outlined,
                                                                    size: 22,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            44,
                                                                            37,
                                                                            88),
                                                                  ),
                                                                ),
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
                                  ),
                                );
                        } else {
                          return (pro.dataLength < 20 ||
                                  pro.dataLength % 2 != 0)
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                        }
                      },
                    ),
                  );
                }
                return Container(
                  child: Text('No data'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
