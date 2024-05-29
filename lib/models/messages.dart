class Message {
  final int id;
  final String company;
  final String message;

  const Message(
      {required this.id, required this.company, required this.message});

  Map<String, dynamic> topMap() {
    return {
      'company': company,
      'message': message,
    };
  }
}
