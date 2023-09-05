import 'package:chat_app/infrastructure/inputs/email.dart';
import 'package:chat_app/infrastructure/inputs/name.dart';
import 'package:chat_app/infrastructure/inputs/password.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class RegisterFormProvider with ChangeNotifier {
  RegisterFormState _state = RegisterFormState();

  RegisterFormState get state => _state;
  set state(RegisterFormState valor) {
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

  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.email, state.password]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.name, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.name, state.email]),
    );
  }

  onFormSubmit(BuildContext context) async {
    try {
      _touchEveryField();
      if (!state.isValid) return;
      state = state.copyWith(isPosting: true);
      final auth = Provider.of<AuthProvider>(context, listen: false);

      await auth.register(
          state.name.value, state.email.value, state.password.value);
      state = state.copyWith(isPosting: false);
    } catch (e) {
      state = state.copyWith(isPosting: false);
      throw Exception(e);
    }
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: password,
    );
  }
}

//State
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return """
    RegisterFormState:
      isPosting: $isPosting
      isFormPosted: $isFormPosted
      isValid: $isValid
      name: $name
      email: $email
      password: $password
""";
  }
}
