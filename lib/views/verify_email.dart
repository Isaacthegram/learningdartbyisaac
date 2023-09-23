import 'package:flutter/material.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(
        children: [
          const Text('We have sent you an email verification already'),
          const Text('If you have not recieved one yet, Click below'),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();

              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);},
              child: const Text('Go back to Register'))
        ],
      ),
    );

  }
}
