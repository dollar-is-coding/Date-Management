import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sg_date/controllers/calc_controller.dart';
import 'package:sg_date/controllers/products_controller.dart';
import 'package:sg_date/screens/calc_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(SGDate());
}

class SGDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalcController()),
        ChangeNotifierProvider(create: (_) => ProductsController()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('vi'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 236, 242, 255),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: CalcScreen(),
      ),
    );
  }
}
