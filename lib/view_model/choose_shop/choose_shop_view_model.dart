

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/service_model.dart';
import '../../model/shop_model.dart';

abstract class ChooseShopViewModel{

  void setCurrentShop(AlwaysAliveRefreshable<StateController<ShopModel>> notifier,WidgetRef ref,ShopModel value);
  void setCurrentShopIndex(AlwaysAliveRefreshable<StateController<int>> notifier,WidgetRef ref,int value);
}