

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fill_profile_view_model.dart';

class FillProfileModelImp implements FillProfileViewModel{

  @override
  Future setValue(AlwaysAliveRefreshable<StateController<String>> notifier,WidgetRef ref,String value) async {
    ref.read(notifier).state = value;
  }

}