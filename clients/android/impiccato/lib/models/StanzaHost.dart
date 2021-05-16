import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/Stanza.dart';
import 'package:impiccato/models/Status.dart';

import 'Tentativo.dart';

class StanzaHost extends Stanza {
  String _parola;

  StanzaHost(String nome, String parola) : super(nome) {
    this.parola = parola;
    this.parolaParziale = "";
    for (int i = 0; i < parola.length; i++) {
      parolaParziale += "_";
    }
  }

  String get parola => _parola;
  set parola(String parola) {
    if (parola.isNotEmpty)
      _parola = parola;
    else
      throw new ArgumentError("la parola non puo essere vuota");
  }

  @override
  String get messaggio {
    if (partitafinita) {
      if (vinto)
        return "La tua parola era troppo facile";
      else
        return "Bravo hai vinto";
    } else
      return "Partita non ancora finita";
  }

  @override
  void tentantivo(Tentativo tentativo) {
    String lettere = tentativo.risposta;
    Status nuovoStatus;

    if (lettere.length == 1) {
      if (parola.contains(lettere)) {
        String nuovaParolaParziale = parolaParziale;
        while (parola.contains(lettere)) {
          int index = parola.indexOf(lettere);
          nuovaParolaParziale = nuovaParolaParziale.replaceRange(index, index + 1, lettere);
          parola = parola.replaceRange(index, index + 1, "*");
        }

        nuovoStatus = new Status(nuovaParolaParziale, erroriRimanenti, tentativo.giocatoreAzione);
      } else
        nuovoStatus = new Status(parolaParziale, erroriRimanenti - 1, tentativo.giocatoreAzione);
    } else {
      if (parola.length == lettere.length) {
        bool corrisponde = true;
        for (int i = 0; i < parola.length && corrisponde; i++) {
          if (parola[i] != "*" && parola[i] != lettere[i]) corrisponde = false;
        }

        if (corrisponde)
          nuovoStatus = new Status(lettere, erroriRimanenti, tentativo.giocatoreAzione);
        else
          nuovoStatus = new Status(parolaParziale, erroriRimanenti - 1, tentativo.giocatoreAzione);
      } else
        nuovoStatus = new Status(parolaParziale, erroriRimanenti - 1, tentativo.giocatoreAzione);
    }

    this.channel.sink.add(jsonEncode({"nomeEvento": "statusAggiornato", "data": nuovoStatus.toData()}));
  }

  void creaStanza(Function onSuccesso, Function onFallimento) {
    channel.sink.add(jsonEncode({"nomeEvento": "creaStanza", "data": nome}));
    listen(onSuccesso, onFallimento);
  }

  @override
  void giocatoreEntrato(Giocatore giocatore) {
    super.giocatoreEntrato(giocatore);
    Status status = new Status(parolaParziale, erroriRimanenti, giocatore);
    channel.sink.add(jsonEncode({"nomeEvento": "statusAggiornato", "data": status.toData()}));
    print("status aggiornato");
  }

  @override
  void statusAggiornato(Status status) {
    parolaParziale = status.parola;
    erroriRimanenti = status.erroriRimanenti;

    partitaFinita = !parolaParziale.contains("_") || erroriRimanenti < 0;
    vinto = !(partitafinita && erroriRimanenti >= 0);

    if (partitafinita) channel.sink.close();

    evento?.statusAggiornato(status);
  }

  @override
  void invia(String parola, Giocatore giocatore) {
    throw new ErrorDescription("L'host non puo indovinare la parola");
  }

  @override
  void entra(Function onSuccesso, Function onFallimento) {
    throw new ErrorDescription("la stanza host non puo eseguire il join");
  }
}
