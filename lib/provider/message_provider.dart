import 'package:flutter/material.dart';

import '../models/messages.dart';

class MessageProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  MessageProvider() {
    buildMessages();
  }

  void buildMessages() {
    _messages = <Message>[
      const Message(
        id: 1,
        company: 'Google',
        message: 'Mensagem do Google',
      ),
      const Message(
        id: 2,
        company: 'Amazon',
        message: 'Mensagem do Amazon',
      ),
      const Message(
        id: 3,
        company: 'Meta',
        message: 'Mensagem do Meta',
      ),
    ].reversed.toList();

    notifyListeners();
  }
}
