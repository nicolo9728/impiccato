import 'package:impiccato/models/Giocatore.dart';

class Status {
  String _parola;
  int _erroriRimanenti;
  Giocatore _giocatoreAzione;

  String get parola => _parola;
  int get erroriRimanenti => _erroriRimanenti;
  Giocatore get giocatoreAzione => _giocatoreAzione;

  Status(String parola, int erroriRimanenti, Giocatore giocatoreAzione) {
    _parola = parola;
    _erroriRimanenti = erroriRimanenti;
    _giocatoreAzione = giocatoreAzione;
  }

  factory Status.fromData(Map<String, dynamic> data) {
    Giocatore g = Giocatore.fromData(data["giocatoreAzione"]);
    Status s = new Status(data["parola"], data["erroriRimanenti"], g);

    return s;
  }

  Map<String, dynamic> toData() {
    return {"parola": parola, "erroriRimanenti": erroriRimanenti, "giocatoreAzione": giocatoreAzione.toData()};
  }
}
