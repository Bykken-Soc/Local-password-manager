import 'package:drift/drift.dart' as d; 
import 'package:encrypt/encrypt.dart' as enc; 
import '../db/app_db.dart'; 
import '../models/password_model.dart';

// Handles data coordination by securely encrypting passwords before saving to Drift local storage
class PasswordRepository {
  final AppDatabase _database;

  // Cryptographic configuration setup forcing standard AES-256 (32 bytes) and IV (16 bytes) lengths
  static final _llaveCifrado = enc.Key.fromUtf8('mi_clave_secreta'.padLeft(32, '0')); 
  static final _iv = enc.IV.fromUtf8('mi_vector_iv'.padLeft(16, '0'));

  PasswordRepository(this._database);

  // Helper method to convert plaintext into an encrypted AES-256 Base64 string
  String _encriptar(String textoPlano) {
    final encrypter = enc.Encrypter(enc.AES(_llaveCifrado, mode: enc.AESMode.cbc));
    return encrypter.encrypt(textoPlano, iv: _iv).base64;
  }

  // Helper method to decrypt an AES-256 Base64 string back into original plaintext
  String desencriptar(String textoCifrado) {
    final encrypter = enc.Encrypter(enc.AES(_llaveCifrado, mode: enc.AESMode.cbc));
    return encrypter.decrypt(enc.Encrypted.fromBase64(textoCifrado), iv: _iv);
  }

  // Encrypts the password and stores it locally inside SQLite via Drift
  Future<void> guardarContrasenaCompleta(PasswordModel modelo) async {
    final passCifrada = _encriptar(modelo.contrasenaEncriptada);
    await _database.into(_database.dbpassword).insert(
      DbpasswordCompanion.insert(
        site: modelo.site,
        userkey: modelo.user,
        password: passCifrada, 
        Category: modelo.category,
      ));
  }

  // Updates an existing record with newly encrypted data in local storage
  Future<void> modificarContrasenaCompleta(int id, PasswordModel modelo) async {
    final passCifrada = _encriptar(modelo.contrasenaEncriptada);
    await (_database.update(_database.dbpassword)..where((t) => t.id.equals(id))).write(
      DbpasswordCompanion(
        site: d.Value(modelo.site),
        userkey: d.Value(modelo.user),
        password: d.Value(passCifrada), 
        Category: d.Value(modelo.category),
      ));
  }

  // Completely deletes the record from the local SQLite database
  Future<void> eliminarContrasenaCompleta(int id) async {
    await (_database.delete(_database.dbpassword)..where((t) => t.id.equals(id))).go();
  }
}