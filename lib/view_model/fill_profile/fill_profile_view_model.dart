
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FillProfileViewModel{

  Future setValue(AlwaysAliveRefreshable<StateController<String>> notifier,WidgetRef ref,String value);

}