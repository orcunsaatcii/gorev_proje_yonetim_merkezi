import 'package:flutter/material.dart';

const mainColor = Color.fromARGB(255, 31, 39, 122);
const secondColor = Color.fromARGB(255, 31, 122, 46);
const backgroundColor = Color.fromARGB(255, 240, 240, 251);
const chatBackground = Color.fromARGB(255, 249, 249, 251);
const grey = Colors.grey;
const Color lightGrey = Color.fromARGB(255, 208, 208, 208);
const white = Colors.white;

const orange = Color.fromARGB(255, 245, 184, 137);
const blue = Color.fromARGB(255, 78, 129, 238);
const green = Color.fromARGB(255, 20, 204, 118);

Map<int, Map<String, Color>> taskStatus = {
  0: {'Bekliyor': orange},
  1: {'Yapılıyor': blue},
  2: {'Tamamlandı': green},
};
