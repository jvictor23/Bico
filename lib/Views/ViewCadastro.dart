

import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  FocusNode _focus1 = FocusNode();
  FocusNode _focus2 = FocusNode();
  FocusNode _focus3 = FocusNode();
  FocusNode _focus4 = FocusNode();


  bool _loading = false;

  ControllerUsuario _controllerUsuario = ControllerUsuario();

  cadastrarUsuario(){
    Usuario usuario = Usuario();
    usuario.nome = _controllerNome.text;
    usuario.telefone = _controllerTelefone.text;
    usuario.cidade = _controllerCidade.text;
    usuario.email = _controllerEmail.text;
    usuario.senha = _controllerSenha.text;
    _controllerUsuario.cadastrarUsuario(usuario, context);
  }

  verificaCampos(){

    if(_controllerNome.text.isNotEmpty){
      if(_controllerTelefone.text.isNotEmpty){
        if(_controllerCidade.text.isNotEmpty){
          if(_controllerEmail.text.isNotEmpty){
            if(_controllerSenha.text.isNotEmpty){

              setState(() {
                _loading = true;
              });
              cadastrarUsuario();

            }else{
              Fluttertoast.showToast(
                  msg: "O campo senha não pode ficar vazio!",
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  gravity: ToastGravity.CENTER
              );
            }
          }else{
            Fluttertoast.showToast(
                msg: "O campo email não pode ficar vazio!",
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.CENTER
            );

          }
        }else{
          Fluttertoast.showToast(
              msg: "O campo cidade não pode ficar vazio!",
              toastLength: Toast.LENGTH_LONG,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.CENTER
          );

        }
      }else{
        Fluttertoast.showToast(
            msg: "O campo telefone não pode ficar vazio!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );

      }
    }else{
      Fluttertoast.showToast(
          msg: "O campo nome não pode ficar vazio!",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER
      );

    }
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
                padding: EdgeInsets.only(left: 16,  right:16, bottom: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_){
                    _focus1.nextFocus();
                  },
                  controller: _controllerNome,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.person)
                  ),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16,  right:16, bottom: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_){
                    _focus2.nextFocus();
                  },
                  focusNode: _focus1,
                  controller: _controllerTelefone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Telefone",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.phone)
                  ),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16,  right:16, bottom: 8),
                child: TextField(
                  focusNode: _focus2,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_){
                    _focus3.nextFocus();
                  },
                  controller: _controllerCidade,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Cidade",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.location_city)
                  ),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16,  right:16, bottom: 8),
                child: TextField(
                  textInputAction: TextInputAction.next,
                  focusNode: _focus3,
                  onSubmitted: (_){
                    _focus4.nextFocus();
                  },
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.alternate_email)
                  ),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 16, right:16, bottom: 16),
                child: TextField(
                  focusNode: _focus4,
                  controller: _controllerSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      contentPadding: EdgeInsets.only(left: 16, top: 32),
                      prefixIcon: Icon(Icons.lock_outline)
                  ),
                  showCursor: false,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),

              Padding(
                padding:EdgeInsets.fromLTRB(18, 6, 18, 30),
                child: RaisedButton(
                  onPressed: (){
                    verificaCampos();
                  } ,

                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                        color: Cores().corText()
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Center(
                    child: _loading ? CircularProgressIndicator() : Text(
                        ''

                    )
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}