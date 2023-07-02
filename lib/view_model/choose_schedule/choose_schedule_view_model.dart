

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/service_model.dart';
import '../../model/shop_model.dart';

abstract class ChooseScheduleViewModel{

  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);

}