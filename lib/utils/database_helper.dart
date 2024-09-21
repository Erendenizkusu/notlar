import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:notlar/models/kategori.dart';
import 'package:notlar/models/notlar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._internal();
    return _databaseHelper!;
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    _database ??= await _initializeDatabase();
    return _database!;
  }
  Future<Database> _initializeDatabase() async {

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "dbnotlar.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      debugPrint("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(url.join("assets", "notlar.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    } else {
      debugPrint("Opening existing database");
    }

// open the database
    return await openDatabase(path, readOnly: false);
  }
  Future<List<Map<String, dynamic>>> kategorileriGetir() async{
    var db = await _getDatabase();
    var sonuc = await db.query('kategori');
    return sonuc;
  }

  Future<List<Kategori>> fetchCategories() async {
    var kategoriIcerenMapListesi = await kategorileriGetir();
    List<Kategori> kategoriListesi = [];
    for (Map<String, dynamic> okunanMap in kategoriIcerenMapListesi) {
        kategoriListesi.add(Kategori.fromMap(okunanMap));
    }
    return kategoriListesi;
  }

  Future<int> kategoriEkle(Kategori kategori) async{
    var db = await _getDatabase();
    var sonuc = await db.insert('kategori', kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async{
    var db = await _getDatabase();
    var sonuc = await db.update('kategori', kategori.toMap(), where: 'kategoriID = ?',whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('kategori', where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }



  
  Future<List<Map<String, dynamic>>> notlariGetir() async{
    var db = await _getDatabase();
    var sonuc = await db.rawQuery('select * from notlar inner join kategori on kategori.kategoriID = notlar.kategoriID;');
    return sonuc;
  }

  Future<List<Notlar>> notlarListesiniGetir() async{
    var notlarMapListesi = await notlariGetir();
    List<Notlar> notListesi = [];
    for(Map<String,dynamic> map in notlarMapListesi){
      notListesi.add(Notlar.fromMap(map));
    }
    return notListesi;
  }

  Future<int> notEkle(Notlar notlar) async{
    var db = await _getDatabase();
    var sonuc = await db.insert('notlar', notlar.toMap());
    return sonuc;
  }

  Future<int> notlariGuncelle(Notlar notlar) async{
    var db = await _getDatabase();
    var sonuc = await db.update('notlar', notlar.toMap(), where: 'notID = ?',whereArgs: [notlar.notID]);
    return sonuc;
  }

  Future<int> notlariSil(int notID) async{
    var db = await _getDatabase();
    var sonuc = await db.delete('notlar', where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }

  String dateFormat(DateTime dt){
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    late String month;
    switch(dt.month){
      case 1:
        month = 'ocak';
        break;
      case 2:
        month = 'şubat';
        break;
      case 3:
        month = 'mart';
        break;
      case 4:
        month = 'nisan';
        break;
      case 5:
        month = 'mayıs';
        break;
      case 6:
        month = 'haziran';
        break;
      case 7:
        month = 'temmuz';
        break;
      case 8:
        month = 'ağustos';
        break;
      case 9:
        month = 'eylül';
        break;
      case 10:
        month = 'ekim';
        break;
      case 11:
        month = 'kasım';
        break;
      case 12:
        month = 'aralık';
        break;
    }

    Duration difference = today.difference(dt);
    if(difference.compareTo(oneDay) < 1){
      return 'bugün';
    }else if(difference.compareTo(twoDay) < 1){
      return 'dün';
    }else if(difference.compareTo(oneWeek) < 1){
      switch(dt.weekday){
        case 1:
          return 'Pazartesi';
        case 2:
          return 'Salı';
        case 3:
          return 'Çarşamba';
        case 4:
          return 'Perşembe';
        case 5:
          return 'Cuma';
        case 6:
          return 'Cumartesi';
        case 7:
          return 'Pazar';
      }
    }else if(dt.year == today.year){
          return '${dt.day} $month';
    }else{
      return '${dt.day} $month ${dt.year}';
    }
    return '';
  }

}






