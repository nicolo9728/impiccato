import 'package:flutter/material.dart';
import 'package:impiccato/CreaStanza.dart';
import 'package:impiccato/JoinaStanza.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _pagine = [CreaStanza(), JoinaStanza()];
  int _paginaSelezionata = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("impiccato"),
      ),
      body: _pagine[_paginaSelezionata],
      bottomNavigationBar: BottomNavigationBar(
        items: [BottomNavigationBarItem(icon: Icon(Icons.add), label: "crea"), BottomNavigationBarItem(icon: Icon(Icons.arrow_upward), label: "entra")],
        onTap: (index) {
          setState(() {
            _paginaSelezionata = index;
          });
        },
        currentIndex: _paginaSelezionata,
      ),
    );
  }
}
