import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/bloc/mapa/mapa_bloc.dart';
import 'package:mapas_app/bloc/mi_ubicacion/mi_ubicacion_bloc.dart';
import 'package:mapas_app/widgets/widgets.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  @override
  void initState() {
    BlocProvider.of<MiUbicacionBloc>(context).iniciarSeguimiento();
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<MiUbicacionBloc>(context).cancelarSeguimiento();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<MiUbicacionBloc, MiUbicacionState>(
            builder: ( _, state) => crearMapa(state)
          ),

          Positioned(
            top: 15,
            child: SearchBar()
          ),
          
          MarcadorManual()
        ],
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[

          BtnUbicacion(),

          BtnMiRuta(),

          BtnSeguirUbicacion()
        ],
      ),
    );
  }

  Widget crearMapa(MiUbicacionState state){

    if(!state.existeUbicacion) return Center(child: Text('Ubicando...'));

    final mapaBloc = BlocProvider.of<MapaBloc>(context);

    mapaBloc.add(OnNuevaUbicacion(state.ubicacion));
    //si tengo una ubicacion conicidad regreso esto

    final cameraPosition = new CameraPosition(
      target: state.ubicacion,
      zoom: 15,
    );
    return GoogleMap(
      initialCameraPosition: cameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: mapaBloc.initMap,
      polylines: mapaBloc.state.polylines.values.toSet(),
      onCameraMove: (cameraPosition){
        mapaBloc.add(OnMovioMapa(cameraPosition.target));
      },
    );
  }
}