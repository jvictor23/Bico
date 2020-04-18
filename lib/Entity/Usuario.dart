class Usuario{
  String _id;
  String _nome;
  String _telefone;
  String _cidade;
  String _email;
  String _senha;
  String _tipoPerfil;
  String _imagemPerfil;

  Usuario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "nome" : this.nome,
      "telefone" : this.telefone,
      "cidade" : this.cidade,
      "email" : this.email,
      "senha" : this.senha,
      "tipoPerfil" : this.tipoPerfil,
      "imagemPerfil" : this.imagemPerfil
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get telefone => _telefone;

  set telefone(String value) {
    _telefone = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get tipoPerfil => _tipoPerfil;

  set tipoPerfil(String value) {
    _tipoPerfil = value;
  }

  String get imagemPerfil => _imagemPerfil;

  set imagemPerfil(String value) {
    _imagemPerfil = value;
  }

}