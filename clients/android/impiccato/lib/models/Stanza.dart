import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:impiccato/models/Giocatore.dart';
import 'package:impiccato/models/IEvento.dart';
import 'package:impiccato/models/Tentativo.dart';
import 'package:impiccato/models/Status.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Stanza with IterableMixin<Giocatore> implements IEvento {
  String _parolaParziale;
  List<Giocatore> _giocatori = [];
  String _nome;
  IEvento _evento;
  int _erroriRimanenti = 5;
  bool _paritaFinita = false;
  bool _vinto;

  @protected
  WebSocketChannel channel;

  Stanza(String nome) {
    this.nome = nome;
    _vinto = false;
    channel = IOWebSocketChannel.connect("ws://20.199.109.89:5000");
  }

  void listen(Function onSuccesso, Function onFallimento) {
    channel.stream.listen((e) {
      Map event = jsonDecode(e);
      String nomeEvento = event["nomeEvento"];
      Map<dynamic, dynamic> data = event["data"];
      switch (nomeEvento) {
        case "entrata":
          bool stato = data["successo"] as bool;
          if (onFallimento == null || onSuccesso == null) break;
          if (stato)
            onSuccesso();
          else
            onFallimento();
          break;
        case "creazioneStanza":
          print(data);
          bool stato = data["successo"] as bool;
          if (onFallimento == null || onSuccesso == null) break;
          if (stato)
            onSuccesso();
          else
            onFallimento();
          break;
        case "giocatoreEntrato":
          giocatoreEntrato(Giocatore.fromData(data));
          break;
        case "giocatoreUscito":
          giocatoreUscito(Giocatore.fromData(data));
          break;
        case "statusAggiornato":
          statusAggiornato(Status.fromData(data));
          break;
        case "tentativo":
          tentantivo(Tentativo.fromData(data));
          break;
      }
    });
  }

  void impostaEvento(IEvento evento) {
    this._evento = evento;
  }

  String get nome => _nome;
  int get erroriRimanenti => _erroriRimanenti;
  bool get partitafinita => _paritaFinita;
  bool get vinto {
    print(_vinto);
    return _vinto;
  }

  String get parolaParziale => _parolaParziale;

  @protected
  set parolaParziale(String parolaParziale) => _parolaParziale = parolaParziale;

  @protected
  IEvento get evento => _evento;

  @protected
  set erroriRimanenti(int errori) => _erroriRimanenti = errori;

  @protected
  set vinto(bool vinto) => _vinto = vinto;

  @protected
  set partitaFinita(bool partitaFinita) => _paritaFinita = partitaFinita;

  String get messaggio {
    if (_paritaFinita) {
      if (_vinto)
        return "Complimenti avete vinto !!!";
      else
        return "Ritenta sarai piu fortunato";
    } else
      return "Partita non ancora finita";
  }

  @protected
  set nome(String nome) {
    if (nome.isNotEmpty)
      _nome = nome;
    else
      throw new ArgumentError("il nome non puo essere vuoto");
  }

  void invia(String parola, Giocatore giocatore) {
    Tentativo t = new Tentativo(parola, giocatore);
    channel.sink.add(jsonEncode({"nomeEvento": "tentativo", "data": t.toData()}));
  }

  Giocatore operator [](int index) => _giocatori[index];

  @override
  void giocatoreEntrato(Giocatore player) {
    _giocatori.add(player);
    _evento?.giocatoreEntrato(player);
  }

  @override
  void giocatoreUscito(Giocatore player) {
    int index = _giocatori.indexOf(player);
    _giocatori.removeAt(index);
    _evento?.giocatoreUscito(player);
  }

  @override
  void statusAggiornato(Status status) {
    parolaParziale = status.parola;
    _erroriRimanenti = status.erroriRimanenti;

    _paritaFinita = !parolaParziale.contains("_") || erroriRimanenti < 0;
    _vinto = _paritaFinita && erroriRimanenti >= 0;

    if (partitafinita) channel.sink.close();

    _evento?.statusAggiornato(status);
  }

  @override
  void tentantivo(Tentativo tentativo) {}

  void entra(Function onSuccesso, Function onFallimento) {
    channel.sink.add(jsonEncode({"nomeEvento": "joinStanza", "data": nome}));
    listen(onSuccesso, onFallimento);
  }

  @override
  Iterator<Giocatore> get iterator => _giocatori.iterator;
}
