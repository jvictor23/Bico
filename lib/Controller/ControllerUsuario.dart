
import 'dart:io';

import 'package:bico/Entity/Operario.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Entity/Cliente.dart';
import 'package:bico/Model/ModelUsuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ControllerUsuario{
  ModelUsuario _modelUsuario;


  ControllerUsuario(){
    _modelUsuario =  ModelUsuario();
  }

  Future<String> recuperarIdUsuarioLogado(){
    return _modelUsuario.recuperarIdUsuarioLogado();
  }

  Future<DocumentSnapshot> recuperarUsuarioLogado()async{
    return await _modelUsuario.recuperarUsuarioLogado();
  }

  Future<List<Operario>> recuperarOperarios(){
    return _modelUsuario.recuperarOperarios();
  }

  Future<List<Postagem>> recuperarPostagem(String id){
    return _modelUsuario.recuperarPostagem(id);
  }

  Future<DocumentSnapshot> recuperarEstrelasIndividual(String id)async{
    return await _modelUsuario.recuperarEstrelasIndividual(id);
  }

  avaliarOperario(String id, double rating){
    _modelUsuario.avaliarOperario(id, rating);
  }

  atualizarOperarioLogado(Operario operario){
    _modelUsuario.atualizarOperarioLogado(operario);
  }

  atualizarClienteLogado(Cliente cliente)async{
    await _modelUsuario.atualizarClienteLogado(cliente);
  }

  Future<bool>uploadImage(File file){
    return _modelUsuario.uploadImage(file);
  }

  uploadPostagem(Postagem postagem, BuildContext context){
    _modelUsuario.uploadPostagem(postagem, context);
  }


  realizarPostagem(Postagem postagem){
    _modelUsuario.realizarPostagem(postagem);
  }

  cadastrarUsuario(Cliente cliente, var context){
    _modelUsuario.cadastrarUsuario(cliente, context);
  }

  logarUsuario(Cliente cliente, var context){
    _modelUsuario.logarUsuario(cliente, context);
  }
}