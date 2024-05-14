import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
                            onSubmitted: (value) async {
                              pro.searchWithFilter(
                                pro.chosenOptions.indexOf(true),
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Consumer<ProductsController>(
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    padding: EdgeInsets.only(left: 12),
                    constraints: BoxConstraints(),
                    highlightColor: Colors.transparent,
                    onPressed: () => value.changeFilterShowed(),
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
                );
              },
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
              pro.searchWithFilter(
                pro.chosenOptions.indexOf(true),
                pro.searchController.text,
              );
            },
            child: ListView(
              children: [
                !pro.filterShowed
                    ? Container()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 44,
                        margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.04),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            4,
                            (index) {
                              return InkWell(
                                onTap: () async {
                                  pro.changeFilterOption(index);
                                  pro.searchWithFilter(
                                    index,
                                    pro.searchController.text,
                                  );
                                },
                                child: Container(
                                  height: 44,
                                  margin: EdgeInsets.all(2),
                                  child: Center(
                                    child: Text(
                                      pro.textOptions[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: pro.chosenOptions[index]
                                                ? Colors.black
                                                : Colors.black45,
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder<List<Product>?>(
                    future: pro.apiProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            shrinkWrap: true,
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
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                          child: ExpansionTile(
                                            shape: Border(),
                                            dense: true,
                                            childrenPadding:
                                                EdgeInsets.only(bottom: 12),
                                            visualDensity: VisualDensity(
                                              horizontal: 0,
                                              vertical: -4,
                                            ),
                                            title: Row(
                                              children: [
                                                Text(
                                                  '${products[index].sku} ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                Text(
                                                  '(${products[index].dates.length})',
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
                                              products[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Colors.black54),
                                            ),
                                            children: List.generate(
                                              products[index].dates.length,
                                              (i) {
                                                var dates =
                                                    products[index].dates;
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 0, 16, 0),
                                                  child: IntrinsicHeight(
                                                    child:
                                                        !pro.dateShowed![index]
                                                                [i]
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
                                                                            EdgeInsets.only(top: 8),
                                                                        child:
                                                                            CircularPercentIndicator(
                                                                          radius:
                                                                              24.0,
                                                                          animation:
                                                                              true,
                                                                          animationDuration:
                                                                              1200,
                                                                          lineWidth:
                                                                              6.0,
                                                                          percent:
                                                                              pro.calcCurrentPercent(dates[i].mfg, dates[i].exp) / 100,
                                                                          center:
                                                                              Text(
                                                                            pro.calcCurrentPercent(dates[i].mfg, dates[i].exp).toString() +
                                                                                '%',
                                                                            style:
                                                                                Theme.of(context).textTheme.bodySmall,
                                                                          ),
                                                                          circularStrokeCap:
                                                                              CircularStrokeCap.round,
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              210,
                                                                              225,
                                                                              255),
                                                                          progressColor: Color.fromARGB(
                                                                              255,
                                                                              112,
                                                                              82,
                                                                              255),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Stack(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      children: [
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              14,
                                                                              4,
                                                                              0,
                                                                              4),
                                                                          margin: EdgeInsets.only(
                                                                              top: 8,
                                                                              left: 12,
                                                                              right: 4,
                                                                              bottom: i == dates.length - 1 ? 0 : 2),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Color.fromARGB(255, 112, 82, 255).withOpacity(.16),
                                                                            borderRadius:
                                                                                BorderRadius.circular(6),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
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
                                                                          onTap:
                                                                              () async {
                                                                            pro.changeDateList(
                                                                                dates[i].id!,
                                                                                i,
                                                                                index);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 3),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Color.fromARGB(255, 255, 121, 36),
                                                                              borderRadius: BorderRadius.circular(4),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.black.withOpacity(.04),
                                                                                  spreadRadius: 2,
                                                                                  blurRadius: 3,
                                                                                  offset: Offset(0, 0),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            child:
                                                                                Padding(
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
                                                );
                                              },
                                            ),
                                          ),
                                        );
                                } else {
                                  return (pro.dataLength <= 20 ||
                                          pro.dataLength % 20 != 0)
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
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
              ],
            ),
          );
        },
      ),
    );
  }
}
