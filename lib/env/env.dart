import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify(path: '.env')
abstract class Env {
  static const channel_secret = _Env.channel_secret;
}
