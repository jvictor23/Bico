import 'dart:async';

import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Conversa.dart';
import 'package:bico/Entity/Mensagem.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ViewChildConversa extends StatefulWidget {
  @override
  _ViewChildConversaState createState() => _ViewChildConversaState();
  Operario operario;
  ViewChildConversa(this.operario);
}

class _ViewChildConversaState extends State<ViewChildConversa> {
  TextEditingController _mensagemController = TextEditingController();
  
  Firestore db = Firestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();
  ControllerUsuario _controllerUsuario = ControllerUsuario();
  DocumentSnapshot _dadosUsuario;
  
  _iniciarBanco() async {

    _dadosUsuario = await _controllerUsuario.recuperarUsuarioLogado();

    _adicionarListenerConversa();
  }

  _enviarMensagem() {
    print("Entrouuuuuuuuuuuuuuuuuuuuuu");
    String textoMensagem = _mensagemController.text;

    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _dadosUsuario.documentID;
      mensagem.mensagem = textoMensagem;
      mensagem.time = Timestamp.now().toString();
      _mensagemController.clear();
      //Salvar mensagem para o remetente
      _salvarMensagem(_dadosUsuario.documentID, widget.operario.id, mensagem);

      //Salvar mensagem para o destinatario
      _salvarMensagem(widget.operario.id, _dadosUsuario.documentID, mensagem);

      _salvarConversa(mensagem);
    }


  }

  _salvarConversa(Mensagem mensagem){
    //Salvar conversa remetente;
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _dadosUsuario.documentID;
    cRemetente.idDestinatario = widget.operario.id;
    cRemetente.mensagem = mensagem.mensagem;
    cRemetente.nome = widget.operario.nome;
    cRemetente.imagem = widget.operario.imagem;
    cRemetente.salvar();

    //Salvar conversa destinatario
    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = widget.operario.id;
    cDestinatario.idDestinatario = _dadosUsuario.documentID;
    cDestinatario.mensagem = mensagem.mensagem;
    cDestinatario.nome = _dadosUsuario.data["nome"];
    cDestinatario.imagem = _dadosUsuario.data["imagem"];
    cDestinatario.salvar();
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem mensagem) async {
    DocumentReference reference = await db
        .collection("Mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .add(mensagem.toMap());
    mensagem.idMensagem = reference.documentID;
    await db
        .collection("Mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .document(mensagem.idMensagem)
        .setData(mensagem.toMap());
  }

  Stream<QuerySnapshot> _adicionarListenerConversa() {
    final stream = db
        .collection("Mensagens")
        .document(_dadosUsuario.documentID)
        .collection(widget.operario.id)
        .orderBy("time", descending: false)
        .snapshots();


    stream.listen((snapshot) {
      _controller.add(snapshot);
      _fimDaConversa();
    });
  }

  _fimDaConversa(){

    Timer(Duration(milliseconds: 350), (){
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  _apagarMensagem(DocumentSnapshot dados, List<DocumentSnapshot> mensagens)async{
    await db
        .collection("Mensagens")
        .document(_dadosUsuario.documentID)
        .collection(widget.operario.id)
        .document(dados["idMensagem"])
        .delete();

    await db
        .collection("Mensagens")
        .document(widget.operario.id)
        .collection(_dadosUsuario.documentID)
        .document(dados["idMensagem"])
        .delete();

    mensagens.removeLast();

    DocumentSnapshot data = mensagens.last;






  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {
    var stream = StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
            // TODO: Handle this case.
              break;
            case ConnectionState.done:

              break;
          }


          QuerySnapshot querySnapshot = snapshot.data;
          if (snapshot.hasError) {
            return Expanded(
                child: Center(
                  child: Text("Erro ao carregar mensagens"),
                ));
          } else {
            if (snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> mensagens =
                      querySnapshot.documents.toList();
                      DocumentSnapshot mensagem = mensagens[indice];
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Colors.black12;

                      if (_dadosUsuario.documentID != mensagem["idUsuario"]) {
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }

                      return Align(
                          alignment: alinhamento,
                          child: Padding(
                              padding: EdgeInsets.all(6),
                              child: GestureDetector(
                                onLongPress: /*_dados["id"] == mensagem["idUsuario"]?(){
                                    showDialog(
                                      context: context,
                                      builder: (context){
                                        return AlertDialog(
                                          content: Text("Deseja apagar essa mensagem?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancelar")
                                              ),
                                            FlatButton(
                                              onPressed: (){
                                                _apagarMensagem(mensagem, mensagens);
                                              },
                                              child: Text("Confirmar")
                                              ),
                                          ],
                                        );
                                      }
                                    );
                                  }:*/null,
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.8,
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cor,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    mensagem["mensagem"],
                                    style: TextStyle(fontSize: 16),

                                  ),
                                ),
                              )
                          ));
                    }),
              );
            } else {
              return Expanded(
                  child: Center(
                    child: Text("Seja o primeiro a enviar uma mensagem"),
                  ));
            }
          }

        });

    var caixaTexto = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                  onTap: (){
                    _fimDaConversa();
                  },
                  controller: _mensagemController,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(0.0),
                      ),
                      hintText: "Digite aqui...",
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          )))),
            ),
          ),
          FloatingActionButton(
            onPressed: () => _enviarMensagem(),
            backgroundColor: Cores().corButton(),
            child: Icon(
              Icons.send,
              color: Cores().corIcons(),
            ),
            mini: true,
          )
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.operario.nome),
        ),
        body: Container(
          child: SafeArea(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[stream, caixaTexto],
                ),
              )),
        ));
  }
}
