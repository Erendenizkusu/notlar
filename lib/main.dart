import 'package:flutter/material.dart';
import 'package:notlar/constructors/navigationService.dart';
import 'package:notlar/screens/not_listesi.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}

