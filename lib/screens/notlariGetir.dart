import 'package:flutter/material.dart';
import 'package:notlar/models/notlar.dart';
import 'package:notlar/utils/database_helper.dart';

import '../constructors/navigationService.dart';

class NotlariGetir extends StatefulWidget {
  const NotlariGetir({super.key});

  @override
  State<NotlariGetir> createState() => _NotlariGetirState();
}

class _NotlariGetirState extends State<NotlariGetir> {
  late List<Notlar> tumNotlar;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    tumNotlar = [];
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notlarListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Notlar>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tumNotlar = snapshot.data!;
          return ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIconuAta(tumNotlar[index].notOncelik),
                childrenPadding: const EdgeInsets.all(15),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                title: Text(tumNotlar[index].notBaslik),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Kategori: ', style: TextStyle(fontSize: 20)),
                      Text(tumNotlar[index].kategoriBaslik,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Oluşturulma Tarihi: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        databaseHelper.dateFormat(
                            DateTime.parse(tumNotlar[index].notTarih)),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.purple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'İçerik:  ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(
                          child: Text(tumNotlar[index].notIcerik,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.purple),
                              maxLines: 5)),
                    ],
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(color: Colors.black)),
                          child: TextButton(
                              onPressed: ()=> _notSil(tumNotlar[index].notID),
                              child: const Text(
                                'SİL',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ))),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(color: Colors.black)),
                          child: TextButton(
                              onPressed: () => NavigationService.notDuzenle(context,tumNotlar[index]),
                              child: const Text('GÜNCELLE',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green)))),
                    ],
                  )
                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _oncelikIconuAta(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return const CircleAvatar(
          backgroundColor: Colors.pink,
          child: Text('Az'),
        );
      case 1:
        return const CircleAvatar(
          backgroundColor: Colors.deepOrangeAccent,
          child: Text('Orta'),
        );
      case 2:
        return const CircleAvatar(
          backgroundColor: Colors.red,
          child: Text('Çok'),
        );
    }
  }

  _notSil(int? notID) {
    databaseHelper.notlariSil(notID!).then((silinenNotId){
      if(silinenNotId != 0){
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not Silindi')));
       setState(() {
       });
      }
    });
  }
}
