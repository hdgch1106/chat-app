import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({
    super.key,
    required this.texto,
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: uid == "123" ? _myMessage() : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(9),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 73, 161, 255),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(9),
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 50),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 3, 88, 179),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
