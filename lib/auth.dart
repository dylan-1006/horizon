import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<void> signInWithGoogle() async {
    final user = await GoogleSignIn().signIn();
    final googleAuth = await user?.authentication;
    final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    _firebaseAuth.signInWithCredential(credentials).then((value) {
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
        {
          "email": value.user!.email,
          "id": value.user!.uid,
          'name': user!.displayName
        },
      );
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
