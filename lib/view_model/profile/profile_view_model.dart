
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ProfileViewModel{
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value);
  Future signOut();
  Future addUserPicture(File file, String pathToSave);
  Future updateUser(Map<String, dynamic> fields);
  Future deleteUserPicture(String path);

}