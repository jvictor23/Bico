import 'package:bico/Connection/Banco.dart';
import 'package:bico/Views/ViewEscolhaPerfil.dart';
import 'package:bico/Views/ViewLogin.dart';
import 'package:bico/Views/ViewMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


ThemeData data = new ThemeData(
    primaryColor: Colors.black,
    accentColor: Colors.black,
    scaffoldBackgroundColor: Colors.grey[200]
);

void main() => runApp(MaterialApp(
  home: Home(),
  debugShowCheckedModeBanner: false,
  theme: data,
));


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  _verificaUsuarioLogado()async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    Firestore db = Firestore.instance;



    //auth.signOut();

    if(usuarioLogado == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewLogin()));
    }else{
      var dados  = await db.collection("Usuarios").document(usuarioLogado.uid).get();
      if(dados.data["tipoPerfil"] == null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewEscolhaPerfil()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewMain()));
      }

    }
  }

  @override
  void initState() {
    super.initState();
    _verificaUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}