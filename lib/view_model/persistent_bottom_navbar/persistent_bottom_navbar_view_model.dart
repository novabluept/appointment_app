
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/user_model.dart';
import '../../utils/enums.dart';

abstract class PersistentBottomNavbarViewModel{
  Future<UserRole> getUserStatusAndSetImage(WidgetRef ref);
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
}