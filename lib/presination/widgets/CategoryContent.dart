import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/DisplayContentScreen.dart';

class CategoryContentModel {
  final String title;
  final String JsonPath;
  final int id;

  CategoryContentModel({
    required this.title,
    required this.JsonPath,
    required this.id,
  });
}

Widget CategoryContentCard(CategoryContentModel model, BuildContext context) {
  return InkWell(
    onTap: () {
      // if (model.id == 3) {
      NavTo(
          context,
          DisplayContentScreen(
            jsonPath: model.JsonPath, title:model.title,
          ));
      // }
      // if (model.id == 2) {
      //   NavTo(context, const SephaScreen());
      // }
      // if (model.id == 1) {
      //   NavTo(context, const AhadesScreen());
      // }
    },
    child: SizedBox(
      height: context.height * .1,
      child: Card(
        color: const Color(0xff592c01),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: cairoFont,
                fontSize: context.width * 0.04,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
