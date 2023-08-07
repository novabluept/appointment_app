
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user_model.dart';

final currentUserProvider = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));
