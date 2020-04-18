import 'dart:async';


import 'package:bico/Connection/Banco.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewChilds/ViewChildConversa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ViewChildConversas extends StatefulWidget {
  @override
  _ViewChildConversasState createState() => _ViewChildConversasState();
}

class _ViewChildConversasState extends State<ViewChildConversas> {
  var _dados;
  Firestore db = Firestore.instance;
  final _controller = StreamController<QuerySnapshot>.broadcast();

  _iniciarBanco() async {
    Database banco = await Banco().getBanco();
    String sql = "SELECT * FROM Usuario";
    List dado = await banco.rawQuery(sql);
    setState(() {
      _dados = dado[0];
    });

    _adicionarListenerConversa();
  }

  Stream<QuerySnapshot> _adicionarListenerConversa() {
    final stream = db
        .collection("Conversas")
        .document(_dados["id"])
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((snapshot) {
      _controller.add(snapshot);
      Timer(Duration(milliseconds: 500), () {

      });
    });
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
              return Expanded(child: Center(
                child: CircularProgressIndicator(),
              ));
              break;
            case ConnectionState.active:
            // TODO: Handle this case.
              break;
            case ConnectionState.done:
              break;
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar conversas"));
          } else {
            QuerySnapshot querySnapshot = snapshot.data;
            if (querySnapshot.documents.length == 0) {
              return Expanded(child: Center(
                child: Text("Nenhuma conversa iniciada"),
              ));
            }

            return Expanded(child: ListView.builder(
                itemCount: querySnapshot.documents.length,
                itemBuilder: (context, indice) {
                  List<DocumentSnapshot> conversas = querySnapshot.documents.toList();
                  DocumentSnapshot conversa = conversas[indice];

                  return Card(
                    child: ListTile(
                      onTap: () {
                        Operario op = Operario();
                        op.id = conversa.data["idDestinatario"];
                        op.nome = conversa.data["nome"];
                        op.imagemPerfil = conversa.data["imagem"];
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewChildConversa(op)));
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(conversa.data["imagem"]),
                      ),
                      title: Text(
                        conversa.data["nome"],
                        style: TextStyle(fontSize: 14),
                      ),

                      subtitle: Text(
                        conversa.data["mensagem"],
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }));
          }
        });

    return Scaffold(
      body: Column(
        children: <Widget>[
          stream,
        ],
      ),
    );
  }
}
