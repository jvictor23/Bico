import 'dart:async';
import 'dart:io';


import 'package:bico/Connection/Banco.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:bico/Views/ViewMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:sqflite/sqflite.dart';

class ViewEscolherImagem extends StatefulWidget {
  @override
  _ViewEscolherImagemState createState() => _ViewEscolherImagemState();
}

class _ViewEscolherImagemState extends State<ViewEscolherImagem> {
  File _file;
  bool _load = false;
  ProgressDialog pr;
  Database banco;

  _pegarImagemCamera() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _file = imagemSelecionada;
      _load = true;
    });
    Timer(Duration(seconds: 3),(){
      setState(() {
        _load = false;
      });
    });
  }

  _pegarImagemGaleria() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _file = imagemSelecionada;
      _load = true;
    });
    Timer(Duration(milliseconds: 2300),(){
      setState(() {
        _load = false;
      });
    });
  }

  _iniciarBanco()async{
    banco = await Banco().getBanco();
    List<dynamic> list = await banco.rawQuery("select * from Usuario");
    for(var dado in list){
      print(dado);
    }
  }

  _confirmando()async{
    Firestore db = Firestore.instance;
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    var dados = dado[0];

    if(_file == null){
      if(dados["tipoPerfil"] == "operario"){
        Operario usuario = Operario();
        usuario.id = dados["id"];
        usuario.nome = dados["nome"];
        usuario.telefone = dados["telefone"];
        usuario.cidade = dados["cidade"];
        usuario.email = dados["email"];
        usuario.senha = dados["senha"];
        usuario.tipoPerfil = dados["tipoPerfil"];
        usuario.tipo = dados["tipoOperario"];

        db.collection("Usuarios").document(usuario.id).setData(usuario.toMap());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);

      }else{
        Usuario usuario = Usuario();
        usuario.id = dados["id"];
        usuario.nome = dados["nome"];
        usuario.telefone = dados["telefone"];
        usuario.cidade = dados["cidade"];
        usuario.email = dados["email"];
        usuario.senha = dados["senha"];
        usuario.tipoPerfil = dados["tipoPerfil"];

        db.collection("Usuarios").document(usuario.id).setData(usuario.toMap());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);
      }
    }else{
      if(dados["tipoPerfil"] == "operario"){
        Operario usuario = Operario();
        usuario.id = dados["id"];
        usuario.nome = dados["nome"];
        usuario.telefone = dados["telefone"];
        usuario.cidade = dados["cidade"];
        usuario.email = dados["email"];
        usuario.senha = dados["senha"];
        usuario.tipoPerfil = dados["tipoPerfil"];
        usuario.tipo = dados["tipoOperario"];
        _uploadImage(usuario, _file);
      }else{
        Usuario usuario = Usuario();
        usuario.id = dados["id"];
        usuario.nome = dados["nome"];
        usuario.telefone = dados["telefone"];
        usuario.cidade = dados["cidade"];
        usuario.email = dados["email"];
        usuario.senha = dados["senha"];
        usuario.tipoPerfil = dados["tipoPerfil"];

        _uploadImage(usuario, _file);
      }
    }

  }

  _uploadImage(var usuario, File file){
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("imagemPerfilUsuario").child(usuario.id+".JPEG");

    StorageUploadTask task = arquivo.putFile(file);

    task.events.listen((StorageTaskEvent storageTaskEvent){

      /*if(storageTaskEvent.type == StorageTaskEventType.progress){
        setState(() {
          _upImage = true;
        });
      }else if(storageTaskEvent.type == StorageTaskEventType.success){
        setState(() {
          _upImage = false;
        });
      }*/

      task.onComplete.then((StorageTaskSnapshot snapshot){

        _recuperarUrlImagem(snapshot,usuario);

      });


    });

  }

  _recuperarUrlImagem(StorageTaskSnapshot snapshot, var usuario)async{
    String url = await snapshot.ref.getDownloadURL();
    String sql = "SELECT * FROM Usuario";
    List dados = await banco.rawQuery(sql);
    var dado = dados[0];
    usuario.imagemPerfil = url;
    Map<String, dynamic> dadosUpdate ={
      "imagem" : usuario.imagemPerfil
    };

    banco.update(
        "Usuario",
        dadosUpdate,
        where: "id = ?",
        whereArgs: [dado["id"]]
    );



    _salvarUsuario(usuario);

  }

  _salvarUsuario(var usuario){
    Firestore db = Firestore.instance;
    db.collection("Usuarios").document(usuario.id).setData(usuario.toMap());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);
  }

  _removerImagem(){
    setState(() {
      _file = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "Escolha uma imagem para o seu perfil",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: CircleAvatar(
                      child: _load ? CircularProgressIndicator() : Text(""),
                      radius: 100.0,
                      backgroundImage: _file == null ? NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png"
                      ) : FileImage(_file),
                      backgroundColor: Colors.grey,
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            _pegarImagemCamera();
                          },
                          color: Colors.teal,
                          child: Text(
                            "Câmera",
                            style: TextStyle(color: Colors.white),
                          )),
                      FlatButton(
                          onPressed: () {
                            _pegarImagemGaleria();
                          },
                          color: Colors.teal,
                          child: Text(
                            "Galeria",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: _file == null ? null : RaisedButton(
                    child: Text(
                      "Remover imagem",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _removerImagem();
                    },
                    color: Colors.teal,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    child: _file == null ? Text(
                      "Pular",
                      style: TextStyle(color: Colors.white),
                    ) : Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      pr = ProgressDialog(context);
                      pr.style(
                        message: "Carregando...",
                      );
                      pr.show();
                      _confirmando();
                    },
                    color: Colors.teal,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10, right: 16, left: 16),
                  child: _file == null ? Text(
                    "Se pular esta etapa, não se preocupe. Você pode colocar imagem no perfil quando quiser.",
                    textAlign: TextAlign.justify,
                  ) : null,
                )
              ],
            ),
          )),
    );
  }
}
