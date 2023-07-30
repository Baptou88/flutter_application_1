import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'main.dart';

class Websocket extends StatefulWidget {
  const Websocket({super.key});

  @override
  State<Websocket> createState() => _WebsocketState();
}

class _WebsocketState extends State<Websocket> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
      //Uri.parse('wss://echo.websocket.events'),
      //Uri.parse('ws://hydro.hydro-babiat.ovh/ws')
      wsUri);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WebSocket")),
      body: Column(children: [
        Form(
            child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Send a msg'),
        )),
        const SizedBox(
          height: 24,
        ),
        StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              return 
              Column(children: [
                Text(snapshot.hasData ? '${snapshot.data}' : ''),
                Text(_extract(snapshot))
              ],);
            }),
        // StreamBuilder(
        //   stream: _channel.stream,
        //   builder: (contextu, snapshotu) {
        //     return const Text('_extract(snapshot)');
        // })
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send Message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  String _extract(AsyncSnapshot<dynamic> snapshot) {
    try {
      if (snapshot.hasData) {
        Map<String,dynamic> a = jsonDecode(snapshot.data);
        
        if (a.containsKey("data")) {
          
          log(a["data"]["positionVanne"].toString());
          
          return a["data"]["positionVanne"].toString();
        }
        return "noData";
      }
      return snapshot.hasData
          ? '${jsonDecode(snapshot.data)["data"]["positionVanne"]}'
          : 'error';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
