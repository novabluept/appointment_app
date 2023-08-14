
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MakeAppointmentScreenViewModel{
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value);
}