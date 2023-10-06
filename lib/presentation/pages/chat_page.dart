import 'dart:io';

import 'package:chat_app/infrastructure/models/mensajes_response.dart';
import 'package:chat_app/presentation/providers/auth_provider.dart';
import 'package:chat_app/presentation/providers/chat_provider.dart';
import 'package:chat_app/presentation/providers/socket_provider.dart';
import 'package:chat_app/presentation/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  late ChatProvider chatProvider;
  late SocketProvider socketProvider;
  late AuthProvider authProvider;

  final List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatProvider = Provider.of<ChatProvider>(context, listen: false);
    socketProvider = Provider.of<SocketProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    socketProvider.socket.on("mensaje-personal", _escucharMensaje);

    _cargarHistorial(chatProvider.usuarioPara.uid);
  }

  void _cargarHistorial(String uid) async {
    List<Mensaje> mensajes =
        await chatProvider.cargarHistorial(chatProvider.usuarioPara.uid);

    final history = mensajes.map((e) => ChatMessage(
          texto: e.mensaje,
          uid: e.de,
          animationController: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = ChatMessage(
      texto: data["mensaje"],
      uid: data["de"],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    _textController.dispose();
    _focusNode.dispose();
    socketProvider.socket.off("mensaje-personal");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatProvider.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(usuarioPara.name.substring(0, 2),
                  style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.name,
                style: const TextStyle(color: Colors.black87, fontSize: 13)),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _hanbleSubmit,
                onChanged: (value) {
                  setState(() {
                    if (value.trim().isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration:
                    const InputDecoration.collapsed(hintText: "Enviar mensaje"),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: const Text("Enviar"),
                      onPressed: () {},
                    )
                  : IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _isTyping
                            ? () => _hanbleSubmit(_textController.text)
                            : null,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _hanbleSubmit(String texto) {
    if (texto.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto,
      uid: authProvider.state.usuario != null
          ? authProvider.state.usuario!.uid
          : "no-uid",
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });

    socketProvider.socket.emit("mensaje-personal", {
      "de": authProvider.state.usuario != null
          ? authProvider.state.usuario!.uid
          : "no-uid",
      "para": chatProvider.usuarioPara.uid,
      "mensaje": texto,
    });
  }
}
