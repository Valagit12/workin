import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../appconstants.dart';

class WorkoutcardWidget extends StatelessWidget {
  const WorkoutcardWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: AppSpacing.small),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Center(child: Text(title, style: TextStyle(fontSize: 30))),
        ),
      ),
    );
  }
}
