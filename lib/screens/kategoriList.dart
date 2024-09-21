import 'package:flutter/material.dart';
import 'package:notlar/models/kategori.dart';
import 'package:notlar/utils/database_helper.dart';

class KategoriList extends StatefulWidget {
  const KategoriList({super.key});

  @override
  State<KategoriList> createState() => _KategoriListState();
}

class _KategoriListState extends State<KategoriList> {
  late DatabaseHelper _databaseHelper;
  late List<Kategori> kategoriListesi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _databaseHelper = DatabaseHelper();
    kategoriListesi = [];
    _databaseHelper.fetchCategories().then((value) {
      setState(() {
        kategoriListesi = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kategori Listesi'),
        ),
        body: ListView.builder(
            itemCount: kategoriListesi.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.category),
                title: Text(kategoriListesi[index].kategoriBaslik),
                trailing: InkWell(
                  onTap: () {
                    _kategoriSil(kategoriListesi[index].kategoriID!);
                    setState(() {
                      kategoriListesi;
                    });
                  },
                  child: const Icon(Icons.delete),
                ),
              );
            }));
  }

  void _kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Kategori Sil'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    'Kategoriyi sildiğinizde bununla ilgili tüm notlar da silinecek. Emin Misiniz?'),
                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Vazgeç')),
                    TextButton(
                        onPressed: () {
                          _databaseHelper.kategoriSil(kategoriID).then((value){
                            if(value ==0){
                                _databaseHelper.fetchCategories().then((value){
                                  setState(() {
                                    kategoriListesi = value;
                                });
                              });
                              Navigator.pop(context);
                            }
                          });
                        }, child: const Text('Kategoriyi Sil!')),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
