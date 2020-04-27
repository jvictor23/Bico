import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Entity/Cidade.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewChilds/ViewChildConversas.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfil.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfilOperario.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewMain extends StatefulWidget {
  @override
  _ViewMainState createState() => _ViewMainState();
}

class _ViewMainState extends State<ViewMain> {

  ControllerUsuario _controllerUsuario = ControllerUsuario();
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: _controllerUsuario.recuperarUsuarioLogado(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.waiting:
                    return DrawerHeader(
                        child: Center(
                      child: CircularProgressIndicator(),
                    ));
                    break;
                  case ConnectionState.active:
                    // TODO: Handle this case.
                    break;
                  case ConnectionState.done:
                    List<Map<String, dynamic>> listCidade = List();
                    for (var city in snapshot.data["cidade"]) {
                      Cidade cidade = Cidade();
                      cidade.nome = city["nome"];
                      cidade.uf = city["uf"];
                      listCidade.add(cidade.toMap());
                    }
                    return UserAccountsDrawerHeader(
                        accountName: Text(snapshot.data["nome"]),
                        currentAccountPicture: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data["imagem"]),
                              backgroundColor: Colors.grey,
                              radius: 50,
                            ),
                            Positioned(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.settings,
                                    size: 20,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    print("Eae");
                                  }),
                              left: 40,
                              bottom: 40,
                            )
                          ],
                        ),
                        accountEmail: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: listCidade.length == 1
                                ? <Widget>[
                                    Text(listCidade.first["nome"]),
                                  ]
                                : <Widget>[
                                    Text(listCidade.first["nome"]),
                                    Text(listCidade.last["nome"]),
                                  ]));
                    break;
                }
              },
            ),
            ListTile(
                leading: Icon(
                  Icons.file_upload,
                  size: 45,
                ),
                title: Text("Realizar Publicação"),
                subtitle: Text("Faça uma publicação"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  debugPrint('toquei no drawer');
                }),
            ListTile(
                leading: Icon(
                  Icons.image,
                  size: 45,
                ),
                title: Text("Minhas Publicações"),
                subtitle: Text("Veja suas publicações aqui"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  debugPrint('toquei no drawer');
                }),
            SizedBox(
              height: 200,
            ),
            ListTile(
                leading: Icon(
                  Icons.arrow_back,
                ),
                title: Text("Sair"),
                onTap: () {
                  debugPrint('toquei no drawer');
                }),
          ],
        ),
      ),
      appBar: AppBar(
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ViewChildConversas()));
                  },
                ))
          ],
          title: Align(
            alignment: Alignment.center,
            child: Image.asset(
              "images/Bico.png",
              width: 100,
            ),
          )),
      body: SafeArea(
        child: FutureBuilder<List<Operario>>(
            future: _controllerUsuario.recuperarOperarios(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                
                  if(snapshot.data.length == 0){
                    return Center(child: Text("Nenhum dado encontrado!"),);                    
                  }else{

                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List<Operario> listaItens = snapshot.data;
                        Operario operario = listaItens[index];
                        
                        return GestureDetector(
                          onTap: () async{

                            if( await _controllerUsuario.recuperarIdUsuarioLogado() == operario.id ){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewChildPerfil(true)));
                            }else{
                              Operario op = Operario();
                              op.nome = operario.nome;
                              op.telefone = operario.telefone;
                             // op.cidade = operario.cidade;
                              op.tipo = operario.tipo;
                              op.imagem = operario.imagem;
                              op.id = operario.id;
                              op.email = operario.email;
                              op.senha = operario.senha;
                              op.estrelas = operario.estrelas;
                              op.tipoPerfil = operario.tipoPerfil;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewChildPerfilOperario(operario)));
                            }

                          },
                          child: Card(
                            elevation: 10,
                              child: Container(
                                height: 190,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 60,
                                              backgroundColor: Colors.transparent,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(12),
                                                child: CachedNetworkImage(
                                                  imageUrl: operario.imagem == null? "https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633249_960_720.png" : operario.imagem,
                                                  filterQuality:
                                                  FilterQuality.medium,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child:
                                                          CircularProgressIndicator(
                                                            backgroundColor: Colors.black,
                                                          )),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  operario.nome,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  operario.telefone,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                                Text(
                                                  operario.cidade.first["nome"],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),

                                               operario.cidade.length > 1 ? Text(
                                                  operario.cidade.last["nome"],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ) : Padding(padding: EdgeInsets.all(0)),
                                                Text(
                                                  operario.tipo,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                    RatingBar(

                                      initialRating: operario.estrelas == null
                                          ? 0
                                          : operario.estrelas,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 30,
                                      itemBuilder: (context, _) => Icon(Icons.star),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text("Avaliação Geral"),
                                    )
                                  ],
                                ),
                              )),
                        );
                      });
                  }

                  break;
              }
            }),
      ),
    );
  }
}
