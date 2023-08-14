
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fill_profile_view_model.dart';

class FillProfileModelImp implements FillProfileViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController<dynamic>> notifier,WidgetRef ref,dynamic value) {
    ref.read(notifier).state = value;
  }
}