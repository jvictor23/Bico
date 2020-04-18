class Mensagem{
  String _idMensagem;
  String _idUsuario;
  String _mensagem;
  String _time;

  Mensagem();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idMensagem" : this.idMensagem,
      "idUsuario" : this.idUsuario,
      "mensagem" : this.mensagem,
      "time" : this.time
    };
    return map;
  }

  String get idMensagem => _idMensagem;

  set idMensagem(String value) {
    _idMensagem = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

}