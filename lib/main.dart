import "package:flutter/material.dart";
import "package:sms/sms.dart";
// import 'package:flutter_sms/flutter_sms.dart';

import './recipients.dart';
// import 'package:sms/contact.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final number = TextEditingController();
  final messageEntered = TextEditingController();

  List<String> recipients = [];

  void sendSMS() {
    // ContactQuery contacts = ContactQuery();
    // var contact = new Contact(number.text);
    print(number.text);
    print(messageEntered.text);

    SmsSender sender = new SmsSender();
    String address = number.text;

    // sender.sendSms(new SmsMessage(address, messageEntered.text));

    SmsMessage message = new SmsMessage(address, messageEntered.text);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }

  // void _sendSMS(String message, List<String> recipents) async {
  //   String _result =
  //       await FlutterSms.sendSMS(message: message, recipients: recipents)
  //           .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SMS App"),
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
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
            RecipientsList(recipients),
            Row(
              children: <Widget>[
                Container(
                  width: 330,
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    // onSubmitted: (_) {
                    //   recipients.add(number.text);
                    //   print(recipients);
                    // },
                    decoration: InputDecoration(
                      labelText: "Contact Number",
                    ),
                    controller: number,
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      recipients.add(number.text);
                    });
                  },
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Message",
                ),
                controller: messageEntered,
              ),
            ),
            RaisedButton(
              child: Text("Send"),
              onPressed: sendSMS,
              // onPressed: () => _sendSMS(messageEntered.text, recipients),
            ),
          ],
        ),
      ),
    );
  }
}
