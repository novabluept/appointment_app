
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/constants.dart';

final imagePathProvider = StateProvider<String>((ref) => PROFILE_IMAGE_DIRECTORY);
final firstNameProvider = StateProvider<String>((ref) => '');
final lastNameProvider = StateProvider<String>((ref) => '');
final dateOfBirthProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final phoneProvider = StateProvider<String>((ref) => '');

