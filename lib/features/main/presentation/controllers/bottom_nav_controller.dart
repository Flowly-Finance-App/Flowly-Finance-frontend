import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavController extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

typedef BottomNavIndexNotifier = BottomNavController;
