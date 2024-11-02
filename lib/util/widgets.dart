import 'package:flutter/material.dart';

class Widgets {
  static const Widget preloader = Center(
    child: CircularProgressIndicator(),
  );

  static Widget createBottomPadding(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).padding.bottom);
}
