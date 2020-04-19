import 'dart:io';

import 'package:bico/Connection/Banco.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Views/ViewChilds/ViewChildConfigPerfil.dart';
import 'package:bico/Views/ViewChilds/ViewChildPostagem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class ViewChildPerfil extends StatefulWidget {
  @override
  _ViewChildPerfilState createState() => _ViewChildPerfilState();
  bool op;
  ViewChildPerfil(this.op);
}

class _ViewChildPerfilState extends State<ViewChildPerfil> {
  var _dados;
  QuerySnapshot _postagem;
  bool _dadosPronto = false;

  Firestore db;

  _iniciarBanco() async {
    CollectionReference postagem;
    Database banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    setState(() {
      _dados = dado[0];
    });
    print(_dados);
    // _dados = await db.collection("Usuarios").document(dados["id"]).get();
    if (_dados["tipoPerfil"] == "operario") {
      postagem = db
          .collection("Postagem")
          .document(_dados["id"])
          .collection(_dados["id"]);
      _postagem = await postagem.getDocuments();
    }

    setState(() {
      _dadosPronto = true;
    });
  }

  @override
  void initState() {
    super.initState();
    db = Firestore.instance;
    _iniciarBanco();
  }

  _pegarImagemCamera() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 75);

    if (imagemSelecionada != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewChildPostagem(imagemSelecionada)));
    }
  }






  _pegarImagemGaleria() async {
    File imagemSelecionada;
    File imagem;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);

    setState(() {
      imagem = imagemSelecionada;
    });

    if (imagem != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ViewChildPostagem(imagem)));
    }
  }

  @override
  Widget build(BuildContext context) {

    return _dadosPronto
        ? Scaffold(
        appBar: widget.op
            ? AppBar(
          title: Text(_dados["nome"]),
        )
            : null,
        body: Container(
            child: CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: 8, top: 8),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.horizontal(
                                                left: Radius.circular(25)),
                                            child: CachedNetworkImage(
                                              imageUrl: _dados["imagem"] == null ? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : _dados["imagem"],
                                              filterQuality: FilterQuality.medium,
                                              placeholder: (context, url) => Center(
                                                  child: CircularProgressIndicator(
                                                    backgroundColor: Colors.black,
                                                  )),
                                            ),
                                          ),
                                        ),

                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _dados["nome"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                _dados["telefone"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              Text(
                                                _dados["cidade"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              _dados["tipoPerfil"] == "operario"
                                                  ? Text(
                                                _dados["tipoOperario"],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              )
                                                  : Text(""),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: RaisedButton(
                                      onPressed: () {

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewChildConfigPerfil(context))).then((res){
                                          setState(() {
                                            _iniciarBanco();
                                          });
                                          
                                        });
                                      },
                                      child: Icon(Icons.settings, color: Cores().corIcons(),),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      _dados["tipoPerfil"] == "operario"
                          ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8, top: 8, right: 8),
                                child: Text(
                                    "Poste imagens de seu trabalho para as pessoas verem"),
                              ),
                              Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(0, 12, 0, 12),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          _pegarImagemCamera();
                                        },
                                        child: Icon(Icons.camera_alt, color: Cores().corIcons(),),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          _pegarImagemGaleria();
                                        },
                                        child: Icon(Icons.image, color: Cores().corIcons()),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      )
                          : Text(""),
                    ],
                  )
                ]),
              ),
              _dados["tipoPerfil"] == "operario"
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index) => Container(
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16.0, 16.0, 8.0, 8.0),
                                ),
                                CachedNetworkImage(
                                    imageUrl: _postagem.documents[index]
                                    ["imagem"],
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.black,
                                        ))),
                                Padding(
                                  padding: _postagem.documents[index]
                                  ["descricao"] ==
                                      null
                                      ? EdgeInsets.all(0)
                                      : EdgeInsets.all(12),
                                  child: Text(_postagem.documents[index]
                                  ["descricao"] ==
                                      null
                                      ? ""
                                      : _postagem.documents[index]
                                  ["descricao"]),
                                ),
                                /*Row(
                                    children: <Widget>[
                                      IconButton(
                                          icon: Icon(Icons.comment),
                                          onPressed: () {})
                                    ],
                                  )*/
                              ],
                            ))),
                    childCount: _postagem.documents.length),
              )
                  : SliverList(delegate: SliverChildListDelegate([]))
            ])))
        : Center(child: CircularProgressIndicator());
  }
}
