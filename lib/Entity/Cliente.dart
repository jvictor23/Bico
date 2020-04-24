import 'package:bico/Entity/Pessoa.dart';

class Cliente extends Pessoa {

  Cliente();

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "nome" : this.nome,
      "telefone" : this.telefone,
      "cidade" : this.cidade,
      "email" : this.email,
      "senha" : this.senha,
      "tipoPerfil" : this.tipoPerfil,
      "imagem" : this.imagem
    };
    return map;
  }

}