import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGraphWithAi extends ConsumerStatefulWidget {
  const CreateGraphWithAi({super.key});

  @override
  ConsumerState<CreateGraphWithAi> createState() => _CreateGraphWithAi();
}

class _CreateGraphWithAi extends ConsumerState<CreateGraphWithAi> {

  String userPrompt = "";

  void onUserPromptChangend(String value){
    setState(() {
      userPrompt = value;
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Column(
      children: [
        TextField(
          onChanged: onUserPromptChangend,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Descreva que você quer aprender",
          ),
        ),

        OutlinedButton(onPressed: () {

        }, child: Text(""))
      ],
    );
  }
}
