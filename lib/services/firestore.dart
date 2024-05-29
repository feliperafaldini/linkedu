import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/company.dart';

class FirestoreService {
  final CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');

  Future<void> addCompany(Company company) {
    return companies.add(company);
  }
}
