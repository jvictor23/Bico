class Postagem{
  String _idUser;
  String _nomeUser;
  String _descricao;
  String _tipoDeOperario;
  String _imagem;

  Postagem();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idUsuario" : this.idUser,
      "imagem" : this.imagem,
      "descricao" : this.descricao
    };
    return map;
  }

  String get idUser => _idUser;

  set idUser(String value) {
    _idUser = value;
  }

  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }
}