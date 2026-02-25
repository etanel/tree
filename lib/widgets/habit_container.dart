import 'package:flutter/material.dart';
import 'package:tree/database/tables.dart';

class HabitContainer extends StatelessWidget {
  const HabitContainer({
    super.key,
    required this.habit,
    this.height = 183,
    this.intermediatePadding = true,
  });

  final Habit habit;
  final double height;
  final bool intermediatePadding;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
