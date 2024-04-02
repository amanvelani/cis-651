import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb, TargetPlatform;

Widget platformIconButton({
  required BuildContext context,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return kIsWeb || Theme.of(context).platform == TargetPlatform.android
      ? IconButton(icon: Icon(icon), onPressed: onPressed)
      : CupertinoButton(
          onPressed: onPressed,
          child: Icon(icon, color: CupertinoColors.white),
        );
}

Widget platformTextField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  TextStyle? hintStyle,
  ValueChanged<String>? onChanged,
  TextStyle? style,
}) {
  return kIsWeb || Theme.of(context).platform == TargetPlatform.android
      ? TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            border: InputBorder.none,
          ),
          style: style,
          onChanged: onChanged,
        )
      : CupertinoTextField(
          controller: controller,
          placeholder: hintText,
          placeholderStyle: hintStyle,
          style: style,
          onChanged: onChanged,
          decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0, style: BorderStyle.none)),
          ),
        );
}
