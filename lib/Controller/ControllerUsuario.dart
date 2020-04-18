
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:bico/Model/ModelUsuario.dart';

class ControllerUsuario{
  ModelUsuario _modelCadastrar;

  ControllerUsuario(){
    _modelCadastrar =  ModelUsuario();
  }

  atualizarDados(var obj){
    _modelCadastrar.atualizarDados(obj);
  }

  realizarPostagem(Postagem postagem){
    _modelCadastrar.realizarPostagem(postagem);
  }

  cadastrarUsuario(Usuario usuario, var context){
    _modelCadastrar.cadastrarUsuario(usuario, context);
  }

  logarUsuario(Usuario usuario, var context){
    _modelCadastrar.logarUsuario(usuario, context);
  }
}