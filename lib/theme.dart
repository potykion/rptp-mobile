import 'package:flutter/material.dart';

final Pallete = {
  Colors.pink: Colors.pink[50],
  Colors.black: Colors.black,
  Colors.grey: Colors.grey.shade100,
};

buildTheme(context) => ThemeData(
      primaryColor: Pallete[Colors.pink],
      accentColor: Pallete[Colors.pink],
      cursorColor: Pallete[Colors.black],
      backgroundColor: Pallete[Colors.grey],
      textSelectionHandleColor: Pallete[Colors.black],
      chipTheme: Theme.of(context).chipTheme.copyWith(
            backgroundColor: Pallete[Colors.pink],
            labelStyle: TextStyle(color: Pallete[Colors.black]),
          ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
