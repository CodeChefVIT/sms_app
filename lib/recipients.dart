import 'package:flutter/material.dart';

class RecipientsList extends StatefulWidget {
  final List<String> recipients;

  RecipientsList(this.recipients);

  @override
  _RecipientsListState createState() => _RecipientsListState();
}

class _RecipientsListState extends State<RecipientsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 80,
      width: double.infinity,
      child: ListView.builder(
        itemCount: widget.recipients.length,
        itemBuilder: (ctx, i) => Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.recipients.removeAt(i);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  widget.recipients[i],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
