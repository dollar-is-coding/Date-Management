import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/controllers/camera_controller.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
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
        title: Text(
          'Barcode scanner',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: Consumer<CameraController>(
        builder: (context, camera, child) {
          return MobileScanner(
            controller: camera.controller,
            onDetect: (capture) {
              var barcode = capture.barcodes[0];
              Navigator.pop(context);
              Provider.of<CalcController>(context, listen: false)
                  .setSku(barcode.rawValue!);
            },
          );
        },
      ),
    );
  }
}
