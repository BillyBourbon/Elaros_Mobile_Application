import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/app.dart';

void main() {
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({key? key}) : super(key: key);
  @override
  Widget build (BuildContext context) {
    return MaterialApp (
        debugShowCheckedModeBanner: false,
         profile: profilepage();
   );
  }


}