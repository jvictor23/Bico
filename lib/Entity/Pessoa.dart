abstract class Pessoa{
  String _id;
  String _nome;
  String _telefone;
  List<Map<String, dynamic>> _cidade;
  String _imagem;
  String _tipoPerfil;
  String _email;
  String _senha;

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

  List<Map<String, dynamic>>  get cidade => _cidade;

  set cidade(List<Map<String, dynamic>> value) {
    _cidade = value;
  }

   String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }


  String get tipoPerfil => _tipoPerfil;

  set tipoPerfil(String value) {
    _tipoPerfil = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  
}