import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUtils {
  static Future<DocumentSnapshot> readDocument(
      String collectionPath, String documentId) async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    final documentSnapshot = await documentRef.get();
    return documentSnapshot;
  }
}
