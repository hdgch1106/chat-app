import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String? errorMessage;
  final IconData icon;
  final String placeholder;
  //final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    //required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 5),
              blurRadius: 5,
            )
          ]),
      child: TextFormField(
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        //controller: textController,
        autocorrect: false,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIconColor: Colors.black45,
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.black45),
          errorText: errorMessage,
          errorBorder: border,
          focusedErrorBorder: border,
        ),
      ),
    );
  }
}
