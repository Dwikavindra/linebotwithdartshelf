import 'package:shelf/shelf.dart';

import 'line_webhook.dart';

Handler webHookHandler(
  String channelSecret,
  Function(String message) onMessage,
) {
  return LineBot(channelSecret: channelSecret, onMessage: onMessage)
      .webHookHandler;
}
