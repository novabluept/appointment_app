
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ChooseShopViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
}