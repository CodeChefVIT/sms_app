import 'package:flutter/material.dart';

class RecipientsList extends StatelessWidget {
  final List<String> recipients;

  RecipientsList(this.recipients);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      child: Center(
        child: recipients.length > 0
            ? ListView.builder(
                itemBuilder: (ctx, index) {
                  return Center(child: Text('${recipients[index]}'));
                },
                itemCount: recipients.length,
              )
            : Text('No Recipients Added Yet'),
      ),
    );
  }
}
