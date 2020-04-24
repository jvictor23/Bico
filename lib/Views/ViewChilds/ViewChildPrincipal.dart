import 'package:bico/Controller/ControllerUsuario.dart';
import 'package:bico/Entity/Operario.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfil.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfilOperario.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class ViewChildPrincipal extends StatefulWidget {
  @override
  _ViewChildPrincipalState createState() => _ViewChildPrincipalState();
}

class _ViewChildPrincipalState extends State<ViewChildPrincipal> {

  ControllerUsuario _controllerUsuario = ControllerUsuario();
  String _idUsuarioLogado;

  _recuperarIdUsuarioLogado()async{
    _idUsuarioLogado = await _controllerUsuario.recuperarIdUsuarioLogado();
  }

  @override
  void initState() {
    super.initState();
    _recuperarIdUsuarioLogado();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Operario>>(
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
                          onTap: () {

                            if(_idUsuarioLogado == operario.id ){
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
            }));
  }
}
