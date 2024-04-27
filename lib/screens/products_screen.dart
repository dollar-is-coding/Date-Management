import 'package:flutter/material.dart';
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              child: Consumer<ProductsController>(
                builder: (context, pro, child) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'asset/icons/search.svg',
                          width: 20,
                          height: 20,
                          fit: BoxFit.scaleDown,
                        ),
                        Expanded(
                          child: TextField(
                            controller: pro.searchController,
                            textAlignVertical: TextAlignVertical.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(left: 4),
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
                          return Card(
                            elevation: 0,
                            color: Colors.white60,
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: ExpansionTile(
                              shape: Border(),
                              dense: true,
                              childrenPadding: EdgeInsets.only(bottom: 12),
                              visualDensity: VisualDensity(
                                horizontal: 0,
                                vertical: -4,
                              ),
                              leading: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              title: Text(
                                products![index].sku.toString(),
                                style: Theme.of(context).textTheme.bodyMedium,
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
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: CircularPercentIndicator(
                                                  radius: 20.0,
                                                  animation: true,
                                                  animationDuration: 1200,
                                                  lineWidth: 8.0,
                                                  percent: 0.4,
                                                  center: Text(
                                                    pro
                                                        .count(dates[i].mfg,
                                                            dates[i].exp)
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  backgroundColor:
                                                      Colors.yellow,
                                                  progressColor: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          VerticalDivider(
                                            width: 24,
                                            thickness: .8,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  8, 8, 0, 8),
                                              margin: EdgeInsets.only(
                                                  bottom: i == dates.length - 1
                                                      ? 0
                                                      : 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white70,
                                                border: Border.all(
                                                    width: .6,
                                                    color:
                                                        Colors.grey.shade400),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                        dates[i].mfg,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            dates[i]
                                                                .fourtyPercent,
                                                          ),
                                                          Text('[40%]'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            dates[i]
                                                                .thirtyPerrcent,
                                                          ),
                                                          Text('[30%]'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            dates[i]
                                                                .twentyPercent,
                                                          ),
                                                          Text('[20%]'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                      Icons.more_vert_rounded,
                                                      size: 18,
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
