import 'package:flutter/material.dart';
import 'package:impiccato/Partita.dart';
import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/Stanza.dart';

class JoinaStanza extends StatefulWidget {
  @override
  _JoinaStanzaState createState() => _JoinaStanzaState();
}

class _JoinaStanzaState extends State<JoinaStanza> {
  TextEditingController _txtNomeStanza = TextEditingController(), _txtNomeGiocatore = TextEditingController();

  void entra() {
    print("ciao");
    try {
      Giocatore g = new Giocatore(_txtNomeGiocatore.text);
      Stanza stanza = new Stanza(_txtNomeStanza.text);
      stanza.entra(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Partita(
                      stanza: stanza,
                      giocatore: g,
                    )),
            (route) => false);
      }, () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Errore"),
                  content: Text("stanza non trovata"),
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
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "Entra nella Stanza",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 60,
            ),
            TextField(
              controller: _txtNomeStanza,
              decoration: InputDecoration(hintText: "nome stanza"),
            ),
            TextField(
              controller: _txtNomeGiocatore,
              decoration: InputDecoration(hintText: "nome giocatore"),
            ),
            SizedBox(
              height: 60,
            ),
            TextButton(
                onPressed: entra,
                child: Text(
                  "Entra",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ),
      ),
    );
  }
}
