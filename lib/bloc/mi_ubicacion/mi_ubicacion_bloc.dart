import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart' as Geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:meta/meta.dart';

part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {

  MiUbicacionBloc() : super(MiUbicacionState());

  // ignore: cancel_subscriptions
  StreamSubscription<Position> _positionSubscripcion;

  void iniciarSeguimiento(){

    Geolocator.Geolocator.getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 10
    ).listen((Geolocator.Position position) {
      print(position);
    });
  }

  void cancelarSeguimiento(){
    _positionSubscripcion?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState( MiUbicacionEvent event ) async* {
    //emitir nuevos estados
  }
}
