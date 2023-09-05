import 'package:chat_app/infrastructure/inputs/email.dart';
import 'package:chat_app/infrastructure/inputs/password.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class LoginFormProvider with ChangeNotifier {
  LoginFormState _state = LoginFormState();

  LoginFormState get state => _state;
  set state(LoginFormState valor) {
    _state = valor;
    notifyListeners();
  }

  logout() {
    state = state.copyWith(
        email: const Email.pure(),
        password: const Password.pure(),
        isValid: false,
        isFormPosted: false,
        isPosting: false);
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit(BuildContext context) async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.login(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state =
        state.copyWith(isFormPosted: true, email: email, password: password);
  }
}

//State
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return """
    LoginFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      email: $email
      password: $password
""";
  }
}
