import 'package:flutter/material.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/media_query_values.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/widgets/mydrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<HomeModel> HomeList = [
      HomeModel(image: SplashImage, title: "القرآن الكريم", id: 1),
      HomeModel(image: sephaImage, title: "المسبحه", id: 2),
      HomeModel(image: ahadesImage, title: "أحاديث", id: 3),
      HomeModel(image: azkarImage, title: "أذكار", id: 4),
      HomeModel(image: islamicImage, title: "اسلاميات", id: 5),
      HomeModel(image: doaaImage, title: "أدعيه", id: 6),
      HomeModel(image: hag_omraImage, title: "الحج والعمره", id: 7),
      HomeModel(image: seraNabweyaImage, title: "السيرة النبويه", id: 8),
      HomeModel(image:qssIslamicImage, title: "قصص اسلاميه", id: 9),
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
        backgroundColor: Colors.brown,
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
                        mainAxisExtent: context.height * 0.13,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return HomeCard(HomeList[index], context);
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

Widget HomeCard(HomeModel model, BuildContext context) {
  return InkWell(
    onTap: () {
      // model.id == 3
      //     ? NavTo(context, RatingScreen())
      //     : NavTo(
      //         context,
      //         LevelsScreen(
      //           homeModelId: model.id,
      //           fromMoving: false,
      //         ));
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: Colors.brown,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Image(
                image: AssetImage(model.image),
                fit: BoxFit.contain,
                width: context.width * 0.3,
                height: context.height * 0.07,
                color: (model.id == 5 && model.id == 3)
                    ? const Color(0xffFFFBE8)
                    : null,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.brown,
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
