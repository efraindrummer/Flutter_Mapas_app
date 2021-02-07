
import 'package:flutter/material.dart';
import 'package:mapas_app/models/search_result.dart';

class SearchDestination extends SearchDelegate<SearchResult> {

  @override
  final String searchFieldLabel;
  
  SearchDestination() : this.searchFieldLabel = 'Buscar...';
  
  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => this.close(context, SearchResult(cancelo: true)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('Build Results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
  return ListView(
    children: [
      ListTile(
        leading: Icon(Icons.location_on),
        title: Text('Coloca la ubicacion manualmente'),
        onTap: (){
          this.close(context, SearchResult(cancelo: false, manual: true));
        },
      )
    ],
  );
}

}