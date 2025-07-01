import 'package:blogapp/Modules/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> Register({
  required String email,
  required String password,
  required UserModel user,
}) async {
  try {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    String uid = result.user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(user.toMap());

    print("User registered and saved to Firestore ");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print("Error registering user: $e");
  }
}

//=============================login================================================
Future<void> LoginUser({
  required String email,
  required String password,
}) async {
  try {
    UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print(result);
  } on FirebaseAuthException catch (e) {
    print(e.credential);
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  } catch (e) {
    print("Error logging in user: $e");
  }
}

//===================================get data user=====================================
Future<UserModel> getUserData(String uid) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (snapshot.exists) {
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  } else {
    throw Exception('User not found');
  }
}
//====================Google===============
Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) return null; 

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print("Google Sign-In Error: $e");
    return null;
  }
}