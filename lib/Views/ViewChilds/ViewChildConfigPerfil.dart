import 'dart:io';

import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Cidade.dart';
import 'package:bico/Entity/Cliente.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewLogin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:via_cep_search/via_cep_search.dart';

class ViewChildConfigPerfil extends StatefulWidget {
  @override
  _ViewChildConfigPerfilState createState() => _ViewChildConfigPerfilState();
  BuildContext context;
  ViewChildConfigPerfil(this.context);
}

class _ViewChildConfigPerfilState extends State<ViewChildConfigPerfil> {
  bool _dadosCarregado = false;
  ControllerUsuario _controllerUsuario = ControllerUsuario();
  String _nome;
  String _telefone;
  String _tipo;
  String _imagem;
  File _img;
  DocumentSnapshot _ds;
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerCidade1 = TextEditingController();
  TextEditingController _controllerCidade2 = TextEditingController();
  String _uf1;
  String _uf2;
  List<Map<String,dynamic>> _cidades = List();
  
  var maskFormatter = new MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });
  
  _iniciarBanco() async {
    _ds = await _controllerUsuario.recuperarUsuarioLogado();
    setState(() {
      _nome = _ds.data["nome"];
      _telefone = _ds.data["telefone"];
      _tipo = _ds.data["tipo"];
      _imagem = _ds.data["imagem"];
      for(var city in _ds.data["cidade"]){
        Cidade cidade = Cidade();
        cidade.nome = city["nome"];
        cidade.uf = city["uf"];
        _cidades.add(cidade.toMap());
      }
      _controllerCidade1 = TextEditingController(text: _cidades.first["nome"]);
      _uf1 = _cidades.first["uf"];
      if(_cidades.length > 1){
        _controllerCidade2 = TextEditingController(text: _cidades.last["nome"]);
        _uf1 = _cidades.last["uf"];
      }
      _dadosCarregado = true;
    });
  }

  _pegarImagemCamera() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 75);

    setState(() {
      _img = imagemSelecionada;
    });
  }

  _pegarImagemGaleria() async {
    File imagemSelecionada;
    imagemSelecionada = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);

    setState(() {
      _img = imagemSelecionada;
    });
  }

  _verificaCondicoes() {
    print("entrou");
    if (_ds.data["tipoPerfil"] == "operario") {      
      if (_nome.isNotEmpty) {
        if (_telefone.isNotEmpty) {
          if (_controllerCidade1.text.isNotEmpty) {
            if (_tipo.isNotEmpty) {
              if (_img == null) {
                _atualizarDados();
              } else {
                _controllerUsuario.uploadImage(_img);
              }
            } else {}
          } else {}
        } else {}
      } else {}
    } else {
      if (_nome.isNotEmpty) {
        if (_telefone.isNotEmpty) {
          if (_controllerCidade1.text.isNotEmpty) {
            if (_img == null) {
              _atualizarDados();
            } else {
              _controllerUsuario.uploadImage(_img);
            }
          } else {}
        } else {}
      } else {}
    }
  }

  _atualizarDados() async{
    if (_ds.data["tipoPerfil"] == "operario") {
      
      if(_controllerCidade1.text.isNotEmpty){
      if(_controllerCidade2.text.isEmpty){
        _cidades.clear();
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
      }else{
        _cidades.clear();
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
        cidade.nome = _controllerCidade2.text;
        cidade.uf = _uf2;
        _cidades.add(cidade.toMap());
      }


      Operario operario = Operario();

          operario.nome = _nome;
          operario.telefone = _telefone;
          operario.cidade = _cidades;
          operario.email = _ds.data["email"];
          operario.senha = _ds.data["senha"];
          operario.tipoPerfil = _ds.data["tipoPerfil"];
          operario.imagem = _imagem;
          operario.tipo = _tipo;
          operario.estrelas = _ds.data["estrelas"];

      await _controllerUsuario.atualizarOperarioLogado(operario);
      Navigator.pop(context,true);

      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);

      
    }else{
       Fluttertoast.showToast(
                          msg: "Pelomenos a cidade 1 deve ser cadastrada",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
    }

      
    } else {


      if(_controllerCidade1.text.isNotEmpty){
      if(_controllerCidade2.text.isEmpty){
        _cidades.clear();
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
      }else{
        _cidades.clear();
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
        cidade.nome = _controllerCidade2.text;
        cidade.uf = _uf2;
        _cidades.add(cidade.toMap());
      }

      Cliente cliente = Cliente();
      cliente.nome = _nome;
      cliente.telefone = _telefone;
      //usuario.cidades = _controllerCidade.text;
      cliente.tipoPerfil = _ds.data["tipoPerfil"];
      cliente.email = _ds.data["email"];
      cliente.senha = _ds.data["senha"];
      cliente.imagem = _imagem;
      _controllerUsuario.atualizarClienteLogado(cliente);
      Navigator.pop(context, true);

      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewMain()), (Route<dynamic> rout) => false);

      
    }else{
       Fluttertoast.showToast(
                          msg: "Pelomenos a cidade 1 deve ser cadastrada",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
    }


      
    }
  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  _digitarCep(BuildContext context, String tf) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    if (_controllerCep.text.isNotEmpty) {
                      _mostrarCidades(context, tf);
                    } else {
                      Fluttertoast.showToast(
                          msg: "O CEP não pode ficar vazio!",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
                    }
                  },
                  child: Text("Confirmar"))
            ],
            title: Text("Digite o CEP da cidade $tf"),
            content: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controllerCep,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "CEP",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.only(left: 16, top: 32),
              ),
              showCursor: false,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          );
        });
  }

 _mostrarCidades(BuildContext context, String tf) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")),
            ],
            title: Text("Escolha a sua cidade"),
            content: FutureBuilder<ViaCepSearch>(
                future: ViaCepSearch.getInstance(_controllerCep.text),
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
                      if (snapshot.data.localidade == null) {
                        return Center(
                          child: Text(
                              "Nenhuma cidade encontrada, verifique o cep digitado e tente novamente"),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        if(tf == "1"){
                                          _controllerCidade1 =
                                            TextEditingController(
                                                text: snapshot.data.localidade);
                                        _uf1 = snapshot.data.uf;
                                        }else{
                                          _controllerCidade2 =
                                            TextEditingController(
                                                text: snapshot.data.localidade);
                                        _uf2 = snapshot.data.uf;
                                        }
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    title: Text(snapshot.data.localidade),
                                  ),
                                  snapshot.data.bairro.isEmpty
                                      ? Text("")
                                      : ListTile(
                                          onTap: () {
                                            setState(() {
                                               if(tf == "1"){
                                          _controllerCidade1 =
                                            TextEditingController(
                                                text: snapshot.data.bairro);
                                        _uf1 = snapshot.data.uf;
                                        }else{
                                          _controllerCidade2 =
                                            TextEditingController(
                                                text: snapshot.data.bairro);
                                        _uf2 = snapshot.data.uf;
                                        }
                                            });
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          title: Text(snapshot.data.bairro),
                                        )
                                ],
                              );
                            });
                      }
                      break;
                  }
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Configurar Perfil"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _verificaCondicoes();
                })
          ],
        ),
        body: _dadosCarregado ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 85,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(25)),
                        child: _img == null
                            ? CachedNetworkImage(
                          imageUrl: _ds.data["imagem"] == null ? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : _ds.data["imagem"],
                          filterQuality: FilterQuality.medium,
                          placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                              )),
                        )
                            : Image.file(_img),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _pegarImagemCamera();
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Cores().corIcons(),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            _pegarImagemGaleria();
                          },
                          
                          child: Icon(
                            Icons.image,
                            color: Cores().corIcons(),
                          ),
                        ),
                        RaisedButton(
                          onPressed: _img == null
                              ? null
                              : () {
                            setState(() {
                              _img = null;
                            });
                          },
                          child: Text("Remover"),
                          textColor: Cores().corIcons(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: TextFormField(
                  onChanged: (result) {
                    _nome = result;
                  },
                  initialValue: _nome,
                  decoration: InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.person)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextFormField(
                  onChanged: (result) {
                    _telefone = result;
                  },
                  initialValue: _telefone,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                      labelText: "Telefone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.phone)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextFormField(
                  
                  onTap: (){
                    _digitarCep(context, "1");
                  },
                  readOnly: true,
                  controller: _controllerCidade1,
                  decoration: InputDecoration(
                      labelText: "Cidade 1",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.location_city)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),



              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextFormField(
                  onTap: (){
                    _digitarCep(context, "2");
                  },
                  readOnly: true,
                  controller: _controllerCidade2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(icon: Icon(Icons.delete,), onPressed: (){
                      if(_controllerCidade2 != null){
                      setState(() {
                      _controllerCidade2.clear();
                      _uf2 = null;
                      });
                      }
                    },),
                      labelText: "Cidade 2",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.location_city)),
                  showCursor: false,
                  
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: _ds.data["tipoPerfil"] == "operario" ? TextFormField(
                  onChanged: (result) {
                    _tipo = result;
                  },
                  initialValue: _tipo,
                  decoration: InputDecoration(
                      labelText: "Tipo Operario",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.person)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ) : null,
              ),

              Padding(padding: EdgeInsets.only(top: 20, right: 16),
                child: RaisedButton(
                  onPressed: (){
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewLogin()), (Route<dynamic> rout) => false);
                  },
                  child: Text("Sair da conta"),
                  textColor: Cores().corIcons(),
                ),)
            ],
          ),
        ) : Center(child: CircularProgressIndicator(),)
            
        );
  }
}
