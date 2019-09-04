import 'package:flutter/material.dart';

class RecipientsList extends StatelessWidget {
  final List<String> recipients;

  RecipientsList(this.recipients);

  @override
  Widget build(BuildContext context) {
    return Column(children: recipients.map((number) {
      return Text("$number");
    }).toList(),);
  }
}