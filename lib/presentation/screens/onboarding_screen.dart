import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:temu/presentation/screens/onboarding/onboarding_free.dart';
import 'package:temu/presentation/screens/onboarding/onboarding_one.dart';
import 'package:temu/presentation/screens/onboarding/onboarding_two.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool onLastPage = false;
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index){
              setState(() {
                onLastPage = (index == 2);
              });
            },
            controller: _controller,
            children: [
              OnboardingOne(),
              OnboardingTwo(),
              OnboardingFree()],
          ),
          GestureDetector(
            onTap: (){
              _controller.jumpToPage(2);
              },
            child: Container(
              alignment: Alignment(0, 0.90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip button
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepOrange, width: 2),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('Skip', style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SmoothPageIndicator(
                      controller: _controller, count: 3,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      type: WormType.normal,
                      spacing: 8,
                      dotColor: Colors.grey.shade400,
                      activeDotColor: Colors.deepOrangeAccent
                    ),
                  ),
                  onLastPage ?
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Get started', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ) :
                  GestureDetector(
                    onTap: (){
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Suivant', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
