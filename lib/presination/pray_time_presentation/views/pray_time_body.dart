import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_v2/core/network/local/cashhelper.dart';
import 'package:quran_v2/core/responsive/screen_util.dart';
import 'package:quran_v2/core/shared/components.dart';
import 'package:quran_v2/core/utils/app_theme_colors.dart';
import 'package:quran_v2/core/utils/assets_path.dart';
import 'package:quran_v2/core/utils/conestans.dart';
import 'package:quran_v2/core/utils/strings.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/backgraound_widget.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/customErrorContainer.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/custom_loading.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/date_widget.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/time_wiget.dart';
import 'package:quran_v2/presination/pray_time_presentation/views/widgets/timer_count_widget.dart';

import '../controller/pray_time_cubit.dart';

class PrayTimeScreen extends StatelessWidget {
  const PrayTimeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(date);
    final double timeNow = DateTime.now().hour.toDouble();
    return BlocConsumer<PrayTimeCubit, PrayTimeState>(
      listener: (context, state) {
        if (state is PrayTimeSuccessFetchData) {
          //print(state.data.data['timings']['Fajr']);
        }
        if (state is PrayTimeLoadingFetchData) {
          const Center(child: CircularProgressIndicator());
        }
      },
      builder: (context, state) {
        PrayTimeCubit cubit = PrayTimeCubit.get(context);
        if (state is PrayTimeSuccessFetchData) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  const BackGroundWidget(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const DateWidget(),
                        // TimerCountWidget(
                        //   cubit: cubit,
                        //   color: MyColors.lightBrown,
                        // ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12.0, end: 12),
                          child: Text(
                            "في حال لم تكن مواقيت الصلاة دقيقه سيتوجب عليك الضغط هنا لعرض المواقيت الصحيحه ولكن تحتاج للانترنت في كل مره ",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: MyColors.babyBrown,
                          ),
                          child: TextButton(
                            child: const Text(
                              "اضغط هنا",
                              style: TextStyle(color: MyColors.whiteColor),
                            ),
                            onPressed: () {
                              cubit.fetchFromApi();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TimeWidget(
                                prayName: "الظهر",
                                prayTime: duhrTime,
                              ),
                              TimeWidget(
                                prayName: "الشروق",
                                prayTime: shroukTime,
                              ),
                              TimeWidget(
                                prayName: "الفجر",
                                prayTime: fajrTime,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TimeWidget(
                                prayName: "العشاء",
                                prayTime: ishaTime,
                              ),
                              TimeWidget(
                                prayName: "المغرب",
                                prayTime: maghrbTime,
                              ),
                              TimeWidget(
                                prayName: "العصر",
                                prayTime: asrTime,
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          pray_icon,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                        if (CashHelper.GetData(key: AppStrings.locationKey) ==
                                true /*&&
        location != null*/
                            ) ...[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              color: MyColors.lightBrown,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .85,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.17,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TimerCountWidget(
                                    cubit: cubit,
                                    color: MyColors.appBackGroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is PrayTimeErrorFetchData) {
          Future<void> getUserLocation() async {
            try {
              // Check if the device is currently offline
              final bool isOffline =
                  !await InternetConnectionChecker().hasConnection;

              // if (isOffline) {
              //   // Handle offline scenario: No network connectivity
              //   print("----offline-----");
              //   await CashHelper.SaveData(
              //       key: AppStrings.locationKey, value: false);
              //   ShowToust(state: ToustStates.ERROR, Text: 'لا يوجد انترنيت');
              // } else {
              // Request location permission
              var status = await Permission.locationWhenInUse.request();

              if (status.isGranted) {
                // Location permission granted, get the location
                final Position position = await Geolocator.getCurrentPosition();
                log(position.toString());
                await CashHelper.SaveData(
                    key: AppStrings.locationKey, value: true);
                await CashHelper.SaveData(
                    key: AppStrings.latKey, value: position.latitude);
                await CashHelper.SaveData(
                    key: AppStrings.longKey, value: position.longitude);
                // Continue with additional logic or data processing here.
              } else {
                // Location permission denied
                await CashHelper.SaveData(
                    key: AppStrings.locationKey, value: false);
                ShowToust(
                    state: ToustStates.ERROR,
                    Text: 'قم بالسماح بأخذ موقعك من الإعدادات');
                print("----permission denied-----");
                // Handle the scenario where the user denies location permission
              }
              // }
            } catch (e) {
              // Handle exceptions, including those related to network or location errors
              await CashHelper.SaveData(
                  key: AppStrings.locationKey, value: false);
              print("----error-----");
              throw PlatformException(
                code: 'ERROR_GETTING_LOCATION',
                message: 'Error getting user location: $e',
              );
            }
          }

          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  const BackGroundWidget(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomErrorContainer(
                        title: "يجب تفعيل الموقع أولا",
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      MaterialButton(
                        color: MyColors.darkBrown,
                        onPressed: () async {
                          //const CustomLoadingPage();
                          await getUserLocation().then((value) {
                            cubit.fetchPrayData(context);
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        splashColor: MyColors.lightBrown,
                        elevation: 5,
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "تفعيل الموقع",
                          style: GoogleFonts.noticiaText(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Image.asset(
                        pray_icon,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (state is PrayTimeErrorFetchDataAPI) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  const BackGroundWidget(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomErrorContainer(
                        title: "يبدو ان هناك خطأ ما ",
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      MaterialButton(
                        color: MyColors.darkBrown,
                        onPressed: () async {
                          //const CustomLoadingPage();
                          cubit.fetchFromApi();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        splashColor: MyColors.lightBrown,
                        elevation: 5,
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: Text(
                          "أعد المحاوله",
                          style: GoogleFonts.noticiaText(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Image.asset(
                        pray_icon,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.7,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (state is PrayTimeLoadingFetchData) {
          return Scaffold(
            // floatingActionButton: customFloatingActionButton(context),
            body: SafeArea(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  const BackGroundWidget(),
                  const CustomLoadingPage(),
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    pray_icon,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
