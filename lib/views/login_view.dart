import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/services/auth/bloc/auth_bloc.dart';
import 'package:learningdart/services/auth/bloc/auth_event.dart';
import 'package:learningdart/utilities/dialogs/loading_dialog.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return BlocListener<  AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, 'Cannot find user');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Wrong Credentials');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login'),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please log in to your account to interact with and create your notes!'),
              const SizedBox(height: 10,),
              TextField(
                controller: _email,
                obscureText: false,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),),
              const SizedBox(height: 10,),
              TextField(controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password here',
                  )),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                      AuthEventLogIn(
                          email,
                          password
                      ),
                    );
                  },
                  child: const Text('Login')
              ),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventForgotPassword(),
                    );
                  },
                  child: const Text('I forgot my password')
              ),
              const SizedBox(height: 10,),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
                  },
                  child: const Text('Not registered yet? Register here')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

