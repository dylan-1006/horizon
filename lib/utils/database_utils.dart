import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUtils {
  static Future<Map<String, dynamic>> getUserData(String userId) async {
    final userSnapshot = await DatabaseUtils.readDocument('users', userId);
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    return userData;
  }

  static Future<DocumentSnapshot> readDocument(
      String collectionPath, String documentId) async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    final documentSnapshot = await documentRef.get();
    return documentSnapshot;
  }

  static Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    DocumentReference documentRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    try {
      await documentRef.update(data);
      print("Document updated successfully!");
    } catch (e) {
      print("Error updating document: $e");
    }
  }
}
