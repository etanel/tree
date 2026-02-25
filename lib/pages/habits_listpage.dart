import 'package:flutter/material.dart'
    hide SliverReorderableList, ReorderableDelayedDragStartListener;
import 'package:tree/widgets/framework/pageFramework.dart';

class HabitsListPage extends StatefulWidget {
  const HabitsListPage({
    super.key,
    required this.enableBackButton,
  });

  final bool enableBackButton;

  @override
  State<HabitsListPage> createState() => HabitsListPageState();
}

class HabitsListPageState extends State<HabitsListPage> {
  GlobalKey<PageFrameworkState> pageState = GlobalKey();
  void refreshState() {
    setState(() {});
  }

  void scrollToTop() {
    pageState.currentState?.scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
