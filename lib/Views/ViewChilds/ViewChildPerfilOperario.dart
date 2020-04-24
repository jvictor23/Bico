import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Views/ViewChilds/ViewChildConversa.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ViewChildPerfilOperario extends StatefulWidget {
  @override
  _ViewChildPerfilOperarioState createState() =>
      _ViewChildPerfilOperarioState();
  Operario operario;
  ViewChildPerfilOperario(this.operario);
}

class _ViewChildPerfilOperarioState extends State<ViewChildPerfilOperario> {
  

  DocumentSnapshot _data;
  ControllerUsuario _controllerUsuario = ControllerUsuario();
  List<Postagem> _postagem;
  bool _dadosProntos = false;

  _iniciarBanco() async {
    _data = await _controllerUsuario.recuperarEstrelasIndividual(widget.operario.id);
    _postagem = await _controllerUsuario.recuperarPostagem(widget.operario.id);

    setState(() {
      _dadosProntos = true;
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
        appBar: AppBar(
          title: Text(widget.operario.nome),
        ),
        body: _dadosProntos ? Container(
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
                                              widget.operario.imagem == null ? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : widget.operario.imagem,
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
                                                widget.operario.cidade.first["nome"],
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

                                            _controllerUsuario.avaliarOperario(widget.operario.id, rating);

                                            

                                            



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


              SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context, index) => 
                        Container(
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
                                    imageUrl: _postagem[index].imagem,
                                    fit: BoxFit.cover,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => Center(
                                        child:
                                        CircularProgressIndicator(
                                          backgroundColor: Colors.black,
                                        ))),
                                Padding(
                                  padding: _postagem[index].descricao
                                  ==
                                      null
                                      ? EdgeInsets.all(0)
                                      : EdgeInsets.all(12),
                                  child: Text(_postagem[index].descricao ==
                                      null
                                      ? ""
                                      : _postagem[index].descricao),
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
                    childCount: _postagem.length),
              )

              
            ])) : Center(child: CircularProgressIndicator(),)
            );
  }
}
