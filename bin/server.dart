//To DO: Host in railway, current still only using ngrok
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post("/linewebhook", _webhookExample);

Response _rootHandler(Request req) {
  return Response.ok('<div style="background-color:black;">Kipak\n</div>');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _webhookExample(Request request) async {
  // response return cannot be a future so no async methods are allowed here
  print(request.headers);
  print(await request.readAsString());
  print("Hello World");
  final response = Response.ok("");
  return response; // it works hahahah
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}'); // runs on ---
}
