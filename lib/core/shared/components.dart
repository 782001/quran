import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void NavTo(context, Widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (contex) => Widget));

void NavAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => Widget), (route) => false);

void ShowToust({
  String? Text,
  ToustStates? state,
}) =>
    Fluttertoast.showToast(
        msg: Text!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: ChooseToustColor(state!),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToustStates { SUCSESS, ERROR, WARNNING }

Color ChooseToustColor(ToustStates state) {
  Color color;
  switch (state) {
    case ToustStates.SUCSESS:
      color = Colors.green;
      break;
    case ToustStates.ERROR:
      color = Colors.red;
      break;
    case ToustStates.WARNNING:
      color = Colors.amber;
      break;
  }
  return color;
}

String uId = '';
