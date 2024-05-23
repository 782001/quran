import 'package:flutter/material.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/screens/newContent/AhadesScreen.dart';
import 'package:quran_v2/presination/screens/Quran_HomeScreen.dart';
import 'package:quran_v2/presination/screens/newContent/azkarScreen.dart';
import 'package:quran_v2/presination/screens/newContent/doaaScreen.dart';
import 'package:quran_v2/presination/screens/newContent/hag_omra.dart';
import 'package:quran_v2/presination/screens/newContent/islamic_screen.dart';
import 'package:quran_v2/presination/screens/newContent/qss_islamic.dart';
import 'package:quran_v2/presination/screens/newContent/seraNapaweaScreen.dart';
import 'package:quran_v2/presination/widgets/DisplayContentScreen.dart';
import 'package:quran_v2/presination/screens/sepha_screen.dart';
import 'package:quran_v2/presination/widgets/mydrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final data;
  @override
  @override
  Widget build(BuildContext context) {
    List<HomeModel> HomeList = [
      HomeModel(image: ahadesImage, title: "أحاديث", id: 1),
      HomeModel(image: sephaImage, title: "المسبحه", id: 2),
      HomeModel(image: HomequranImage, title: "القرآن الكريم", id: 3),
      HomeModel(image: azkarImage, title: "أذكار", id: 4),
      HomeModel(image: islamicImage, title: "اسلاميات", id: 5),
      HomeModel(image: doaaImage, title: "أدعيه", id: 6),
      HomeModel(image: hag_omraImage, title: "الحج والعمره", id: 7),
      HomeModel(image: seraNabweyaImage, title: "السيرة النبويه", id: 8),
      HomeModel(image: qssIslamicImage, title: "قصص اسلاميه", id: 9),
    ];

    return Scaffold(
      drawer: const MyDrawer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffFFFBE8),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color(0xff592c01),
        title: Text(
          "استغفر الله العظيم وأتوب اليه",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: cairoFont,
            fontSize: context.width * 0.04,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.15,
              ),
              SizedBox(
                height: context.height * 0.05,
              ),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color(0xffFFFBE8),
                  ),
                  width: context.width * 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: context.width * 0.01,
                        mainAxisSpacing: context.width * 0.02,
                        mainAxisExtent: context.height * 0.15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return HomeCard(HomeList[index], data, context);
                      },
                      itemCount: HomeList.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget HomeCard(HomeModel model, data, BuildContext context) {
  return InkWell(
    onTap: () {
      if (model.id == 3) {
        NavTo(
            context,
            QuranHomeScreen(
              data: data,
            ));
      }
      if (model.id == 2) {
        NavTo(context, const SephaScreen());
      }
      if (model.id == 1) {
        NavTo(
            context,
            AhadesScreen(
              title: model.title,
            ));
      }
      if (model.id == 6) {
        NavTo(
            context,
            DoaaScreen(
              title: model.title,
            ));
      }
      if (model.id == 4) {
        NavTo(
            context,
            AzkarScreen(
              title: model.title,
            ));
      }
      if (model.id == 5) {
        NavTo(
            context,
            IslamicScreen(
              title: model.title,
            ));
      }
      if (model.id == 7) {
        NavTo(
            context,
            HagOmraScreen(
              title: model.title,
            ));
      }
      if (model.id == 8) {
        NavTo(
            context,
            SeraNapaweaScreen(
              title: model.title,
            ));
      }
      if (model.id == 9) {
        NavTo(
            context,
            QssIslamicScreen(
              title: model.title,
            ));
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: const Color(0xff592c01),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: context.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image(
                  image: AssetImage(model.image),
                  fit: BoxFit.contain,
                  width: context.width * 0.3,
                  height: context.height * 0.07,
                  color: model.id == 1 ? null : const Color(0xfff2e3a0),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Color(0xff592c01),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                width: context.width * 0.3,
                height: context.height * 0.05,
                child: Center(
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
            ],
          ),
        ),
      ],
    ),
  );
}

class HomeModel {
  final String image;
  final String title;
  final int id;

  HomeModel({
    required this.image,
    required this.title,
    required this.id,
  });
}

// extension MediaQueryValues on BuildContext {
//   double get width => MediaQuery.of(this).size.width;
//   double get height => MediaQuery.of(this).size.height;
// }
