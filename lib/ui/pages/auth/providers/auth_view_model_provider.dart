
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_web_admin/core/repository/repository.dart';


final authViewModelProvider =
    ChangeNotifierProvider((ref) => AuthViewModel(ref));

class AuthViewModel extends ChangeNotifier {
  final ProviderReference ref;
  AuthViewModel(this.ref);

  Repository get repo => ref.read(repositoryProvider);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  String email = 'shivkumar.konade@virtoustack.com';
  String password = 'Shiv@123';

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void login() async {
    loading = true;
    try {
      if (await repo.checkAdminExist(email)) {
        try {
          final credential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          user = credential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == "user-not-found") {
            final credential = await _auth.createUserWithEmailAndPassword(
                email: email, password: password);
            user = credential.user;
          }
        }
      } else {
        print('admin not exists');
      }
    } catch (e) {
      print(e);
    }
    loading = false;
  }
}
