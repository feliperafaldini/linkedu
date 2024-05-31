import 'package:flutter/material.dart';

import '../models/messages.dart';

class MessagePage extends StatefulWidget {
  final Message message;

  const MessagePage({
    super.key,
    required this.message,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return buildMessage();
          },
        );
      },
    );
  }

  Widget buildMessage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue.shade100,
      ),
      height: 100,
      child: ListTile(
        leading: Text(widget.message.company),
        title: Center(
          child: Text(widget.message.message),
        ),
      ),
    );
  }
}
