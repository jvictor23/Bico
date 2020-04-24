import 'package:bico/Entity/Pessoa.dart';

class Operario extends Pessoa {
  String _tipo;
  double _estrelas;

  Operario();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "telefone" : this.telefone,
      "cidade" : this.cidade,
      "email" : this.email,
      "senha" : this.senha,
      "tipoPerfil" : this.tipoPerfil,
      "imagem" : this.imagem,
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