import 'package:flutter/material.dart';
import 'package:notlar/models/notlar.dart';
import 'package:notlar/screens/kategoriList.dart';
import 'package:notlar/screens/not_listesi.dart';
import '../screens/not_detay.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void notDetaySayfasinaGit(BuildContext context) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => NotDetay(baslik: 'Not Detay')),
    );
  }
  
  static void notDuzenle(BuildContext context,Notlar not){
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => NotDetay(baslik: 'Notu Güncelle', duzenlenecekNot: not))
    );
  }

  static void notListesineGit(BuildContext context){
    navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => NoteList())
    );
  }
  static void kategoriSayfasinaGit(BuildContext context){
    navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context)=> const KategoriList()));
  }

}
