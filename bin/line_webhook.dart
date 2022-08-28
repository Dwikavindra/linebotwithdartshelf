import 'dart:convert';
import 'package:linebot/env/env.dart';
import 'package:shelf/shelf.dart';
import 'package:crypto/crypto.dart';

//could be a class of linebot with a webhook handler passed to the route
// so it would be something along the lines of Router.post('/linewebhoook,LineBot.webHookHandler())
// with webhook handler heaving on message on unsent etc etc
//for example to respnse in html look at shelf webhook
// the shelf router only needs to call LineBot.onMessage i want it when its called it goes something like this LineBot.onMessage((value){
// }) gimana ya??/

// setup an enum too for different type of messages
class LineBot {
  String message = "";
  final String _channelSecret;
  final Function(String message) _onMessage;
  LineBot(
      {required String channelSecret,
      required Function(String Message) onMessage})
      : _channelSecret = channelSecret,
        _onMessage = onMessage;

  Future<Response> webHookHandler(Request payload) async {
    String body = await payload.readAsString();
    bool isSentFromLine =
        await confirmLineXSignature(body: body, headers: payload.headers);

    if (isSentFromLine) {
      _onMessage(body);
    }
    return Response.ok("");
  }

  Future<bool> confirmLineXSignature(
      {required String body, required Map<String, String> headers}) async {
    final signature = headers["x-line-signature"];
    final hmacSha256 = Hmac(sha256, utf8.encode(_channelSecret)); // HMAC-SHA256
    final hmacConverted = hmacSha256.convert(utf8.encode(body));
    final digest = base64Encode(hmacConverted.bytes);
    return signature == digest;
  }
}
