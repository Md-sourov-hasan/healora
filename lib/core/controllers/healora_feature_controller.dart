import 'package:get/get.dart';
import 'package:healora/core/controllers/healora_state.dart';

abstract class HealoraFeatureController extends GetxController {
  HealoraFeatureController(this.state);

  final HealoraState state;

  String translate(String english, String bangla) => state.t(english, bangla);
}
