import 'package:flutter/material.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/chat/chat_messages.dart';
import 'package:gorev_proje_yonetim_uygulamasi/pages/employee/chat/widgets/new_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(),
            ),
            SizedBox(
              height: 10.0,
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
