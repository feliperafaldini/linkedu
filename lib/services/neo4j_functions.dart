import 'package:cloud_functions/cloud_functions.dart';

class Neo4jService {
  final HttpsCallable addNodeCallable =
      FirebaseFunctions.instance.httpsCallable('addNode');

  Future<void> addNode(String nodeName, String nodeType) async {
    try {
      final result = await addNodeCallable.call({
        'nodeName': nodeName,
        'nodeType': nodeType,
      });
      print('Node Adicionada: ${result.data}');
    } catch (error) {
      print('Erro adicionando a node: $error');
    }
  }
}
