class Giocatore {
  String _nome;

  Giocatore(String nome) {
    this.nome = nome;
  }

  String get nome => _nome;

  set nome(String nome) {
    if (nome.isNotEmpty && nome.length <= 20)
      _nome = nome;
    else
      throw new ArgumentError("il campo nome non puo essere vuoto o superare i 20 caratteri");
  }

  factory Giocatore.fromData(Map<String, dynamic> data) {
    Giocatore g = Giocatore(data["nome"]);
    return g;
  }

  bool operator ==(Object o) {
    Giocatore g = o;
    return g._nome == this._nome;
  }

  Map<String, dynamic> toData() {
    return {"nome": nome};
  }
}
