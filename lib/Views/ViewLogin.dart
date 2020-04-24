import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Entity/Cliente.dart';
import 'package:bico/Views/ViewCadastro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewLogin extends StatefulWidget {
  @override
  _ViewLoginState createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {

  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  ControllerUsuario _controllerUsuario = ControllerUsuario();
  FocusNode _focus1 = FocusNode();



  bool _loading = false;

  logarUsuario(){
    Cliente cliente = Cliente();
    cliente.email = _controllerEmail.text;
    cliente.senha = _controllerSenha.text;
    _controllerUsuario.logarUsuario(cliente, context);
  }

  verificaCampos(){


    if(_controllerEmail.text.isNotEmpty){
      if(_controllerSenha.text.isNotEmpty){
        setState(() {
          _loading = true;
        });
        logarUsuario();
      }else{
        setState(() {
          _loading = false;
        });
        Fluttertoast.showToast(
            msg: "O campo senha não pode ficar vazio!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );



      }
    }else{
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
          msg: "O campo email não pode ficar vazio!",
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
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Image.asset("images/Bico.png"),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 100, right:16, bottom: 8),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _controllerEmail,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_){
                          _focus1.nextFocus();
                        },
                        decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink),
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
                        controller: _controllerSenha,
                        obscureText: true,
                        focusNode: _focus1,
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
                      padding:EdgeInsets.fromLTRB(18, 6, 18, 12),
                      child: RaisedButton(
                        color: Cores().corButton(),
                        onPressed: (){
                          verificaCampos();
                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                              color: Cores().corText()
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCadastro())),
                      child: Center(child: Text("Cadastre-se aqui"),),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Center(
                          child: _loading? CircularProgressIndicator() : Text(
                              ""
                          )
                      ),
                    )
                  ],
                )
            )
        )
    );
  }
}