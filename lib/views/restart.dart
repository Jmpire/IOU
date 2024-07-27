import 'package:flutter/material.dart';

class RestartableApp extends StatefulWidget {
  final Widget child;

  const RestartableApp({super.key, required this.child});

  static void restartApp(BuildContext context) {
    final _RestartableAppState? state =
        context.findAncestorStateOfType<_RestartableAppState>();
    state?.restartApp();
  }

  @override
  State<RestartableApp> createState() => _RestartableAppState();
}

class _RestartableAppState extends State<RestartableApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}