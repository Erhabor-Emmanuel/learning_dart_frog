import 'dart:ffi';

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Handler> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol){
    print('connected');

    /// Now we are going to subscribe to this stream of messages from the client
    /// by listening
    channel.stream.listen((message) {
      print(message);

      /// We want to send an outgoing message from the server side
      channel.sink.add('escho => $message');
    }, onDone: () => print('disconnected')
    );
  });

  return handler;
}
