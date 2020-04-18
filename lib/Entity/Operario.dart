import 'package:bico/Entity/Usuario.dart';

class Operario extends Usuario {
  String _tipo;
  double _estrelas;

  Operario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "nome" : this.nome,
      "telefone" : this.telefone,
      "cidade" : this.cidade,
      "email" : this.email,
      "senha" : this.senha,
      "tipoPerfil" : this.tipoPerfil,
      "imagemPerfil" : this.imagemPerfil,
      "tipo" : this.tipo,
      "estrelas" : this.estrelas
    };
    return map;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  double get estrelas => _estrelas;

  set estrelas(double value) {
    _estrelas = value;
  }
}