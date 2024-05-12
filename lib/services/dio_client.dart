import 'package:dio/dio.dart';
import 'package:sg_date/models/product.dart';

class DioClient {
  final _dio = Dio();
  final _urlBase =
      'https://script.google.com/macros/s/AKfycbwpfp4VSBuUzkQzKYYhLyAInJU9nVYWEteevee1hAQSFnTIDxm233_HDGv-QfNePFaGeA/exec';

  // Calculate date percentage
  int count(String mfg, exp) {
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

  // Lấy ds sản phẩm
  Future<List<Product>?> getProductList() async {
    var response = await _dio.get(_urlBase);
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        // print(getProducts);
        products = getProducts.map((e) => Product.fromJson(e)).toList();
        for (var i = 0; i < products.length; i++) {
          products[i].dates.sort(
                (a, b) => count(a.mfg, a.exp).compareTo(
                  count(b.mfg, b.exp),
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

  // tìm sản phẩm có ghi date
  Future<List<Product>?> getSearches(String search) async {
    var response = await _dio.get(
      _urlBase + '?search=' + search + '&isDate=true',
    );
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        // print(getProducts);
        products =
            getProducts.take(20).map((e) => Product.fromJson(e)).toList();
        for (var i = 0; i < products.length; i++) {
          products[i].dates.sort(
                (a, b) => count(a.mfg, a.exp).compareTo(
                  count(b.mfg, b.exp),
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

  // Tìm sản phẩm bất kỳ không quan tâm có ghi date hay không
  Future<List<Product>?> getCalc(String calc) async {
    var response = await _dio.get(_urlBase + '?search=' + calc);
    List<Product>? products;
    try {
      if (response.statusCode == 200) {
        var getProducts = response.data as List;
        // print(getProducts);
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

  setDate(
    String sku,
    String mfg,
    String exp,
    String twenty_pct,
    String thirty_pct,
    String fourty_pct,
  ) async {
    try {
      var response = await _dio.post(
        _urlBase +
            '?sku=' +
            sku +
            '&mfg=' +
            mfg +
            '&exp=' +
            exp +
            '&twenty_pct=' +
            twenty_pct +
            '&thirty_pct=' +
            thirty_pct +
            '&fourty_pct=' +
            fourty_pct,
      );
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }

  removeDate(String id) async {
    try {
      var response = await _dio.post(_urlBase + '?id=' + id);
      if (response.statusCode == 200) {
        print(response.data);
      } else
        print('It fails ${response.statusCode}');
      print('right url ${response.headers['location']}');
    } catch (e) {
      print(e);
    }
  }
}
