import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/pages/acceso_gps_page.dart';
import 'package:mapas_app/pages/mapa_page.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if(state == AppLifecycleState.resumed){
      if( await Geolocator.GeolocatorPlatform.instance.isLocationServiceEnabled()){
        Navigator.pushReplacement(context, navegarMapaFedeIn(context, MapaPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: this.checkGpsYLocation(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          
          if(snapshot.hasData){
            return Center(child: Text(snapshot.data));
          }else{
            return Center(child: CircularProgressIndicator(strokeWidth: 2));
          }
        },
      ),
    );
  }

  Future checkGpsYLocation(BuildContext context) async {
    //verificar si hay permiso del gps
    final permisoGPS = await Permission.location.isGranted;
    //verificar si el gps esta activo
    final gpsActivo = await Geolocator.GeolocatorPlatform.instance.isLocationServiceEnabled();
    
    if(permisoGPS && gpsActivo){
      Navigator.pushReplacement(context, navegarMapaFedeIn(context, MapaPage()));
      return '';
    }else if(!permisoGPS){
      Navigator.pushReplacement(context, navegarMapaFedeIn(context, AccesoGpsPage()));
      return 'Es nesecario el permiso de el GPS';
    }else{
      return 'Active el GPS';
    }
    
  }
}