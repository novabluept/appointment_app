
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'choose_shop_view_model.dart';

class ChooseShopViewModelImp implements ChooseShopViewModel{

  @override
  void setValue(AlwaysAliveRefreshable<StateController> notifier, WidgetRef ref, value) {
    ref.read(notifier).state = value;
  }

}