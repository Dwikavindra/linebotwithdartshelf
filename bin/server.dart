//To DO: Host in railway, current still only using ngrok
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import '../lib/env/env.dart';
import 'package:crypto/crypto.dart';

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
  // nvm u can use futures which is nice to have :_
  final headers = request.headers;
  final signature = headers["x-line-signature"];
  print("Signature from Line ${signature} ");
  var hmacSha256 = Hmac(sha256, utf8.encode(Env.channel_secret)); // HMAC-SHA256

  final body = await request
      .readAsString(); // .// this await will block the function  of this code so everyone will wait for this
  var digest = hmacSha256.convert(utf8.encode(body));
  final base64confirmation = base64Encode(digest.bytes);
  print("This is the processed x-line-signature ${base64confirmation}");
  final messageDecoded = jsonDecode(body);
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
  final server = await serve(handler, ip, port, shared: true);
  print('Server listening on port ${server.port}'); // runs on ---
}
