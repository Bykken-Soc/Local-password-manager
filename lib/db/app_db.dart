import 'package:flutter/material.dart' hide Table;
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart'; 

part 'app_db.g.dart';

class Dbpassword extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userkey => text()();
  TextColumn get password => text().withLength()();
  TextColumn get site => text()();
  TextColumn get Category => text()();
}

@DriftDatabase(tables:[Dbpassword])
class AppDatabase extends _$AppDatabase{

AppDatabase() : super(_abrirconexion());

@override
  // TODO: implement schemaVersion
  int get schemaVersion => 1;
Future<int> savepassword(DbpasswordCompanion newpassword){
  return into(dbpassword).insert(newpassword);
}

Future<bool> updatepassword(DbpasswordData password){
  return update(dbpassword).replace(password);
}
Stream<List<DbpasswordData>> readpasswords(){
  return select(dbpassword).watch();
}

Stream<List<DbpasswordData>> categorypassword(String category){
return (select(dbpassword)..where((tbl) => tbl.Category.equals(category))).watch();
}
Future<int> deletepassword(int id){
  return (delete(dbpassword)..where((tbl) => tbl.id.equals(id))).go();
}
  
}


QueryExecutor _abrirconexion() {

return driftDatabase(name: 'mi_base_de_datos2');

}

