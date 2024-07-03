import 'package:flutter/material.dart';
import 'package:sg_date/models/product.dart';
import 'package:sg_date/services/dio_client.dart';

class CameraController extends ChangeNotifier {
  Future<List<Product>?>? products;
  String? name;

  Future<bool> findProduct(String barcodeCapture) async {
    name = '';
    products = DioClient().getAnyProducts(barcodeCapture, 0);
    await products!.then(
      (pros) {
        if (pros!.length > 0) {
          name = pros[0].name;
          return true;
        }
      },
    );
    return false;
  }
}
