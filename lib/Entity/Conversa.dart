import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa{
  String _idRemetente;
  String _idDestinatario;
  String _nome;
  String _mensagem;
  String _imagem;

  Conversa();

  salvar()async{
    Firestore db = Firestore.instance;
    await db.collection("Conversas").document(this.idRemetente).collection("ultima_conversa").document(this.idDestinatario).setData(this.toMap());
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idRemetente" : this.idRemetente,
      "idDestinatario" : this.idDestinatario,
      "nome" : this.nome,
      "mensagem" : this.mensagem,
      "imagem" : this.imagem
    };
    return map;
  }

  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }
  String get idDestinatario => _idDestinatario;

  set idDestinatario(String value) {
    _idDestinatario = value;
  }
  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }
  String get imagem => _imagem;

  set imagem(String value) {
    _imagem = value;
  }
}