import 'package:flutter/material.dart';
import 'package:notlar/constructors/navigationService.dart';
import 'package:notlar/models/kategori.dart';
import 'package:notlar/models/notlar.dart';
import 'package:notlar/utils/database_helper.dart';

// ignore: must_be_immutable
class NotDetay extends StatefulWidget {
  final String baslik;
  Notlar? duzenlenecekNot;

  NotDetay({super.key, required this.baslik, this.duzenlenecekNot});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler = [];
  late Future<List<Kategori>> kategorilerFuture;
  late DatabaseHelper databaseHelper;
  late int kategoriID;
  late String notBaslik, notIcerik;
  late int oncelik;
  static final _oncelik = ['Düşük', 'Orta', 'Yüksek'];

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
    if(widget.duzenlenecekNot != null){
      kategoriID = widget.duzenlenecekNot!.kategoriID;
      oncelik = widget.duzenlenecekNot!.notOncelik;
    }else{
      kategoriID = 1;
      oncelik = 0;
    }
    kategorilerFuture = kategorileriGetir();
  }

  Future<List<Kategori>> kategorileriGetir() async {
    await databaseHelper
        .kategorileriGetir()
        .then((kategorileriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategorileriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
    });
    return tumKategoriler;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: FutureBuilder<List<Kategori>>(
        future: kategorilerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while waiting for the data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been successfully fetched, build your UI
            List<Kategori> tumKategoriler = snapshot.data ?? [];
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Kategori seç: '),
                        DropdownButton(
                          items: tumKategoriler
                              .map((kategori) => DropdownMenuItem(
                                  value: kategori.kategoriID,
                                  child: Text(
                                    kategori.kategoriBaslik,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                    ),
                                  )))
                              .toList(),
                          onChanged: (secilenKategoriId) {
                            setState(() {
                              kategoriID = secilenKategoriId!;
                            });
                          },
                          value: kategoriID,
                        ),
                      ]),
                  TextFormField(
                    initialValue: widget.duzenlenecekNot != null  ? widget.duzenlenecekNot!.notBaslik : '',
                    validator: (text) {
                      if (text!.length < 3) {
                        return 'En az 3 karakter olmalı.';
                      }
                      return null;
                    },
                    onSaved: (text) {
                      notBaslik = text!;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Not baslığını giriniz',
                      labelText: 'Başlık',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: widget.duzenlenecekNot != null ? widget.duzenlenecekNot!.notIcerik : '',
                    onSaved: (text) {
                      notIcerik = text!;
                    },
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Not İçeriğini giriniz',
                      labelText: 'İçerik',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Öncelik: '),
                      DropdownButton(
                          items: _oncelik.map((oncelik) {
                            return DropdownMenuItem<int>(
                              value: _oncelik.indexOf(oncelik),
                              child: Text(
                                oncelik,
                                style: const TextStyle(fontSize: 20),
                              ),
                            );
                          }).toList(),
                          value: oncelik,
                          onChanged: (secilenOncelik) {
                            setState(() {
                              oncelik = secilenOncelik!;
                            });
                          })
                    ],
                  ),
                  const SizedBox(height: 20),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OutlinedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Vazgeç',
                            style: TextStyle(color: Colors.white),
                          )),
                      OutlinedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green)),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              var suan = DateTime.now();
                              if(widget.duzenlenecekNot == null){
                                databaseHelper
                                    .notEkle(Notlar(kategoriID, notBaslik,
                                    notIcerik, suan.toString(), oncelik))
                                    .then((kaydedilenNotID) {
                                  if (kaydedilenNotID != 0) {
                                    NavigationService.notListesineGit(context);
                                  }
                                });
                              }else{
                                databaseHelper.notlariGuncelle(Notlar.withID(widget.duzenlenecekNot!.notID,kategoriID, notBaslik,
                                    notIcerik, suan.toString(), oncelik)).then((guncellenenNotID){
                                      if(guncellenenNotID != 0){
                                        NavigationService.notListesineGit(context);
                                      }
                                });
                              }
                            }
                          },
                          child: const Text(
                            'Kaydet',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ]),
              ),
            );
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBaslik,
              style: const TextStyle(
                color: Colors.black, // Metin rengi
                fontSize: 16.0, // Metin boyutu
              ),
            )))
        .toList();
  }
}
