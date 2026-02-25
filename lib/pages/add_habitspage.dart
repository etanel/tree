import 'package:flutter/material.dart';
import 'package:tree/database/tables.dart';
import 'package:tree/widgets/openPopup.dart';

class AddHabitsPage extends StatefulWidget {
  const AddHabitsPage(
      {super.key, required this.routesToPopAfterDelete, this.habit});

  final RoutesToPopAfterDelete routesToPopAfterDelete;
  final Habit? habit;

  @override
  State<AddHabitsPage> createState() => _AddHabitsPageState();
}

class _AddHabitsPageState extends State<AddHabitsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
