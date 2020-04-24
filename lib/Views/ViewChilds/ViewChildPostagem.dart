import 'dart:io';

import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Postagem.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:progress_dialog/progress_dialog.dart';



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
    Postagem postagem = Postagem();
    postagem.descricao = _controllerDescricao.text;
    postagem.file = _imagemModificar;
    _controllerUsuario.uploadPostagem(postagem, context);
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
