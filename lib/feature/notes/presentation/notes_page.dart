import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget{
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context){
    return Text("Notes Page", style: Theme.of(context)
          .textTheme
          .headlineMedium,);
  }
}