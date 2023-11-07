import 'package:flutter/material.dart';
import 'constant.dart';

var mediaQuerySize;
initMediaQuerySize(BuildContext context) {
  mediaQuerySize = MediaQuery.of(context).size;
}
double widgetWidth(double pixels){
 return mediaQuerySize.width/(AppConstant.designWidth/pixels);
}
double widgetHeight(double pixels){
  return mediaQuerySize.height/(AppConstant.designHeight/pixels);
}