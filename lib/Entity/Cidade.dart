class Cidade{
  String _nome;
  String _uf;

  Cidade();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "uf" : this.uf
    };
    return map;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get uf => _uf;

  set uf(String value) {
    _uf = value;
  }
}