import 'package:get_it/get_it.dart';
import 'package:chatlinxs/provider/audio_provider.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<AudioProvider>(AudioProvider());
}
