import 'dart:async';
import 'package:bico/Connection/Banco.dart';
import 'package:bico/Cores/Cores.dart';
import 'package:bico/Views/ViewChildEscolherImagem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';



class ViewEscolhaPerfil extends StatefulWidget {
  @override
  _ViewEscolhaPerfilState createState() => _ViewEscolhaPerfilState();
}

class _ViewEscolhaPerfilState extends State<ViewEscolhaPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Escolha o seu tipo de Perfil",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: (MediaQuery.of(context).size.width / 2) - 1,
                      child: Hero(
                          tag: "EscolhendoPerfil1",
                          child: GestureDetector(
                            onTap: () {
                              bool operario = true;
                              String descricao =
                                  "Este perfil é para operários em geral como: Pedreiros, pintores, eletricistas, operadores de roçadeira, ferragistas e as demais profissões relacionadas que estão querendo fechar negócios";
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => EscolhendoPerfil(
                                          "EscolhendoPerfil1",
                                          "images/PerfilOperario.png",
                                          descricao,
                                          operario)));
                            },
                            child: Card(
                                color: Colors.grey,
                                child: Center(
                                    child: Image.asset("images/PerfilOperario.png"))),
                          )),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: (MediaQuery.of(context).size.width / 2) - 1,
                      child: Hero(
                          tag: "EscolhendoPerfil2",
                          child: GestureDetector(
                            onTap: () {
                              bool operario = false;
                              String descricao =
                                  "Este perfil é para clientes que estão à procura de serviços fornecidos por operários afim de fechar negócios";
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      transitionDuration: Duration(milliseconds: 900),
                                      pageBuilder: (_, __, ___) => EscolhendoPerfil(
                                          "EscolhendoPerfil2",
                                          "images/PerfilCliente.png",
                                          descricao,
                                          operario)));
                            },
                            child: Card(
                                color: Colors.grey,
                                child: Center(
                                    child: Image.asset("images/PerfilCliente.png"))),
                          )),
                    ),
                  ],
                ),
              ],
            )));
  }
}

class EscolhendoPerfil extends StatefulWidget {
  @override
  _EscolhendoPerfilState createState() => _EscolhendoPerfilState();
  String tag;
  String imagem;
  String descricao;
  bool operario = false;
  EscolhendoPerfil(this.tag, this.imagem, this.descricao, this.operario);
}

class _EscolhendoPerfilState extends State<EscolhendoPerfil> {
  bool _tempo = false;
  TextEditingController _controllerTipo = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Database banco;

  _iniciarBanco()async{
    banco = await Banco().getBanco();
  }

  _escolherPerfil() async {
    String sql = "select id from Usuario";
    List<dynamic> listDados = await banco.rawQuery(sql);
    var dados = listDados[0];

    if (widget.tag.contains("1")) {
      print(_controllerTipo.text);
      if(_controllerTipo.text.isEmpty){
        Fluttertoast.showToast(
            msg: "O campo tipo de operário não pode ficar vazio!",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER
        );
      }else{

        print(dados["id"]);
        Map<String, dynamic> dadosUpdate ={
          "tipoPerfil" : "operario",
          "tipoOperario" : _controllerTipo.text
        };

        banco.update(
            "Usuario",
            dadosUpdate,
            where: "id = ?",
            whereArgs: [dados["id"]]
        );


        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ViewEscolherImagem()));
      }
    } else {


      Map<String, dynamic> dadosUpdate ={
        "tipoPerfil" : "cliente",
      };

      banco.update(
          "Usuario",
          dadosUpdate,
          where: "id = ?",
          whereArgs: [dados["id"]]
      );

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ViewEscolherImagem()));
    }
  }

  @override
  void initState() {
    super.initState();
    _iniciarBanco();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      if(this.mounted){
        setState(() {
        _tempo = true;
      });
      }
    });
    return Scaffold(
      body: Hero(
          tag: widget.tag,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.grey,
                expandedHeight: (MediaQuery.of(context).size.height / 4) ,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(widget.imagem),
                ),
              ),
              SliverFillRemaining(
                child: _tempo
                    ? SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 16, 10, 24),
                        child: Text(
                          widget.descricao,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.justify,
                        ),
                      ),

                      widget.operario ? Padding(
                        padding: EdgeInsets.only(left: 24, top:20),
                        child: Text("Digite o tipo de operário que você é. Ex: Pedreiro"),
                      ) : Text(""),

                      widget.operario ? Padding(
                        padding: EdgeInsets.only(
                            left: 16,  right: 16, bottom: 8),
                        child: TextField(
                          onTap: (){
                            _scrollController.jumpTo(MediaQuery.of(context).size.height);
                          },
                          keyboardType: TextInputType.text,
                          controller: _controllerTipo,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              labelText: "Tipo de Operário",
                              border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.pink),
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding:
                              EdgeInsets.only(left: 16, top: 32),
                              prefixIcon: Icon(Icons.person)),
                          showCursor: false,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ) : Text(""),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: RaisedButton(
                          onPressed: () {
                            _escolherPerfil();
                          },
                          color: Cores().corButton(),
                          child: Text(
                            "Avançar",
                          ),
                          textColor: Cores().corText(),
                        ),
                      )
                    ],
                  ),
                )
                    : Text(""),
              ),
            ],
          )),
    );
  }
}
