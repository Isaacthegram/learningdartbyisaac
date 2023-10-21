import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learningdart/services/auth/auth_provider.dart';
import 'package:learningdart/services/auth/bloc/auth_event.dart';
import 'package:learningdart/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized (isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
          exception: null,
          isLoading: false,
      ));
    });
   //send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
            email: email,
            password: password
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    //initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
              exception: null, 
              isLoading: false,
          )
        );
      } else if (!user.isEmailVerified) {
        emit (const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit (AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });
    // LOG IN
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
          exception: null, 
          isLoading: true,
        loadingText: 'Please wait while I log you in'
      ));
      await Future.delayed(const Duration(seconds: 4));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.login(
            email: email,
            password: password
        );
        
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false ));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
              exception: null,
              isLoading: false ));
          emit (AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }

      } on Exception catch (e) {
        emit (AuthStateLoggedOut(
            exception: e,
            isLoading: false));
      }
    });
    // log out
    on<AuthEventLogout>((event, emit) async{
      try {
        await provider.logout();
        emit(
            const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false));
      }
    });
  }
}