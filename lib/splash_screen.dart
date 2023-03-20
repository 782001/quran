import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/presination/screens/HomeScreen.dart';

import 'core/utils/conestans.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readJson(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // AppColors.kTealColor,
                    Color(0xff14697B),
                    Color(0xffE95C1F),
                    Color(0xffE95C1F),
                    Color(0xffE95C1F),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                        padding: const EdgeInsetsDirectional.only(
                            top: 40.0, start: 30, end: 30),
                        child: Image.asset(SplashImage)),
                    // decoration: const BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       // AppColors.kTealColor,
                    //       Color(0xff14697B),
                    //       Color(0xffE95C1F),
                    //       Color(0xffE95C1F),
                    //       Color(0xffE95C1F),
                    //     ],
                    //   ),
                    // ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                // AppColors.kTealColor,
                                Color(0xff14697B),
                                Color(0xffE95C1F),
                                Color(0xffE95C1F),
                                Color(0xffE95C1F),
                              ],
                            ),
                          ),
                        ),
                        Center(
                            child: CircularProgressIndicator(
                          color: Color(0xff14697B),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('هناك خطأ ما');
            } else if (snapshot.hasData) {
              return HomeScreen(data: snapshot.hasData);
            } else {
              return const Text('لا يوجد بيانات ');
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xff14697B),
              ),
            );
          }
        });
  }
}
