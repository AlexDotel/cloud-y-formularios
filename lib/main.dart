import 'package:flutter/material.dart';

import 'package:form_val/src/bloc/provider.dart';

import 'package:form_val/src/pages/home_page.dart';
import 'package:form_val/src/pages/login_page.dart';
import 'package:form_val/src/pages/product_page.dart';
import 'package:form_val/src/pages/registo_page.dart';
import 'package:form_val/src/prefs/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());

} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    print( 'GUARDADO '+prefs.token);

    return Provider(
        child: MaterialApp(
      theme: ThemeData(
          fontFamily: 'SF Pro Display',
          primaryColor: Color.fromRGBO(21, 73, 122, 1)),
      debugShowCheckedModeBanner: false,
      title: 'Formulario',
      initialRoute: 'registro',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'registro': (BuildContext context) => RegistroPage(),
        'home': (BuildContext context) => HomePage(),
        'product': (BuildContext context) => ProductoPage()
      },
    ));
  }
}
