import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/messages.dart';

class MessagePage extends StatefulWidget {
  final Message message;

  const MessagePage({super.key, required this.message});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildMessages(),
          ],
        ),
      ),
    );
  }

  Widget buildMessages() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          children: [
            buildMessage(),
          ],
        );
      },
    );
  }

  Widget buildMessage() {
    return ListTile(
      leading: Text(widget.message.company),
      title: Text(widget.message.message),
    );
  }
}
