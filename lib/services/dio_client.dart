import 'package:dio/dio.dart';
import 'package:sg_date/models/product.dart';

class DioClient {
  final _dio = Dio();
  final _urlBase =
      'https://script.google.com/macros/s/AKfycbwJskXYJcLBdmhJ3GFqH7aqztQIuo2OqX3XvkK9zKhgTHrHmVLQszzMYw8wM_PS5QoZlw/exec';

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
    var response = await _dio.get(
      _urlBase + '?search=' + search + '&isDate=true',
    );
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        print(getProducts);
        products =
            getProducts.take(20).map((e) => Product.fromJson(e)).toList();
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return products;
  }

  Future<List<Product>?> getCalc(String calc) async {
    var response = await _dio.get(_urlBase + '?search=' + calc);
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        print(getProducts);
        products = getProducts.take(20).map((e) {
          return Product.fromJson(e);
        }).toList();
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return products;
  }
}
