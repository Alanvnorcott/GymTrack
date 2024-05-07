//onboarding_page.dart
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'main.dart';


final pages = [
  const PageData(
    icon: Icons.sports_gymnastics_rounded,
    title: "Track your workouts!",
    bgColor: Color(0xff6200ee),
    textColor: Colors.white,
  ),
  const PageData(
    icon: Icons.map_outlined,
    title: "Find new gyms!",
    bgColor: Color(0xffe85d04),
    textColor: Color(0xff6200ee),
  ),
  const PageData(
    icon: Icons.face_retouching_natural_sharp,
    title: "Become a better you!",
    bgColor: Color(0xff6200ee),
    textColor: Color(0xffffffff),
  ),
];

class ConcentricAnimationOnboarding extends StatefulWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  _ConcentricAnimationOnboardingState createState() =>
      _ConcentricAnimationOnboardingState();
}

class _ConcentricAnimationOnboardingState
    extends State<ConcentricAnimationOnboarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 99900),
    );
    _animationController.forward().whenComplete(() {
      setState(() {
        _animationCompleted = true;
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animationCompleted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: !_animationCompleted
          ? ConcentricPageView(
        colors: pages.map((p) => p.bgColor).toList(),
        radius: screenWidth * 0.1,
        nextButtonBuilder: (context) => Padding(
          padding: const EdgeInsets.only(left: 3), // visual center
          child: Icon(
            Icons.navigate_next,
            size: screenWidth * 0.08,
          ),
        ),
        // enable itemcount to disable infinite scroll
        //itemCount: pages.length,
        scaleFactor: 2,
        itemBuilder: (index) {
          final page = pages[index % pages.length];
          return SafeArea(
            child: _Page(page: page, currentIndex: index),
          );
        },
      )
          : _GetStartedButton(),
    );
  }
}

class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class _Page extends StatelessWidget {
  final PageData page;
  final int currentIndex;

  const _Page({Key? key, required this.page, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: page.textColor),
          child: Icon(
            page.icon,
            size: screenHeight * 0.1,
            color: page.bgColor,
          ),
        ),
        Text(
          page.title ?? "",
          style: TextStyle(
              color: page.textColor,
              fontSize: screenHeight * 0.035,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        // Render the "Get Started" button on the last page
        if (currentIndex == pages.length - 1) _GetStartedButton(),
      ],
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the home screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleBottomNavigation(),
            ),
          );
        },
        child: Text('Get Started'),
      ),
    );
  }
}
