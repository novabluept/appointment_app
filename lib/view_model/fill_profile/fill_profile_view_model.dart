
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FillProfileViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
}