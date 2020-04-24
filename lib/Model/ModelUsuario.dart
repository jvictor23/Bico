import 'dart:io';
import 'package:bico/Entity/Cidade.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Entity/Cliente.dart';
import 'package:bico/Views/ViewCadastroCidades.dart';
import 'package:bico/Views/ViewEscolhaPerfil.dart';
import 'package:bico/Views/ViewMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ModelUsuario {
  FirebaseUser _user;
  FirebaseAuth _auth;
  Firestore _db;
  ModelUsuario() {
    this._auth = FirebaseAuth.instance;
    _db = Firestore.instance;
  }

  cadastrarUsuario(Cliente usuario, var context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((user) {
      usuario.id = user.user.uid;
      Firestore db = Firestore.instance;
      db
          .collection("Usuarios")
          .document(user.user.uid)
          .setData(usuario.toMap());
      Navigator.pop(context);
    }).catchError((error) {
      print(error.toString());
      if (error.toString().contains("ERROR_WEAK_PASSWORD")) {
        Fluttertoast.showToast(
            msg: "Senha fraca! Digite uma senha com mais de 6 caracteres",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
      if (error.toString().contains("ERROR_INVALID_EMAIL")) {
        Fluttertoast.showToast(
            msg: "Digite um email válido",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
    });

    FirebaseAuth a = FirebaseAuth.instance;
    a.signOut();
  }

  Future<String> recuperarIdUsuarioLogado() async {
    _user = await _auth.currentUser();

    return _user.uid;
  }

  Future<DocumentSnapshot> recuperarUsuarioLogado() async {
    _user = await _auth.currentUser();
    return _db.collection("Usuarios").document(_user.uid).get();
  }

  Future<List<Operario>> recuperarOperarios() async {
    Firestore db = Firestore.instance;
    QuerySnapshot snapshot;
    //snapshot = await db.collection("Usuarios").where("cidade", isEqualTo: _dados["cidade"]).where("tipoPerfil", isEqualTo: "operario").getDocuments();
    snapshot = await db
        .collection("Usuarios")
        .orderBy("estrelas", descending: true)
        .getDocuments();
    //snapshot = await db.collection("Usuarios").where("cidade", isEqualTo: "Cocalzinho").getDocuments();

    List<Operario> listaOperarios = List();
    List<Map<String,dynamic>> cidades = List();
    for (DocumentSnapshot item in snapshot.documents) {

      for(var city in item.data["cidade"]){
        Cidade cidade = Cidade();
        cidade.nome = city["nome"];
        cidade.uf = city["uf"];
        cidades.add(cidade.toMap());
      }
      
      Operario operario = Operario();
      operario.nome = item.data["nome"];
      operario.telefone = item.data["telefone"];
      operario.cidade = cidades.toList();
      operario.id = item.data["id"];
      operario.tipo = item.data["tipo"];
      operario.tipoPerfil = item.data["tipoPerfil"];
      operario.email = item.data["email"];
      operario.senha = item.data["senha"];
      operario.estrelas = item.data["estrelas"];
      operario.imagem = item.data["imagem"];

      listaOperarios.add(operario);
    }

    return listaOperarios;
  }

  realizarPostagem(Postagem postagem) {}

  atualizarOperarioLogado(Operario operario) async {
    _user = await _auth.currentUser();
    _db
        .collection("Usuarios")
        .document(_user.uid)
        .setData(operario.toMap());
  }


  atualizarOperarioAvaliado(Operario operario) async {
    _user = await _auth.currentUser();
    DocumentSnapshot ds =
        await _db.collection("Usuario").document(_user.uid).get();
    operario.nome = ds.data["nome"];
    operario.telefone = ds.data["telefone"];
    operario.email = ds.data["email"];
    operario.senha = ds.data["senha"];

    if (ds.data["cidade"] != null) {
      operario.cidade = ds.data["cidade"];
    }

    if (ds.data["tipoPerfil"] != null) {
      operario.cidade = ds.data["cidade"];
    }

    if (ds.data["tipo"] != null) {
      operario.cidade = ds.data["cidade"];
    }

    if (ds.data["imagem"] != null) {
      operario.imagem = ds.data["imagem"];
    }

    _db
        .collection("Usuarios")
        .document(operario.id)
        .setData(operario.toMap());
  }

  atualizarClienteLogado(Cliente cliente) async {
    _user = await _auth.currentUser();
    _db
        .collection("Usuarios")
        .document(_user.uid)
        .setData(cliente.toMap());
  }

  Future<bool> uploadImage(File file) async {
    _user = await _auth.currentUser();
    DocumentSnapshot ds =
        await _db.collection("Usuarios").document(_user.uid).get();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
        pastaRaiz.child("imagemPerfilUsuario").child(_user.uid + ".JPEG");

    StorageUploadTask task = arquivo.putFile(file);

    task.events.listen((StorageTaskEvent storageTaskEvent) {
      /*if(storageTaskEvent.type == StorageTaskEventType.progress){
        setState(() {
          _upImage = true;
        });
      }else if(storageTaskEvent.type == StorageTaskEventType.success){
        setState(() {
          _upImage = false;
        });
      }*/

      task.onComplete.then((StorageTaskSnapshot snapshot) async {
        
        String url = await snapshot.ref.getDownloadURL();
        if (ds.data["tipoPerfil"] == "operario") {

          List<Map<String,dynamic>> cidades = List();

        for(var city in ds.data["cidade"]){
          Cidade cidade = Cidade();
          cidade.nome = city["nome"];
          cidade.uf = city["uf"];
          cidades.add(cidade.toMap());
        }

          Operario operario = Operario();
          operario.nome = ds.data["nome"];
          operario.telefone = ds.data["telefone"];
          operario.cidade = cidades.toList();
          operario.email = ds.data["email"];
          operario.senha = ds.data["senha"];
          operario.tipoPerfil = ds.data["tipoPerfil"];
          operario.imagem = url;
          operario.tipo = ds.data["tipo"];
          operario.estrelas = ds.data["estrelas"];

          atualizarOperarioLogado(operario);
        } else {

          List<Map<String,dynamic>> cidades = List();

        for(var city in ds.data["cidade"]){
          Cidade cidade = Cidade();
          cidade.nome = city["nome"];
          cidade.uf = city["uf"];
          cidades.add(cidade.toMap());
        }

          Cliente cliente = Cliente();
          cliente.nome = ds.data["nome"];
          cliente.telefone = ds.data["telefone"];
          cliente.cidade = cidades.toList();
          cliente.email = ds.data["email"];
          cliente.senha = ds.data["senha"];
          cliente.tipoPerfil = ds.data["tipoPerfil"];
          cliente.imagem = url;
          atualizarClienteLogado(cliente);
          
        }
      });
    });

    return true;
  }

  uploadPostagem(Postagem postagem, BuildContext context) async {
    _user = await _auth.currentUser();
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("Postagem")
        .child(_user.uid)
        .child("cimentado" + _user.uid + Timestamp.now().toString() + ".JPEG");
    StorageUploadTask task = arquivo.putFile(postagem.file);

    task.onComplete.then((StorageTaskSnapshot snapshot) async {
      Postagem postagem = Postagem();
      postagem.imagem = await snapshot.ref.getDownloadURL();
      postagem.idUser = _user.uid;
      salvarPostagem(postagem, context);
    });
  }

  salvarPostagem(Postagem postagem, BuildContext context) async {
    _db
        .collection("Postagem")
        .document(postagem.idUser)
        .collection(postagem.idUser)
        .add(postagem.toMap());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ViewMain()),
        (Route<dynamic> rout) => false);
  }

  Future<List<Postagem>> recuperarPostagem(String id) async {
    CollectionReference postagem;
    postagem = _db.collection("Postagem").document(id).collection(id);
    QuerySnapshot data = await postagem.getDocuments();

    List<Postagem> listaPostagem = List();

    for (DocumentSnapshot dados in data.documents) {
      Postagem postagem = Postagem();
      postagem.imagem = dados.data["imagem"];
      postagem.descricao = dados.data["descricao"];
      listaPostagem.add(postagem);
    }

    return listaPostagem;
  }

  avaliarOperario(String id, double rating) async {
     _user = await _auth.currentUser();
    _db
        .collection("Avaliacao")
        .document(id)
        .collection(id)
        .document(_user.uid)
        .setData({"estrelas": rating});

    var data = await _db
        .collection("Avaliacao")
        .document(id)
        .collection(id)
        .getDocuments();
    double estrelas = 0.0;
    for (var dado in data.documents) {
      estrelas += dado.data["estrelas"];
    }

    Operario operario = Operario();

    operario.estrelas = (estrelas / data.documents.length);
    operario.id = id;

    atualizarOperarioAvaliado(operario);

    
  }

  Future<DocumentSnapshot> recuperarEstrelasIndividual(String id) async {
    _user = await _auth.currentUser();
    return await _db
        .collection("Avaliacao")
        .document(id)
        .collection(id)
        .document(_user.uid)
        .get();
  }

  logarUsuario(Cliente cliente, var context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: cliente.email, password: cliente.senha)
        .then((user) async {
      DocumentSnapshot dados =
          await _db.collection("Usuarios").document(user.user.uid).get();

      if (dados.data["cidades"] == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ViewCadastroCidades()));
      } else if (dados.data["tipoPerfil"] == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ViewEscolhaPerfil()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ViewMain()));
      }
    }).catchError((error) {
      print(error);
      if (error.toString().contains("ERROR_INVALID_EMAIL")) {
        Fluttertoast.showToast(
            msg: "Digite um email válido",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
      if (error.toString().contains("ERROR_USER_NOT_FOUND")) {
        Fluttertoast.showToast(
            msg: "Usuario não está cadastrado!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }

      if (error.toString().contains("ERROR_WRONG_PASSWORD")) {
        Fluttertoast.showToast(
            msg: "Senha incorreta! Verifique e tente novamente",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
    });
  }
}
