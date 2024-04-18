import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';

class ProductController extends ChangeNotifier {
  final scrollController = ScrollController();
  Future<List<Product>?>? apiProducts;
  List<Product>? products;
  int dataLength = 0;

  ProductController() {
    apiProducts = getProducts();
    addDataLength();
    scrollController.addListener(scrollListener);
  }
  Future<List<Product>?> getProducts() async {
    var response = await Dio().get(
        'https://script.google.com/macros/s/AKfycbxXwKBrJZYB48iY4w5EctdyVGM5qkKQDaGwMPenR65IFwKkdlPTIwurdbrPNyDzD8S8Dw/exec');
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        print(getProducts);
        products = getProducts.map((e) => Product.fromJson(e)).toList();
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return products;
  }

  scrollListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      addDataLength();
      print('scrolled to end + ${dataLength}');
      notifyListeners();
    } else
      print('scroll');
  }

  addDataLength() {
    dataLength += 20;
    if (products != null && dataLength > products!.length) {
      dataLength = products!.length;
    }
    notifyListeners();
  }

  Future refresh() async {
    dataLength = 20;
    apiProducts = getProducts();
    notifyListeners();
  }
}
