import "package:flutter/material.dart";
import "package:sms/sms.dart";
// import 'package:sms/contact.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final number = TextEditingController();
  final messageEntered = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("SMS App"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Contact Number",
                ),
                controller: number,
                keyboardType: TextInputType.number,
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
