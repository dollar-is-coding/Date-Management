import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/product_controller.dart';
import 'package:sg_date/models/product.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text('Products'),
      ),
      body: Consumer<ProductController>(
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
                        if (index <= pro.dataLength - 1) {
                          return Container(
                            margin: index == 0
                                ? EdgeInsets.fromLTRB(12, 4, 12, 0)
                                : index == pro.dataLength - 1
                                    ? EdgeInsets.fromLTRB(12, 0, 12, 16)
                                    : EdgeInsets.fromLTRB(12, 0, 12, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: index == 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    )
                                  : index == pro.dataLength - 1
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        )
                                      : BorderRadius.circular(0),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    visualDensity: VisualDensity(
                                      horizontal: 0,
                                      vertical: -4,
                                    ),
                                    leading: Text('${index + 1}'),
                                    title: Text(
                                      products![index].sku.toString(),
                                    ),
                                    subtitle: Text(products[index].name),
                                  ),
                                  index == pro.dataLength - 1
                                      ? Container()
                                      : Divider(
                                          thickness: 1,
                                          height: 0,
                                        ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
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
