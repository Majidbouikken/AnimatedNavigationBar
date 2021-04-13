import 'package:flutter/material.dart';

class AnimatedNavBarPage {
  final String title;
  final Widget pageContent;
  final IconData icon;
  final IconData inactiveIcon;

  const AnimatedNavBarPage({Key key, this.title, this.pageContent, this.icon, this.inactiveIcon});
}
