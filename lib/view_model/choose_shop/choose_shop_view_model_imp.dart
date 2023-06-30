
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data_ref/services_ref.dart';
import '../../data_ref/users_ref.dart';
import '../../model/service_model.dart';
import '../../model/shop_model.dart';
import 'choose_shop_view_model.dart';

class ChooseShopViewModelImp implements ChooseShopViewModel{

  @override
  void setCurrentShop(AlwaysAliveRefreshable<StateController<ShopModel>> notifier,WidgetRef ref,ShopModel value) async {
    ref.read(notifier).state = value;
  }

  @override
  void setCurrentShopIndex(AlwaysAliveRefreshable<StateController<int>> notifier,WidgetRef ref,int value) async {
    ref.read(notifier).state = value;
  }

}