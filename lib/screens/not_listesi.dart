import 'package:flutter/material.dart';
import 'package:notlar/constructors/kategoriEkle.dart';
import 'package:notlar/constructors/navigationService.dart';
import 'package:notlar/screens/notlariGetir.dart';

class NoteList extends StatelessWidget {
  NoteList({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(actions: [
        PopupMenuButton(itemBuilder: (context) {
          return [
             PopupMenuItem(
                child: ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Kategori'),
                  enabled: true,
                  onTap: (){
                    Navigator.pop(context);
                    NavigationService.kategoriSayfasinaGit(context);
                  },
                ),
            ),
          ];
        })
      ], title: const Text('Not Listesi'), centerTitle: true),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => NavigationService.notDetaySayfasinaGit(context),
            tooltip: 'Not Ekle',
            heroTag: 'not',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              kategoriEkleDialog(context);
            },
            mini: true,
            heroTag: 'kategori',
            tooltip: 'Kategori Ekle',
            child: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: const NotlariGetir(),
    );
  }
}
