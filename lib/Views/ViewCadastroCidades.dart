import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Entity/Cidade.dart';
import 'package:bico/Entity/Cliente.dart';
import 'package:bico/Views/ViewEscolhaPerfil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:via_cep_search/via_cep_search.dart';

class ViewCadastroCidades extends StatefulWidget {
  @override
  _ViewCadastroCidadesState createState() => _ViewCadastroCidadesState();
}

class _ViewCadastroCidadesState extends State<ViewCadastroCidades> {
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerCidade1 = TextEditingController();
  TextEditingController _controllerCidade2 = TextEditingController();
  String _uf1;
  String _uf2;
  List<Map<String,dynamic>> _cidades = List();
  ControllerUsuario _controllerUsuario = ControllerUsuario();

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
            title: Text("Digite o CEP de sua cidade"),
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

  _cadastrarCidade()async{
    if(_controllerCidade1.text.isNotEmpty){
      if(_controllerCidade2.text.isEmpty){
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
      }else{
        Cidade cidade = Cidade();
        cidade.nome = _controllerCidade1.text;
        cidade.uf = _uf1;
        _cidades.add(cidade.toMap());
        cidade.nome = _controllerCidade2.text;
        cidade.uf = _uf2;
        _cidades.add(cidade.toMap());
      }

      DocumentSnapshot ds = await _controllerUsuario.recuperarUsuarioLogado();

      Cliente cliente = Cliente();

      

      cliente.nome = ds.data["nome"];
      cliente.telefone = ds.data["telefone"];
      cliente.cidade = _cidades;
      cliente.email = ds.data["email"];
      cliente.senha = ds.data["senha"];
      cliente.tipoPerfil = ds.data["tipoPerfil"];
      //cliente.tipoPerfil = "cliente";
      cliente.imagem = ds.data["imagem"];

      print(cliente.cidade);

      
     await _controllerUsuario.atualizarClienteLogado(cliente);
      
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewEscolhaPerfil()));
      _cidades.clear();
    }else{
       Fluttertoast.showToast(
                          msg: "Pelomenos a cidade 1 deve ser cadastrada",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          gravity: ToastGravity.CENTER);
    }
  }

  _iniciarBanco()async{
    
  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(padding: EdgeInsets.only(bottom: 24),
            child:  Center(child: Text(
              "Cadastrar Cidades",
              style: TextStyle(fontSize: 24),
            ),)),

            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: TextField(
                readOnly: true,
                onTap: () {
                  _digitarCep(context, "1");
                },

                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,

                controller: _controllerCidade1,
                keyboardType: TextInputType.text,
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
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
              child: TextField(
                readOnly: true,
                onTap: () {
                  _digitarCep(context, "2");
                },

                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,

                controller: _controllerCidade2,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Cidade 2",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.only(left: 16, top: 32),
                    prefixIcon: Icon(Icons.location_city),
                    suffixIcon: IconButton(icon: Icon(Icons.delete,), onPressed: (){
                      if(_controllerCidade2 != null){
                      setState(() {
                      _controllerCidade2.clear();
                      _uf2 = null;
                      });
                      }
                    },)),
                    
                showCursor: false,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24),
              child: RaisedButton(onPressed: (){
                _cadastrarCidade();
              }, child: Text("Confirmar"),),
            )
          ],
        ),
      ),
    );
  }
}
