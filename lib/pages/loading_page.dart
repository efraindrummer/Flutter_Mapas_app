import 'package:flutter/material.dart';
import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/pages/acceso_gps_page.dart';
import 'package:mapas_app/pages/mapa_page.dart';

class LoadingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      ),
    );
  }

  Future checkGpsYLocation(BuildContext context) async {
    //verificar si hay permiso del gps
    //verificar si el gps esta activo
    Future.delayed(Duration(milliseconds: 1000), () {
      print('Loading Page');
    /* Navigator.pushReplacement(
      context,
      navegarMapaFedeIn(context, AccesoGpsPage()),
    ); */
  });
  }
}