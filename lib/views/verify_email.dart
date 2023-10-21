import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

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
              onPressed: () {
                context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification(),
                );

              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: ()  {
                context.read<AuthBloc>().add(
                  const AuthEventLogout(),
                );
              },
              child: const Text('Restart'))
        ],
      ),
    );

  }
}
