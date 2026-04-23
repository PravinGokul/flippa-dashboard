import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Sign in with Email and Password
  Future<UserCredential> signInEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up with Email and Password and set initial role
  Future<UserCredential> signUpEmail(String email, String password, {String role = 'consumer'}) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    if (credential.user != null) {
      await _createUserDocument(credential.user!, role);
    }
    
    return credential;
  }

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle({String role = 'consumer'}) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use signInWithPopup
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(authProvider);
      } else {
        // Android/iOS: Use GoogleSignIn package
        final googleSignIn = GoogleSignIn();
        
        // Authenticate with Google
        final GoogleSignInAccount? account = await googleSignIn.signIn();
        
        if (account == null) {
          throw Exception('Google Sign-In was cancelled');
        }

        // Get authentication tokens
        final GoogleSignInAuthentication auth = await account.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        // Sign in to Firebase with the Google credential
        userCredential = await _auth.signInWithCredential(credential);
      }

      // Create user document if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserDocument(userCredential.user!, role);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Sign out from Google
  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  /// Phone Authentication - Step 1: Send verification code
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId, int? resendToken) codeSent,
    required Function(FirebaseAuthException error) verificationFailed,
    required Function(PhoneAuthCredential credential) verificationCompleted,
    Object? applicationVerifier, // RecaptchaVerifier for Web
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (kIsWeb) {
      try {
        final ConfirmationResult result = await _auth.signInWithPhoneNumber(
          phoneNumber,
          applicationVerifier as dynamic,
        );
        codeSent(result.verificationId, null);
      } on FirebaseAuthException catch (e) {
        verificationFailed(e);
      } catch (e) {
        verificationFailed(FirebaseAuthException(
          code: 'unknown',
          message: e.toString(),
        ));
      }
    } else {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String id) {},
      );
    }
  }

  /// Phone Authentication - Step 2: Sign in with verification code
  Future<UserCredential> signInWithPhoneNumber({
    required String verificationId,
    required String smsCode,
    String role = 'consumer',
  }) async {
    try {
      // Create a PhoneAuthCredential with the code
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Sign in with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Create user document if this is a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserDocument(userCredential.user!, role);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Phone Sign-In failed: $e');
    }
  }

  /// Link phone number to existing account
  Future<UserCredential> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await user.linkWithCredential(credential);
  }

  /// Create or update user document in Firestore
  Future<void> _createUserDocument(User user, String role) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'role': role,
        'verified': false,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    } else {
      // Update last sign-in time
      await userDoc.update({
        'lastSignIn': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Fetch user role from Firestore
  Future<String> getUserRole(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'consumer';
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await user.updateDisplayName(displayName);
    await user.updatePhotoURL(photoURL);

    // Update Firestore document
    await _firestore.collection('users').doc(user.uid).update({
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
    });
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Send email verification
  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Reload current user
  Future<void> reloadUser() async {
    await currentUser?.reload();
  }

  /// Sign out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
