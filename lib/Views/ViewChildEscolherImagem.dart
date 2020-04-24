import 'dart:async';
import 'dart:io';


import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Views/ViewMain.dart';
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
  ControllerUsuario _controllerUsuario = ControllerUsuario();

  _pegarImagemCamera() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(imagemSelecionada != null){
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
  }

  _pegarImagemGaleria() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(imagemSelecionada != null){
      setState(() {
      _file = imagemSelecionada;
      _load = true;
    });
    Timer(Duration(milliseconds: 500),(){
      setState(() {
        _load = false;
      });
    });
    }
  }

  

  _confirmando()async{
   
    if(_file == null){
      
    }else{
      if(await _controllerUsuario.uploadImage(_file)){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);  
      }

      
    }
  }


  _removerImagem(){
    setState(() {
      _file = null;
    });
  }

  @override
  void initState() {
    super.initState();
    
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
                          color: Cores().corButton(),
                          child: Text(
                            "Câmera",
                          )),
                      FlatButton(
                          onPressed: () {
                            _pegarImagemGaleria();
                          },
                          textColor: Cores().corText(),
                          color: Cores().corButton(),
                          child: Text(
                            "Galeria",
                          ))
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: _file == null ? null : RaisedButton(
                    child: Text(
                      "Remover imagem",
                    ),
                    onPressed: () {
                      _removerImagem();
                    },
                    textColor: Cores().corText(),
                    color: Cores().corButton(),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    child: Text(
                      "Confirmar",
                    ),
                    onPressed: _file == null ? null : () {
                      pr = ProgressDialog(context);
                      pr.style(
                        message: "Carregando...",
                      );
                      pr.show();
                      _confirmando();
                    },
                    textColor: Cores().corText(),
                    color: Cores().corButton(),
                  ),
                ),

               /* Padding(
                  padding: EdgeInsets.only(top: 10, right: 16, left: 16),
                  child: _file == null ? Text(
                    "Se pular esta etapa, não se preocupe. Você pode colocar imagem no perfil quando quiser.",
                    textAlign: TextAlign.justify,
                  ) : null,
                )*/
              ],
            ),
          )),
    );
  }
}
