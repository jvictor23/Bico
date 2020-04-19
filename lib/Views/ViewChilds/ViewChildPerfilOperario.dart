import 'package:bico/Connection/Banco.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewChilds/ViewChildConversa.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqflite/sqflite.dart';

class ViewChildPerfilOperario extends StatefulWidget {
  @override
  _ViewChildPerfilOperarioState createState() =>
      _ViewChildPerfilOperarioState();
  Operario operario;
  ViewChildPerfilOperario(this.operario);
}

class _ViewChildPerfilOperarioState extends State<ViewChildPerfilOperario> {
  bool _dadosPronto = false;

  QuerySnapshot _postagem;
  Firestore db;
  var _dados;
  DocumentSnapshot _data;

  _iniciarBanco() async {

    Database banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    _dados = dado[0];
    _data =  await db.collection("Avaliacao").document(widget.operario.id).collection(widget.operario.id).document(_dados["id"]).get();
    CollectionReference postagem;
    postagem = db
        .collection("Postagem")
        .document(widget.operario.id)
        .collection(widget.operario.id);
    _postagem = await postagem.getDocuments();



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.operario.nome),
        ),
        body: _dadosPronto
            ? Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              imageUrl:
                                              widget.operario.imagemPerfil == null ? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : widget.operario.imagemPerfil,
                                              filterQuality: FilterQuality.medium,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                      CircularProgressIndicator(
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
                                                widget.operario.nome,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                widget.operario.telefone,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              Text(
                                                widget.operario.cidade,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              Text(
                                                widget.operario.tipo,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      RatingBar(
                                          initialRating: _data.exists ? _data.data["estrelas"] : 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 35,
                                          itemBuilder: (context, _) =>
                                              Icon(Icons.star),
                                          onRatingUpdate: (rating) async {

                                            Firestore db = Firestore.instance;
                                            widget.operario.estrelas = rating;

                                            db.collection("Avaliacao").document(widget.operario.id).collection(widget.operario.id).document(_dados["id"]).setData({"estrelas" : rating});

                                            var data = await db.collection("Avaliacao").document(widget.operario.id).collection(widget.operario.id).getDocuments();
                                            double estrelas = 0.0;
                                            for(var dado in data.documents){
                                              estrelas += dado.data["estrelas"];
                                            }

                                            widget.operario.estrelas = (estrelas / data.documents.length);

                                            db.collection("Usuarios").document(widget.operario.id).setData(widget.operario.toMap());



                                          }),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewChildConversa(widget.operario)));
                                          },
                                          child: Text("Conversar"),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 16),
                                    child: Text("Avaliação Individual"),)
                                ],
                              )),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
              _postagem.documents == null
                  ? SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text("Não há nenhuma publicação aqui"),
                    ),
                  )
                ]),
              )
                  : SliverList(
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
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: <Widget>[],
                                  ),
                                ),
                                CachedNetworkImage(
                                    imageUrl: _postagem.documents[index]
                                    ["imagem"],
                                    fit: BoxFit.cover,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Center(
                                        child:
                                        CircularProgressIndicator(
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
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.comment),
                                        onPressed: () {})
                                  ],
                                )
                              ],
                            ))),
                    childCount: _postagem.documents.length),
              )
            ]))
            : Center(child: CircularProgressIndicator()));
  }
}
