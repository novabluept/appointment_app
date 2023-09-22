
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EditProfileViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
  Future updateUser(Map<String, dynamic> fields);
}