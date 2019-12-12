import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:sms/sms.dart";
import 'package:file_picker/file_picker.dart';

import './recipients.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController number = TextEditingController();
  TextEditingController messageEntered = TextEditingController();

  List<String> recipients = [];

  createAlertDialog(BuildContext context, String ttl, String msg) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: <Widget>[
              RaisedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  void _sendSMS() {
    if (messageEntered.text.isEmpty || recipients.length == 0) {
      createAlertDialog(
          context, 'Error', 'Message or Recipients List can\'t be empty.');
      return;
    }
    for (var i = 0; i < recipients.length; i++) {
      SmsSender sender = new SmsSender();
      String address = recipients[i];

      SmsMessage message = new SmsMessage(address, messageEntered.text);
      sender.sendSms(message);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });
    }

    setState(() {
      number = TextEditingController();
      messageEntered = TextEditingController();
      recipients = [];
    });
    createAlertDialog(context, 'Success', 'The messages have been delivered.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("SMS App"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            child: Text(
              "Recipients",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          recipients.isEmpty ? Text('') : RecipientsList(recipients),
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.82,
                padding: EdgeInsets.all(20),
                child: TextField(
                  onSubmitted: (_) {
                    if (number.text.isNotEmpty) {
                      setState(() {
                        recipients.add(number.text);
                        number = TextEditingController();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2)),
                    labelText: "Contact Number",
                  ),
                  controller: number,
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (number.text.isNotEmpty) {
                    setState(() {
                      recipients.add(number.text);
                      number = TextEditingController();
                    });
                  }
                },
              )
            ],
          ),
          Container(
            margin: MediaQuery.of(context).viewInsets,
            padding: EdgeInsets.all(20),
            child: TextField(
              maxLines: 5,
              onSubmitted: (_) => _sendSMS(),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide(width: 2)),
                labelText: "Message",
              ),
              controller: messageEntered,
            ),
          ),
          RaisedButton(
            child: Text("Send"),
            onPressed: _sendSMS,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          File file = await FilePicker.getFile();
          final input = file.openRead();
          final fields = await input
              .transform(utf8.decoder)
              .transform(new CsvToListConverter())
              .toList();
          for (var i = 0; i < fields.length; i++) {
            recipients.add(fields[i][0].toString());
          }
          setState(() {});
        },
      ),
    );
  }
}
