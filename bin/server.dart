//To DO: Host in railway, current still only using ngrok
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import '../lib/env/env.dart';
import 'package:crypto/crypto.dart';

import 'line_webhook.dart';
import 'line_webhook_handler.dart';

// Configure routes.

final lineBot = webHookHandler(Env.channel_secret, onEvent: onLineEvent);
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post("/linewebhook", lineBot);

Response _rootHandler(Request req) {
  return Response.ok('<div style="background-color:black;">Kipak\n</div>');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void onLineEvent(String event) {
  print(event);
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port, shared: true);
  print('Server listening on port ${server.port}'); // runs on ---
}
