import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'package:learningdart/views/verify_email.dart';
import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),

    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.emailVerified) {
              print('Email is Verified');
            } else {
              return const VerifyEmailView();
            }
          }
          // if (user?.emailVerified ?? false) {
          //   return const Text('Done');
          // } else {
          //   return const _VerifyEmailViewState();
          // }
            return LoginView();
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

