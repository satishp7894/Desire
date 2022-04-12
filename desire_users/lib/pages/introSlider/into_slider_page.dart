import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _introSliderPageState createState() => _introSliderPageState();
}

class _introSliderPageState extends State<IntroSliderPage> {
  SwiperController controller = SwiperController();
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Stack(
        children: [
          Swiper(
            scrollDirection: Axis.horizontal,
            indicatorLayout: PageIndicatorLayout.SCALE,
            controller: controller,
            loop: false,
            control: new SwiperControl(color: kPrimaryColor, iconNext: Icons.arrow_forward, iconPrevious: Icons.arrow_back, size: 20, padding:EdgeInsets.all(10) ),
            itemBuilder: (BuildContext context, int index) {
              return Image.asset(
                index == 0
                    ? "assets/images/intro_1.jpg"
                    : index == 1
                        ? "assets/images/intro_2.jpg"
                        : index == 2
                            ? "assets/images/intro_3.jpg"
                            : "assets/images/intro_4.jpg",
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.contain,
              );
            },
            itemCount: 4,
          ),
          Positioned(
            bottom: 50,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (builder) => NewLoginPage()),
                          (route) => false);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  /*TextButton(
                      onPressed: () {
                        controller.next(animation: true);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                           "Next",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: kPrimaryColor,
                            size: 30,
                          )
                        ],
                      ))*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
