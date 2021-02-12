import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Colors, Offset;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/themes/uber_map_theme.dart';
import 'package:meta/meta.dart';

part 'mapa_event.dart';
part 'mapa_state.dart';

class MapaBloc extends Bloc<MapaEvent, MapaState> {
  
  MapaBloc() : super( new MapaState());

  //controlador del mapa
  GoogleMapController _mapController;

  //polylines
  Polyline _miRuta = new Polyline(
    polylineId: PolylineId('mi_ruta'),
    width: 4,
    color: Colors.transparent
  );

  Polyline _miRutaDestino = new Polyline(
    polylineId: PolylineId('mi_ruta_destino'),
    width: 4,
    color: Colors.black87
  );

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
      yield* this._onNuevaUbicacion(event);
      
    } else if (event is OnMarcarRecorrido){
      yield* this._onMarcarRecorrido(event);      
    
    }else if(event is OnSeguirUbicacion){
      yield* _onSeguirUbicacion(event);

    }else if(event is OnMovioMapa){
      yield state.copyWith(ubicacionCentral: event.centroMapa);
      
    }else if(event is OnCrearRutaInicioDestino){
      yield* this._onCrearRutaInicioDestino(event);
    }
  }

  Stream<MapaState> _onNuevaUbicacion(OnNuevaUbicacion event) async* {

    if(state.seguirUbicacion){
      this.moverCamara(event.ubicacion);
    }
    
    final points = [ ...this._miRuta.points, event.ubicacion];
    this._miRuta = this._miRuta.copyWith(pointsParam: points);

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;
    
    yield state.copyWith(polylines: currentPolylines);
  }

  Stream<MapaState> _onMarcarRecorrido(OnMarcarRecorrido event) async* {
    
    if(state.dibujarRecorrido){
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.black87);
    }else{
      this._miRuta = this._miRuta.copyWith(colorParam: Colors.transparent);
    }

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta'] = this._miRuta;

    yield state.copyWith(
      dibujarRecorrido: !state.dibujarRecorrido,
      polylines: currentPolylines,
    );
  }

  Stream<MapaState> _onSeguirUbicacion(OnSeguirUbicacion event) async* {

    if(!state.seguirUbicacion){
      this.moverCamara(this._miRuta.points[this._miRuta.points.length - 1]);
    }
  
    yield state.copyWith(seguirUbicacion: !state.seguirUbicacion);
  }

  Stream<MapaState> _onCrearRutaInicioDestino(OnCrearRutaInicioDestino event) async* {
    
    this._miRutaDestino = this._miRutaDestino.copyWith(
      pointsParam: event.rutasCoordenadas
    );

    final currentPolylines = state.polylines;
    currentPolylines['mi_ruta_destino'] = this._miRutaDestino;

    //icono de inicio
    //final iconInicio = await getAssetImageMarker();
    final iconInicio = await getMarkerInicioIcon(event.duracion.toInt());
    final iconoDestino = await getNetworkImageMarker();

    //marcadores
    final markerInicio = new Marker(
      anchor: Offset(0.0, 1.0),
      markerId: MarkerId('inicio'),
      position: event.rutasCoordenadas[0],
      icon: iconInicio,
      infoWindow: InfoWindow(
        title: 'Mi ubicacion',
        snippet: 'Duracion recorrido: ${(event.duracion / 60).floor()} minutos',
      )
    );

    double kilometros = event.distancia / 1000;
    kilometros = (kilometros * 100).floor().toDouble();
    kilometros = kilometros / 100;

    final markerDestino = new Marker(
      markerId: MarkerId('destino'),
      position: event.rutasCoordenadas[event.rutasCoordenadas.length - 1],
      icon: iconoDestino,
      infoWindow: InfoWindow(
        title: event.nombreDestino,
        snippet: 'Distancia aproximada: $kilometros Km',
      )
    );

    final newMarkers = { ...state.markers };
    newMarkers['inicio'] = markerInicio;
    newMarkers['destino'] = markerDestino;

    Future.delayed(Duration(milliseconds: 300)).then(
      (value) {
        //_mapController.showMarkerInfoWindow(MarkerId('inicio'));
        //_mapController.showMarkerInfoWindow(MarkerId('destino'));
      }
    );

    yield state.copyWith(
      polylines: currentPolylines,
      markers: newMarkers
    );

  }
}
