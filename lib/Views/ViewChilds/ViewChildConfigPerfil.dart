import 'dart:io';

import 'package:bico/Connection/Banco.dart';
import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:bico/Views/ViewLogin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class ViewChildConfigPerfil extends StatefulWidget {
  @override
  _ViewChildConfigPerfilState createState() => _ViewChildConfigPerfilState();
  BuildContext context;
  ViewChildConfigPerfil(this.context);
}

class _ViewChildConfigPerfilState extends State<ViewChildConfigPerfil> {
  var _dados;
  bool _dadosCarregado = false;
  ControllerUsuario _controllerUsuario = ControllerUsuario();
  String _nome;
  String _telefone;
  String _cidade;
  String _tipo;
  String _imagem;
  Database banco;
  File _img;

  _iniciarBanco() async {
    banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    setState(() {
      _dados = dado[0];
      _dadosCarregado = true;
      _nome = _dados["nome"];
      _telefone = _dados["telefone"];
      _cidade = _dados["cidade"];
      _tipo = _dados["tipoOperario"];
      _imagem = _dados["imagem"];
    });
  }

  _pegarImagemCamera() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 75);

    setState(() {
      _img = imagemSelecionada;
    });
  }

  _pegarImagemGaleria() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);

    setState(() {
      _img = imagemSelecionada;
    });
  }

  _verificaCondicoes() {
    if (_dados["tipoPerfil"] == "operario") {
      if (_nome.isNotEmpty) {
        if (_telefone.isNotEmpty) {
          if (_cidade.isNotEmpty) {
            if (_tipo.isNotEmpty) {
              if (_img == null) {
                _atualizarDados();
              } else {
                _uploadImage();
              }
            } else {}
          } else {}
        } else {}
      } else {}
    } else {
      if (_nome.isNotEmpty) {
        if (_telefone.isNotEmpty) {
          if (_cidade.isNotEmpty) {
            if (_img == null) {
              _atualizarDados();
            } else {
              _uploadImage();
            }
          } else {}
        } else {}
      } else {}
    }
  }

  _atualizarDados() {
    if (_dados["tipoPerfil"] == "operario") {
      Operario operario = Operario();
      operario.nome = _nome;
      operario.telefone = _telefone;
      operario.cidade = _cidade;
      operario.tipo = _tipo;
      operario.tipoPerfil = _dados["tipoPerfil"];
      operario.id = _dados["id"];
      operario.email = _dados["email"];
      operario.senha = _dados["senha"];
      operario.imagemPerfil = _imagem;
      _controllerUsuario.atualizarDados(operario);
      Navigator.pop(context,true);

      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);
    } else {
      Usuario usuario = Usuario();
      usuario.nome = _nome;
      usuario.telefone = _telefone;
      usuario.cidade = _cidade;
      usuario.tipoPerfil = _dados["tipoPerfil"];
      usuario.id = _dados["id"];
      usuario.email = _dados["email"];
      usuario.senha = _dados["senha"];
      usuario.imagemPerfil = _imagem;
      _controllerUsuario.atualizarDados(usuario);
      Navigator.pop(context, true);

      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);
    }
  }

  _uploadImage() {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo =
    pastaRaiz.child("imagemPerfilUsuario").child(_dados["id"] + ".JPEG");

    StorageUploadTask task = arquivo.putFile(_img);

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

      task.onComplete.then((StorageTaskSnapshot snapshot) {
        _recuperarUrlImagem(snapshot);
      });
    });
  }

  _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();
    _imagem = url;

    _atualizarDados();
  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurar Perfil"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _verificaCondicoes();
                })
          ],
        ),
        body: _dadosCarregado
            ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25)),
                        child: _img == null
                            ? CachedNetworkImage(
                          imageUrl: _dados["imagem"] == null ? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : _dados["imagem"],
                          filterQuality: FilterQuality.medium,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              )),
                        )
                            : Image.file(_img),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _pegarImagemCamera();
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Cores().corIcons(),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _pegarImagemGaleria();
                          },
                          
                          child: Icon(
                            Icons.image,
                            color: Cores().corIcons(),
                          ),
                        ),
                        RaisedButton(
                          onPressed: _img == null
                              ? null
                              : () {
                            setState(() {
                              _img = null;
                            });
                          },
                          child: Text("Remover"),
                          textColor: Cores().corIcons(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: TextFormField(
                  onChanged: (result) {
                    _nome = result;
                  },
                  initialValue: _nome,
                  decoration: InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.person)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextFormField(
                  onChanged: (result) {
                    _telefone = result;
                  },
                  initialValue: _telefone,
                  decoration: InputDecoration(
                      labelText: "Telefone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.phone)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextFormField(
                  onChanged: (result) {
                    _cidade = result;
                  },
                  initialValue: _cidade,
                  decoration: InputDecoration(
                      labelText: "Cidade",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.location_city)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: _dados["tipoPerfil"] == "operario" ? TextFormField(
                  onChanged: (result) {
                    _tipo = result;
                  },
                  initialValue: _tipo,
                  decoration: InputDecoration(
                      labelText: "Tipo Operario",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.person)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ) : null,
              ),

              Padding(padding: EdgeInsets.only(top: 20, right: 16),
                child: RaisedButton(
                  onPressed: (){
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut();
                    Banco().deleteBanco();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewLogin()), (Route<dynamic> rout) => false);
                  },
                  child: Text("Sair da conta"),
                  textColor: Cores().corIcons(),
                ),)
            ],
          ),
        )
            : Center(
          child: CircularProgressIndicator(),
        ));
  }
}
