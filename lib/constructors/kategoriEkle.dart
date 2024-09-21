import 'package:flutter/material.dart';
import 'package:notlar/models/kategori.dart';
import 'package:notlar/utils/database_helper.dart';

Future<dynamic> kategoriEkleDialog(BuildContext context) {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var formKey = GlobalKey<FormState>();
  String? yeniKategoriAdi;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text(
          'Kategori Ekle',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                onSaved: (yeniDeger) {
                  yeniKategoriAdi = yeniDeger as String;
                },
                decoration: const InputDecoration(
                  labelText: 'Kategori Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (girilenKategoriAdi) {
                  if (girilenKategoriAdi!.length < 3) {
                    return 'En az 3 karakter giriniz';
                  }
                  return null;
                },
              ),
            ),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Vazgeç'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    databaseHelper
                        .kategoriEkle(Kategori(yeniKategoriAdi!))
                        .then((kategoriID) {
                      if (kategoriID > 0) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Kategori Eklendi'),
                          duration: Duration(seconds: 1),
                        ));
                        Navigator.pop(context);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text('Kaydet'),
              ),
            ],
          )
        ],
      );
    },
  );
}