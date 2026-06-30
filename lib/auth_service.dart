import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = kIsWeb ? null : GoogleSignIn();

    //GOOGLE SIGN IN
    Future<User?> signInWithGoogle() async {
        try {
            if (kIsWeb) {
                GoogleAuthProvider googleProvider = GoogleAuthProvider();

                UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
                return userCredential.user;
            } else {
                final  googleUser = await _googleSignIn!.signIn();

                if (googleUser == null) return null;

                final googleAuth = await googleUser.authentication;
                final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                );
                return (await _auth.signInWithCredential(credential)).user;
            }
        } catch (e) {
            print('Error signing in with Google: $e');
            return null;
        }
    }

    // EMAIL/PASSWORD REGISTER
    Future<User!> registerWithEmail(String email, String password) async {
        try {
            final userCredential - await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } catch (e) {
            print('Something Went Wrong!: $e');
            return null;
        }
    }

    // EMAIL/PASSWORD LOGIN
    Future<User?> signInWIthEmail(String email, String password) async {
        try {
            final userCredential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } catch (e) {
            print('Login error: $e');
            return null;
        }
    }

    // SIGN OUT
    Future<void> signOut() async {
        try {
            if (!kIsWeb) {
                await _googleSignIn?.signOut();
            }
            await _auth.signOut();
        } catch (e) {
            print('Error signing out: $e');
        }
    }

    Stream<User?> get userStream => _auth.authStateChanges();
}