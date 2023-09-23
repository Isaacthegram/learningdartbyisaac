import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:learningdart/constants/routes.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),),
      body: Column(
        children: [
          TextField(
            controller: _email,
            obscureText: false,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),),
          TextField(controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              )),
          TextButton(
              onPressed: () async {
                try {
                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _email.text,
                    password: _password.text,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                    //verified
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                    //not verified
                  }


                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(context, 'User not found');
                  } else if (e.code == 'invalid-email') {
                    await showErrorDialog(context, 'Invalid email');
                  } else if (e.code == 'wrong-password') {
                    await showErrorDialog(context, 'Wrong password');
                  } else if (e.code == 'weak-password') {
                    await showErrorDialog(context, 'Weak password'); // Add this message for weak password
                  } else {
                    // Handle other FirebaseAuthException error codes here if needed
                    await showErrorDialog(context, 'Invalid email or password');
                  }
                } catch (e) {
                  // Handle other exceptions that might occur during authentication
                  await showErrorDialog(context,'An error occurred: $e');
                }
              },
              child: const Text('Login')
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
      },
              child: const Text('Not registered yet? Register here')
          )],
      ),
    );
  }
}

