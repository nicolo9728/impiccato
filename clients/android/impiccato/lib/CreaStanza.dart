import 'package:flutter/material.dart';
import 'package:impiccato/Partita.dart';
import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/StanzaHost.dart';

class CreaStanza extends StatefulWidget {
  @override
  _CreaStanzaState createState() => _CreaStanzaState();
}

class _CreaStanzaState extends State<CreaStanza> {
  TextEditingController _txtNomeStanza = TextEditingController(), _txtParola = TextEditingController(), _txtNomeGiocatore = new TextEditingController();

  void creaStanza() {
    try {
      Giocatore g = new Giocatore(_txtNomeGiocatore.text);
      StanzaHost stanzaHost = new StanzaHost(_txtNomeStanza.text, _txtParola.text);

      stanzaHost.creaStanza(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Partita(
                      stanza: stanzaHost,
                      giocatore: g,
                    )),
            (route) => false);
      }, () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Errore"),
                  content: Text("il nome della stanza e gia stato usato"),
                ));
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Errore"),
                content: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "Crea Stanza",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 60,
            ),
            TextField(
              decoration: InputDecoration(hintText: "nome stanza"),
              controller: _txtNomeStanza,
            ),
            TextField(
              decoration: InputDecoration(hintText: "parola"),
              controller: _txtParola,
            ),
            TextField(
              decoration: InputDecoration(hintText: "nome giocatore"),
              controller: _txtNomeGiocatore,
            ),
            SizedBox(
              height: 60,
            ),
            TextButton(
                onPressed: creaStanza,
                child: Text(
                  "Crea",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
