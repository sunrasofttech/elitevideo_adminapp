import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final String icon;
  final String? tag;
  final Widget? screen;
  final int? index;
  final List<DrawerItem>? children;

  DrawerItem({
    required this.title,
    required this.icon,
    this.screen,
    this.index,
    required this.tag,
    this.children,
  });
}
