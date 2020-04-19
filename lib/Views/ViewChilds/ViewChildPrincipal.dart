import 'dart:async';

import 'package:bico/Connection/Banco.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfil.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfilOperario.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:via_cep_search/via_cep_search.dart';

class ViewChildPrincipal extends StatefulWidget {
  @override
  _ViewChildPrincipalState createState() => _ViewChildPrincipalState();
}

class _ViewChildPrincipalState extends State<ViewChildPrincipal> {

  Firestore avaliacao = Firestore.instance;
  var _dados;


  Future<List<Operario>> _recuperarOperarios() async {
    Firestore db = Firestore.instance;
    QuerySnapshot snapshot;
    //snapshot = await db.collection("Usuarios").where("cidade", isEqualTo: _dados["cidade"]).where("tipoPerfil", isEqualTo: "operario").getDocuments();
      snapshot = await db.collection("Usuarios").orderBy("estrelas", descending: true).getDocuments();
    //snapshot = await db.collection("Usuarios").where("cidade", isEqualTo: "Cocalzinho").getDocuments();

    List<Operario> listaOperarios = List();

    for (DocumentSnapshot item in snapshot.documents) {
      Operario operario = Operario();
      operario.nome = item.data["nome"];
      operario.telefone = item.data["telefone"];
      operario.cidade = item.data["cidade"];
      operario.id = item.data["id"];
      operario.tipo = item.data["tipo"];
      operario.tipoPerfil = item.data["tipoPerfil"];
      operario.email = item.data["email"];
      operario.senha = item.data["senha"];
      operario.estrelas = item.data["estrelas"];
      operario.imagemPerfil = item.data["imagemPerfil"];

      listaOperarios.add(operario);
    }

    return listaOperarios;
  }

  _iniciarBanco()async{
    Database banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    setState(() {
      _dados = dado[0];
    });


  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {
    return _dados == null ? Center(child: CircularProgressIndicator(),) : Scaffold(
        body: FutureBuilder<List<Operario>>(
            future: _recuperarOperarios(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                
                  if(snapshot.data.length == 0){
                    return Center(child: Text("Nenhum dado encontrado!"),);                    
                  }else{

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List<Operario> listaItens = snapshot.data;
                        Operario operario = listaItens[index];

                        return GestureDetector(
                          onTap: () {

                            if(_dados["id"] == operario.id ){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewChildPerfil(true)));
                            }else{
                              Operario op = Operario();
                              op.nome = operario.nome;
                              op.telefone = operario.telefone;
                              op.cidade = operario.cidade;
                              op.tipo = operario.tipo;
                              op.imagemPerfil = operario.imagemPerfil;
                              op.id = operario.id;
                              op.email = operario.email;
                              op.senha = operario.senha;
                              op.estrelas = operario.estrelas;
                              op.tipoPerfil = operario.tipoPerfil;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewChildPerfilOperario(operario)));
                            }

                          },
                          child: Card(
                              child: Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 60,
                                              backgroundColor: Colors.transparent,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: operario.imagemPerfil == null? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : operario.imagemPerfil,
                                                  filterQuality:
                                                  FilterQuality.medium,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                          CircularProgressIndicator(
                                                            backgroundColor: Colors.black,
                                                          )),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  operario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  operario.telefone,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                Text(
                                                  operario.cidade,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                Text(
                                                  operario.tipo,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                    RatingBar(

                                      initialRating: operario.estrelas == null
                                          ? 0
                                          : operario.estrelas,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 30,
                                      itemBuilder: (context, _) => Icon(Icons.star),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text("Avaliação Geral"),
                                    )
                                  ],
                                ),
                              )),
                        );
                      });
                  }

                  break;
              }
            }));
  }
}
