import 'package:bico/Views/ViewChilds/ViewChildConversas.dart';
import 'package:bico/Views/ViewChilds/ViewChildPerfil.dart';
import 'package:bico/Views/ViewChilds/ViewChildPrincipal.dart';
import 'package:flutter/material.dart';

class ViewMain extends StatefulWidget {
  @override
  _ViewMainState createState() => _ViewMainState();
}

class _ViewMainState extends State<ViewMain> {

  int _currentIndex = 0;
  List<dynamic> lista = [
    ViewChildPrincipal(),
    ViewChildConversas(),
    ViewChildPerfil(false)
  ];


  _onTabTapped(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
          "images/Bico.png",
          width: 100,
          ),)
      ),
      body: SafeArea(
        child: lista[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Principal")
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              title: Text("Conversas")
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Perfil")
          ),
        ],
      ),
    );
  }
}

