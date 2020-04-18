import 'package:bico/Connection/Banco.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:bico/Views/ViewEscolhaPerfil.dart';
import 'package:bico/Views/ViewMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';


class ModelUsuario{
  cadastrarUsuario(Usuario usuario, var context){
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((user){
      usuario.id = user.user.uid;
      Firestore db = Firestore.instance;
      db.collection("Usuarios").document(user.user.uid).setData(usuario.toMap());
      Navigator.pop(context);

    }).catchError((error){
      print(error.toString());
      if(error.toString().contains("ERROR_WEAK_PASSWORD")){
        Fluttertoast.showToast(
            msg: "Senha fraca! Digite uma senha com mais de 6 caracteres",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }
      if(error.toString().contains("ERROR_INVALID_EMAIL")){
        Fluttertoast.showToast(
            msg: "Digite um email válido",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }
    });

    FirebaseAuth a = FirebaseAuth.instance;
    a.signOut();
  }

  realizarPostagem(Postagem postagem){

  }

  atualizarDados(var obj)async{
    Database banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    var _dados = dado[0];
    Map<String, dynamic> data;


    if(_dados["tipoPerfil"] == "operario"){
      data = {
        "nome" : obj.nome,
        "telefone" : obj.telefone,
        "cidade" : obj.cidade,
        "tipoOperario" : obj.tipo,
        "imagem" : obj.imagemPerfil
      };

    }else{
      data = {
        "nome" : obj.nome,
        "telefone" : obj.telefone,
        "cidade" : obj.cidade,
        "imagem" : obj.imagemPerfil
      };

    }

    banco.update(
        "Usuario",
        data,
        where: "id = ?",
        whereArgs: [_dados["id"]]
    );

    Firestore db = Firestore.instance;
    db.collection("Usuarios").document(_dados["id"]).setData(obj.toMap());


  }

  logarUsuario(Usuario usuario, var context){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((user)async{
      Firestore db = Firestore.instance;
      var dados  = await db.collection("Usuarios").document(user.user.uid).get();
      Database banco = await Banco().createBanco();
      Map<String, dynamic> dadosUsuario = {
        "id" : user.user.uid,
        "nome" : dados.data["nome"],
        "telefone" : dados.data["telefone"],
        "cidade" : dados.data["cidade"],
        "tipoPerfil" : dados.data["tipoPerfil"],
        "tipoOperario" : dados.data["tipo"],
        "email" : dados.data["email"],
        "senha" : dados.data["senha"],
        "imagem" : dados.data["imagemPerfil"]
      };
      banco.insert("Usuario", dadosUsuario);

      if(dados.data["tipoPerfil"] == null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewEscolhaPerfil()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewMain()));
      }


    }).catchError((error){
      print(error);
      if(error.toString().contains("ERROR_INVALID_EMAIL")){
        Fluttertoast.showToast(
            msg: "Digite um email válido",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }
      if(error.toString().contains("ERROR_USER_NOT_FOUND")){
        Fluttertoast.showToast(
            msg: "Usuario não está cadastrado!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }

      if(error.toString().contains("ERROR_WRONG_PASSWORD")){
        Fluttertoast.showToast(
            msg: "Senha incorreta! Verifique e tente novamente",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }
    });

  }
}