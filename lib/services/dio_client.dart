import 'package:dio/dio.dart';
import 'package:sg_date/models/product.dart';

class DioClient {
  final _dio = Dio();
  final _urlBase =
      'https://script.google.com/macros/s/AKfycbyUfRfkQvbc7sKtU5mQjMk68xMYz1V-wgvx1FiyPb8cfueudzM2_lgjKBopR1bJX9sw/exec';

  Future<List<Product>?> getProductList() async {
    var response = await _dio.get(_urlBase);
    List<Product>? products;
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

  Future<List<Product>?> getSearches(String search) async {
    var response = await _dio.get(_urlBase + '?search=' + search);
    List<Product>? products;
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

  Future<Product?> getProduct({required String sku}) async {
    var response = await _dio.get(_urlBase + '?detail=' + sku);
    Product? product;
    try {
      if (response.statusCode == 200) {
        product = Product.fromJson(response.data[0]);
        print(product.name);
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print('catch: ' + e.toString());
    }
    return product;
  }
}
