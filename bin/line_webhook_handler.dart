import 'package:shelf/shelf.dart';

import 'line_webhook.dart';

Handler webHookHandler(String channelSecret,
    {Function(String message)? onEvent}) {
  return LineBot(channelSecret: channelSecret, onEvent: onEvent).webHookHandler;
}
