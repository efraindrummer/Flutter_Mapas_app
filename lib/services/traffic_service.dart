

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/models/traffic_response.dart';

class TrafficService {

  //Sigleton
  TrafficService._privateConstructor();

  static final TrafficService _instance = TrafficService._privateConstructor();
  factory TrafficService(){
    return _instance;
  }

  final _dio = new Dio();
  final _baseUrl = 'https://api.mapbox.com/directions/v5';
  final _apiKey = 'pk.eyJ1IjoiZWZyYWluZHJ1bW1lciIsImEiOiJja2t2anByYmMxM2owMnduMHcybnFnemp4In0.AgMSElyiyQJ-pQm8WHe4CA';

  Future<TrafficResponse> getCoordsInicioYDestino(LatLng inicio, LatLng destino) async {

    final coordString = '${inicio.longitude},${inicio.latitude};${destino.longitude},${destino.latitude}';
    final url = '${this._baseUrl}/mapbox/driving/$coordString';
    final resp = await this._dio.get(url, queryParameters: {
      'alternatives': 'true',
      'geometries': 'polyline6',
      'steps': 'false',
      'access_token': this._apiKey,
      'language': 'es',
    });

    final data = TrafficResponse.fromJson(resp.data);

    return data;
  }
}