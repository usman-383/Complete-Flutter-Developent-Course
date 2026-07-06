import 'package:flutter/material.dart';
import 'Pages/home_page.dart';
import 'package:todo_app/data/dataBase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBase.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ); //Material App
  }
}
