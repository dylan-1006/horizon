import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:path/path.dart' as path;

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

  Future<String> getUserId() async {
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

  Future<String?> uploadProfileImage(File imageFile) async {
    try {
      final userId = await getUserId();
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Generate a unique filename
      final String fileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.${path.extension(imageFile.path).substring(1)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('images/user_profile/$fileName');

      // Get current user data to check for existing profile image
      final userData = await DatabaseUtils.getUserData(userId);

      // If there's an existing profile image, delete it
      if (userData['profileImgUrl'] != null) {
        try {
          final ref =
              FirebaseStorage.instance.refFromURL(userData['profileImgUrl']);
          await ref.delete();
        } catch (e) {
          print('Error deleting old image: $e');
          // Continue even if deletion fails
        }
      }

      // Upload the new image
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update user document with new profile image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImgUrl': downloadUrl});

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  Future<void> removeProfileImage() async {
    try {
      final userId = await getUserId();
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Get current user data
      final userData = await DatabaseUtils.getUserData(userId);

      // If there's an existing profile image, delete it from storage
      if (userData['profileImgUrl'] != null) {
        try {
          final ref =
              FirebaseStorage.instance.refFromURL(userData['profileImgUrl']);
          await ref.delete();
        } catch (e) {
          print('Error deleting old image: $e');
          // Continue even if deletion fails
        }
      }

      // Update user document to remove profile image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'profileImgUrl': null});
    } catch (e) {
      print('Error removing profile image: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
