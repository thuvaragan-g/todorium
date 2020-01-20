import 'package:flutter/material.dart';
import 'package:testrs/Test.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp (theme: ThemeData(fontFamily: 'Product Sans',), home: Test());
  }
}