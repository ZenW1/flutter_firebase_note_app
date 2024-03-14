import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jong_jam/data/repo/database_repo.dart';

class UserRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  String verificationId = '';

  Stream<auth.User?> get statusChange => _firebaseAuth.authStateChanges();

  Future<String?> loginUser({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // statusChange.listen((event) {
      //   _firebaseAuth.currentUser!.getIdToken().then((value) => print('IDtoken $value'));
      // });

      return 'Login Success';
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "User not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "Wrong password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
          msg: "Invalid email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'user-disabled') {
        Fluttertoast.showToast(
          msg: "User disabled",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'too-many-requests') {
        Fluttertoast.showToast(
          msg: "Too many requests",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'operation-not-allowed') {
        Fluttertoast.showToast(
            msg: "Operation not allowed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      } else if (e.code == 'network-request-failed') {
        Fluttertoast.showToast(
          msg: "Network request failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      } else if (e.code == 'email-already-in-user') {
        Fluttertoast.showToast(
          msg: "Email already in user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
      }
      return e.message;
    }
  }

  Future<String?> phoneAuthetication({required String phoneNumber}) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print('codeSent');
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('codeAutoRetrievalTimeout');
          this.verificationId = verificationId;
        },
      );
      return 'Otp Sent';
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<bool?> verifyOtp({required String otp}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp));
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      //confirm result
      print('verification id $verificationId');
      print('verification id $verificationId');
      print('verification id $verificationId');
      print('verification id $verificationId');
      print('verification id $verificationId');
      print('verification id $verificationId');

      return userCredential.additionalUserInfo!.isNewUser ? false : true;
    } on auth.FirebaseAuthException catch (e) {
      return false;
    }
  }

  Future<String?> getFcmToken({required String token}) async {
    try {
      auth.User user = _firebaseAuth.currentUser!;

      await DatabaseRepository(uid: user.uid).getUserFcmToken(
        token: token,
      );
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> insertUserInfo(
      {required String name, required String nickName, required String phone, required String gmail}) async {
    try {
      auth.User user = _firebaseAuth.currentUser!;

      // send message

      await DatabaseRepository(uid: user.uid).updateUserRecord(
        name: name,
        phone: phone,
        gmail: gmail,
      );
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  Future<String?> signUpUser({required String email, required String password, required String name, required String phone}) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // auth.User user = result.user!;

      return result.user!.uid;
    } on auth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //remove token
  Future<void> signOut() async {
    auth.User user = _firebaseAuth.currentUser!;

    //remove token from database

    Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<auth.User> getUser() async {
    return _firebaseAuth.currentUser!;
  }
}
