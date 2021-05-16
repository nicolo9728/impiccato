import 'package:impiccato/models/Giocatore.dart';

class Tentativo {
  String _risposta;
  Giocatore _giocatoreAzione;

  String get risposta => _risposta;
  Giocatore get giocatoreAzione => _giocatoreAzione;

  Tentativo(String risposta, Giocatore giocatoreAzione) {
    _giocatoreAzione = giocatoreAzione;
    this.risposta = risposta;
  }

  set risposta(String risposta) {
    if (risposta.isNotEmpty)
      _risposta = risposta;
    else
      throw new ArgumentError("la risposta non puo essere vuota");
  }

  factory Tentativo.fromData(Map<String, dynamic> data) {
    Tentativo t = new Tentativo(data["risposta"], Giocatore.fromData(data["giocatore"]));
    return t;
  }

  toData() {
    return {"risposta": risposta, "giocatore": giocatoreAzione.toData()};
  }
}
