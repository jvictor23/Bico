import 'dart:io';


import 'package:bico/Connection/Banco.dart';
import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:bico/Views/ViewMain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';


class ViewChildPostagem extends StatefulWidget {
  @override
  _ViewChildPostagemState createState() => _ViewChildPostagemState();
  File file;
  ViewChildPostagem(this.file);
}

class _ViewChildPostagemState extends State<ViewChildPostagem> {
  File _imagemModificar;
  ControllerUsuario _controllerUsuario = ControllerUsuario();
  TextEditingController _controllerDescricao = TextEditingController();
  ProgressDialog pr;

  _configImage()async{
    print("Entrou");
    _imagemModificar = widget.file;
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imagemModificar.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: "Editor",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false
        ),
        iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0
        )
    );

    if(croppedFile != null){
      setState(() {
        _imagemModificar = croppedFile;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    _imagemModificar = widget.file;
  }

  _confirmarPostagem(var context)async{
    Database banco = await Banco().getBanco();
    List<dynamic> lista = await banco.rawQuery("select id from Usuario");
    var dado = lista[0];
    Postagem postagem = Postagem();
    postagem.idUser = dado["id"];
    postagem.descricao = _controllerDescricao.text;
    _uploadImage(postagem, context);
  }


  _uploadImage(Postagem postagem, context){
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz.child("Postagem").child(postagem.idUser).child("cimentado"+postagem.idUser+Timestamp.now().toString()+".JPEG");
    StorageUploadTask task = arquivo.putFile(_imagemModificar);

    task.onComplete.then((StorageTaskSnapshot snapshot){

      _recuperarUrlImagem(snapshot,postagem, context);

    });

  }

  _recuperarUrlImagem(StorageTaskSnapshot snapshot, Postagem postagem, var context)async{
    String url = await snapshot.ref.getDownloadURL();
    postagem.imagem = url;

    _salvarPostagem(postagem, context);

  }

  _salvarPostagem(Postagem postagem, context){
    Firestore db = Firestore.instance;
    db.collection("Postagem").document(postagem.idUser).collection(postagem.idUser).add(postagem.toMap());
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                
                icon: Icon(Icons.check),
                onPressed: (){
                  pr = ProgressDialog(context);
                  pr.style(
                    message: "Aguarde...",
                  );
                  pr.show();
                  _confirmarPostagem(context);
                }
            )
          ],
        ),
        body: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 10,
                      decoration:
                      BoxDecoration(border: Border.all()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.file(
                            _imagemModificar,
                            fit: BoxFit.cover,
                            height: MediaQuery.of(context).size.height / 2 - 10,
                            width: MediaQuery.of(context).size.width,
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.settings,
                                color: Cores().corIcons(),
                              ),
                              color: Colors.white,
                              splashColor: Colors.transparent,
                              onPressed: () => _configImage()
                          )
                        ],
                      ),
                    ),
                  )),

              Padding(
                  padding: EdgeInsets.only(left: 20,top: 50, right: 20),
                  child: TextField(
                    controller: _controllerDescricao,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        labelText: "Digite algo sobre essa imagem"
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}
