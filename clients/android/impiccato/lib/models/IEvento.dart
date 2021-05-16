import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/Status.dart';
import 'package:impiccato/models/Tentativo.dart';

abstract class IEvento {
  void giocatoreEntrato(Giocatore player);
  void giocatoreUscito(Giocatore player);
  void statusAggiornato(Status status);
  void tentantivo(Tentativo tentativo);
}
