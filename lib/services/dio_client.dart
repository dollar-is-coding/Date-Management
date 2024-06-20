import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/models/tag.dart';

class DioClient {
  final _dio = Dio();
  final _urlBase =
      'https://script.google.com/macros/s/AKfycbwQwGpXIvL-v7o5rSgAlnkltxFcw4mQLB3NMHDJxsEx9hYcjNjQ7av3Y_3k8ZGQyHRoKg/exec';

  Future<List<Product>?> getAnyProducts(String product) async {
    var response =
        await _dio.get(_urlBase + '?action=easySearch&product=' + product);
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        products = getProducts.take(20).map((e) {
          return Product.fromJson(e);
        }).toList();
        for (var i = 0; i < products.length; i++) {
          products[i].dates.sort(
                (a, b) => calcCurrentPercent(a.mfg, a.exp).compareTo(
                  calcCurrentPercent(b.mfg, b.exp),
                ),
              );
        }
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return products;
  }

  Future<List<Product>?> getAnyProductsWithDate(
      String product, int pct, int tag, int sortKey) async {
    String sortType = sortKey == 1 ? 'number' : 'alpha';
    String query =
        '?action=searchWithDate&product=${product}&pct=${pct}&tag_id=${tag}&sort=${sortType}';
    var response = await _dio.get(
      _urlBase + query,
    );
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        products = getProducts.map((e) => Product.fromJson(e)).toList();
        for (var i = 0; i < products.length; i++) {
          products[i].dates.sort(
                (a, b) => calcCurrentPercent(a.mfg, a.exp).compareTo(
                  calcCurrentPercent(b.mfg, b.exp),
                ),
              );
        }
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return products;
  }

  Future<List<Tag>?> getAllTags() async {
    var response = await _dio.get(_urlBase + '?action=getAllTags');
    List<Tag>? tags;
    try {
      if (response.statusCode == 200) {
        var getTags = response.data as List;
        tags = getTags.map((e) => Tag.fromJson(e)).toList();
      } else
        print('Status code is ' + response.statusCode.toString());
    } catch (e) {
      print(e);
    }
    return tags;
  }

  Future<void> addNewDateToSheet(
    String sku,
    String mfg,
    String exp,
    String twenty_pct,
    String thirty_pct,
    String fourty_pct,
  ) async {
    try {
      var response = await _dio.post(_urlBase + '?action=addDate', data: {
        'sku': sku,
        'mfg': mfg,
        'exp': exp,
        'twenty_pct': twenty_pct,
        'thirty_pct': thirty_pct,
        'fourty_pct': fourty_pct,
      });
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeDateFromSheet(String id) async {
    try {
      var response =
          await _dio.post(_urlBase + '?action=deleteDate', data: {'id': id});
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTagToSheet(String name) async {
    try {
      var response =
          await _dio.post(_urlBase + '?action=addTag', data: {'name': name});
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeTagFromSheet(String id) async {
    try {
      var response =
          await _dio.post(_urlBase + '?action=deleteTag', data: {'id': id});
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> replaceTagFromSheet(String id, String name) async {
    try {
      var response = await _dio.post(_urlBase + '?action=replaceTag',
          data: {'id': id, 'name': name});
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> replaceTagToProduct(String id, String tagId) async {
    try {
      var response = await _dio.post(_urlBase + '?action=replaceProduct',
          data: {'id': id, 'tag_id': tagId});
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  int calcCurrentPercent(String mfg, exp) {
    DateTime start = DateTime(
      int.parse(mfg.substring(6, 10)),
      int.parse(mfg.substring(3, 5)),
      int.parse(mfg.substring(0, 2)),
    );
    DateTime end = DateTime(
      int.parse(exp.substring(6, 10)),
      int.parse(exp.substring(3, 5)),
      int.parse(exp.substring(0, 2)),
    );
    DateTime now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    int fullRangeTime = end.difference(start).inDays;
    int leftRangeTime = end.difference(now).inDays;
    return (leftRangeTime / fullRangeTime * 100).round().toInt();
  }
}
