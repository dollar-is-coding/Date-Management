import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraController extends ChangeNotifier {
  late MobileScannerController controller;

  CameraController() {
    controller = MobileScannerController(detectionSpeed: DetectionSpeed.normal);
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  // findProduct(String barcodeCapture, BuildContext context) {
  //   name = '';
  //   products = DioClient().getAnyProducts(barcodeCapture, 0);
  //   products!.then(
  //     (pros) {
  //       if (pros!.length > 0) {
  //         name = pros[0].name;
  //         exist = true;
  //       } else {
  //         exist = false;
  //       }
  //     },
  //   );
  //   Navigator.pop(context);
  //   Navigator.pop(context);
  //   Provider.of<CalcController>(context, listen: false).clearScreen();
  //   Provider.of<CalcController>(context, listen: false).setSku(name!);
  //   notifyListeners();
  // }
}
