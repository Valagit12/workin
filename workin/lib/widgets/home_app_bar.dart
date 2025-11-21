import 'package:flutter/material.dart';

import '../data/notifiers.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("WorkIn", style: TextStyle(fontSize: 40)),
      actions: [
        IconButton(
          onPressed: () {
            isDarkModeNotifier.value = !isDarkModeNotifier.value;
          },
          icon: ValueListenableBuilder(
            valueListenable: isDarkModeNotifier,
            builder: (context, isDarkmode, children) {
              return Icon(isDarkmode ? Icons.dark_mode : Icons.light_mode);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
