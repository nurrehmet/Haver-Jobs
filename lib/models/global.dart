import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorData {
  Color colorTheme;
  
  getColor(){
    colorTheme = Hexcolor('#3f72af');
    return colorTheme;
  }
  
}