
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fill Profile
final imageProvider = StateProvider<File>((ref) => File(''));
final firstNameProvider = StateProvider<String>((ref) => '');
final lastNameProvider = StateProvider<String>((ref) => '');
final dateOfBirthProvider = StateProvider<String>((ref) => '');
final emailProvider = StateProvider<String>((ref) => '');
final phoneNumberProvider = StateProvider<String>((ref) => '');

