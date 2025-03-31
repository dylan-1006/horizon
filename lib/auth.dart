import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horizon/utils/database_utils.dart';

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
        {
          "email": value.user!.email,
          "id": value.user!.uid,
          'name': name,
          'dateJoined': FieldValue.serverTimestamp(),
        },
      );
    });
    _firebaseAuth.currentUser?.updateDisplayName(name);
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
          'name': user!.displayName,
          'dateJoined': FieldValue.serverTimestamp(),
        },
      );
    });
  }

  String getUserId() {
    try {
      User? user = _firebaseAuth.currentUser;
      String userId = user!.uid;
      return userId;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword({required String newPassword}) async {
    await _firebaseAuth.currentUser?.updatePassword(newPassword);
  }

  Future<void> updateName({required String newName}) async {
    await _firebaseAuth.currentUser?.updateDisplayName(newName);
    await DatabaseUtils.updateDocument(
        'users', _firebaseAuth.currentUser!.uid, {
      'name': newName,
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
