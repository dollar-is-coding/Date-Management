import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
        backgroundColor: Colors.black12,
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
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) {
          var barcodes = capture.barcodes;
          if (barcodes[0].rawValue!.isNotEmpty) {
            showGeneralDialog(
              context: context,
              barrierColor: Colors.black.withOpacity(.4),
              barrierDismissible: false,
              barrierLabel: 'Don\'t tap outside',
              pageBuilder: (context, animation1, animation2) {
                return Container();
              },
              transitionBuilder: (context, animation1, animation2, child) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0, end: 1).animate(animation1),
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    content: Consumer<CameraController>(
                      builder: (context, cam, child) {
                        return FutureBuilder<bool>(
                          future: cam.findProduct(barcodes[0].rawValue!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    height:
                                        MediaQuery.of(context).size.height * .2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.transparent,
                                    ),
                                    child: Center(
                                      child: LoadingAnimationWidget
                                          .fourRotatingDots(
                                        color: Colors.white70,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasData) {
                              var productExisted = snapshot.data;
                              if (productExisted!) {
                                Navigator.pop(context);
                                Provider.of<CalcController>(context,
                                        listen: false)
                                    .clearScreen();
                                Provider.of<CalcController>(context,
                                        listen: false)
                                    .setSku(cam.name!);
                                return Container();
                              } else {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.sizeOf(context).width * .8,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: Color.fromARGB(
                                                  255, 210, 225, 255),
                                            ),
                                            child: Icon(
                                              Icons.priority_high_rounded,
                                              color: Color.fromARGB(
                                                  255, 0, 79, 124),
                                              size: 36,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              'Không tìm thấy',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, bottom: 12),
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              'Sản phẩm không thể tìm thấy bằng barcode. Nhập sku hoặc tên sản phẩm!',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: Colors.black54),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .32,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                        width: 1,
                                                        color: Color.fromARGB(
                                                            255, 112, 82, 255),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Trở về',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Color.fromARGB(
                                                              255,
                                                              112,
                                                              82,
                                                              255),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .32,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 112, 82, 255),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    'OK',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  child: Text('Không tìm thấy'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
