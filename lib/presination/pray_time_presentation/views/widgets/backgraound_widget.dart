import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/assets_path.dart';


class BackGroundWidget extends StatelessWidget {
  const BackGroundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        image: DecorationImage(
          image: AssetImage(pray_backgraoundImage),
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
