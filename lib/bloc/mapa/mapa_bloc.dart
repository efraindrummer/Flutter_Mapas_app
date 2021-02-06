import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/themes/uber_map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  
  MapaBloc() : super( new MapaState());

  // ignore: unused_field
  GoogleMapController _mapController;

  void initMap(GoogleMapController controller){

    if(!state.mapaListo){
      this._mapController = controller;

      //cambiar el estilo del mapa
      this._mapController.setMapStyle(jsonEncode(uberMapTheme));

      add(OnMapaListo());
    }

  }

  void moverCamara(LatLng destino){
    final cameraUpdate = CameraUpdate.newLatLng(destino);
    this._mapController?.animateCamera(cameraUpdate);
  }

  @override
  Stream<MapaState> mapEventToState( MapaEvent event ) async* {
    if(event is OnMapaListo){
      yield state.copyWith(mapaListo: true);
    }else if(event is OnNuevaUbicacion){
      print('Nueva ubicacion: ${event.ubicacion}');
    }
  }
}
