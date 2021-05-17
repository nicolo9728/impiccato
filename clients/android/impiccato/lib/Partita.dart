import 'package:flutter/material.dart';
import 'package:impiccato/Home.dart';
import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/IEvento.dart';
import 'package:impiccato/models/Stanza.dart';
import 'package:impiccato/models/Tentativo.dart';
import 'package:impiccato/models/Status.dart';

class Partita extends StatefulWidget {
  final Stanza stanza;
  final Giocatore giocatore;

  const Partita({this.stanza, this.giocatore});
  @override
  _PartitaState createState() => _PartitaState(stanza, giocatore);
}

class _PartitaState extends State<Partita> implements IEvento {
  Stanza stanza;
  Giocatore giocatore;
  TextEditingController _txtlettere = TextEditingController();

  _PartitaState(Stanza stanza, Giocatore giocatore) {
    this.stanza = stanza;
    this.giocatore = giocatore;

    this.stanza.impostaEvento(this);
  }

  void invia() {
    try {
      stanza.invia(_txtlettere.text, giocatore);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("errore"),
                content: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("In partita"), Text("Stanza: ${stanza.nome}")],
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "parola da indovinare",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              stanza.parolaParziale ?? "caricamento",
              style: TextStyle(fontSize: 20, letterSpacing: 5),
            ),
            SizedBox(height: 20),
            Text(
              "Tentativi: ${stanza.erroriRimanenti}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 70,
            ),
            TextField(
              controller: _txtlettere,
              decoration: InputDecoration(hintText: "inserisci la lettera o la parola"),
            ),
            TextButton(
                onPressed: invia,
                child: Text(
                  "Invia",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void giocatoreEntrato(Giocatore player) {
    setState(() {});
  }

  @override
  void giocatoreUscito(Giocatore player) {
    setState(() {});
  }

  @override
  void statusAggiornato(Status status) {
    if (stanza.partitafinita) {
      if (stanza.vinto)
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Hai vinto !!"),
                  content: Text(
                    "Buon per te",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [TextButton(onPressed: chiudi, child: Text("Fine"))],
                ));
      else
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Hai perso !!"),
                  content: Text(
                    "Sarai piu fortunato",
                    style: TextStyle(color: Colors.black),
                  ),
                  actions: [TextButton(onPressed: chiudi, child: Text("Fine"))],
                ));
    }
    setState(() {});
  }

  @override
  void tentantivo(Tentativo tentativo) {
    setState(() {});
  }

  void chiudi() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }
}
