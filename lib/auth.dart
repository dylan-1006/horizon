import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
        {"email": value.user!.email, "id": value.user!.uid, 'name': name},
      );
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
