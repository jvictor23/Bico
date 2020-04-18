import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Banco {
  getBanco() async {
    final caminhaBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhaBancoDados, "cimentado.db");

    var db = await openDatabase(
      localBancoDados,
      version: 1,
    );

    return db;
  }

  closeBanco() async {
    Database db = getBanco();

    return db.close();
  }

  deleteBanco() async {
    closeBanco();
    final caminhaBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhaBancoDados, "cimentado.db");
    deleteDatabase(localBancoDados);
  }

  createBanco() async {
    final caminhaBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhaBancoDados, "cimentado.db");

    var db = await openDatabase(localBancoDados, version: 1,
        onCreate: (db, versaoRecente) {
          String sql =
              "CREATE TABLE Usuario (id VARCHAR PRIMARY KEY, nome VARCHAR, telefone VARCHAR, cidade VARCHAR, tipoPerfil VARCHAR, tipoOperario VARCHAR, imagem VARCHAR, email VARCHAR, senha VARCHAR)";
          db.execute(sql);
        });

    return db;
  }
}
