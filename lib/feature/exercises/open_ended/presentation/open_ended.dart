import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';

enum OpenEndedType { essay, feynman }

class OpenEnded extends ConsumerStatefulWidget {
  const OpenEnded({super.key, required this.nodeId});

  final String nodeId;

  @override
  ConsumerState<OpenEnded> createState() => _OpenEnded();
}

class _OpenEnded extends ConsumerState<OpenEnded> {
  String title = "";
  String statement = "";
  OpenEndedType type = OpenEndedType.essay;
  String referenceCorrectAnswer = "";

  void titleChanged(String value) {
    setState(() {
      title = value;
    });
  }

  void statementChanged(String value) {
    setState(() {
      statement = value;
    });
  }

  void typeChanged(String value) {
    setState(() {
      if (value.toLowerCase() == "feynman") {
        type = OpenEndedType.feynman;
      } else {
        type = OpenEndedType.essay;
      }
    });
  }

  void referenceCorrectAnswerChanged(String value) {
    setState(() {
      referenceCorrectAnswer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: titleChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Título",
          ),
        ),
        TextField(
          onChanged: statementChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Json do grafo",
          ),
        ),
        TextField(
          onChanged: typeChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "statement",
          ),
        ),
        TextField(
          onChanged: referenceCorrectAnswerChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "referenceCorrectAnswer",
          ),
        ),
      ],
    );
  }
}
