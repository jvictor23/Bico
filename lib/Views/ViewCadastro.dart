import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:via_cep_search/via_cep_search.dart';

class ViewCadastro extends StatefulWidget {
  @override
  _ViewCadastroState createState() => _ViewCadastroState();
}

class _ViewCadastroState extends State<ViewCadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerCep = TextEditingController();
  FocusNode _focus1 = FocusNode();
  FocusNode _focus2 = FocusNode();
  FocusNode _focus3 = FocusNode();
  FocusNode _focus4 = FocusNode();
  bool _loading = false;
  var maskFormatter = new MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });

  ControllerUsuario _controllerUsuario = ControllerUsuario();

  cadastrarUsuario() {
    Usuario usuario = Usuario();
    usuario.nome = _controllerNome.text;
    usuario.telefone = _controllerTelefone.text;
    usuario.cidade = _controllerCidade.text;
    usuario.email = _controllerEmail.text;
    usuario.senha = _controllerSenha.text;
    _controllerUsuario.cadastrarUsuario(usuario, context);
  }

  verificaCampos() {
    if (_controllerNome.text.isNotEmpty) {
      if (_controllerTelefone.text.isNotEmpty) {
        if (_controllerCidade.text.isNotEmpty) {
          if (_controllerEmail.text.isNotEmpty) {
            if (_controllerSenha.text.isNotEmpty) {
              setState(() {
                _loading = true;
              });
              cadastrarUsuario();
            } else {
              Fluttertoast.showToast(
                  msg: "O campo senha não pode ficar vazio!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  gravity: ToastGravity.CENTER);
            }
          } else {
            Fluttertoast.showToast(
                msg: "O campo email não pode ficar vazio!",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.CENTER);
          }
        } else {
          Fluttertoast.showToast(
              msg: "O campo cidade não pode ficar vazio!",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.CENTER);
        }
      } else {
        Fluttertoast.showToast(
            msg: "O campo telefone não pode ficar vazio!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(
          msg: "O campo nome não pode ficar vazio!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    }
  }

  _digitarCep(BuildContext context) {
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
                      _mostrarCidades(context);
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

  _mostrarCidades(BuildContext context) {
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
                      if(snapshot.data.localidade == null){
                        return Center(child: Text("Nenhuma cidade encontrada, verifique o cep digitado e tente novamente"),);
                      }else{
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  onTap: () {
                                    setState(() {
                                      _controllerCidade = TextEditingController(
                                          text: snapshot.data.localidade);
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  title: Text(snapshot.data.localidade),
                                ),
                                snapshot.data.bairro.isEmpty ? Text("") : ListTile(
                                  onTap: () {
                                    setState(() {
                                      _controllerCidade = TextEditingController(
                                          text: snapshot.data.bairro);
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
        title: Text("Cadastro"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(""),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) {
                    _focus1.nextFocus();
                  },
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
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
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    _focus2.nextFocus();
                  },
                  focusNode: _focus1,
                  controller: _controllerTelefone,
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.number,
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
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    _digitarCep(context);
                  },
                  focusNode: _focus2,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) {
                    _focus3.nextFocus();
                  },
                  controller: _controllerCidade,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Cidade",
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
                  textInputAction: TextInputAction.next,
                  focusNode: _focus3,
                  onSubmitted: (_) {
                    _focus4.nextFocus();
                  },
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.alternate_email)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextField(
                  focusNode: _focus4,
                  controller: _controllerSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.lock_outline)),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 6, 18, 30),
                child: RaisedButton(
                  onPressed: () {
                    verificaCampos();
                  },
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(color: Cores().corText()),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Center(
                    child: _loading ? CircularProgressIndicator() : Text('')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
