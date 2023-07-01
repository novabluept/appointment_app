
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data_ref/services_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/service_model.dart';
import '../../model/shop_model.dart';
import 'choose_shop_view_model.dart';

class ChooseShopViewModelImp implements ChooseShopViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

}