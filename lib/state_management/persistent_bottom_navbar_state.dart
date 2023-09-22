
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../model/user_model.dart';

final currentUserPictureProvider = StateProvider<Uint8List?>((ref) => null);
final currentUserProvider = StateProvider<UserModel>((ref) => UserModel(firstname: '', lastname: '', dateOfBirth: '', email: '', phone: '', role: ''));
final controllerPersistentBottomNavbarProvider = StateProvider<PersistentTabController>((ref) => PersistentTabController(initialIndex: 0));