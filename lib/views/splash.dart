import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:projectx/views/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isActive ? 13.0 : 13.0,
      width: isActive ? 13.0 : 13.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.orange : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(360)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        //backgroundColor: AppColors.background,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                ),
                SizedBox(
                  height: screenHeight * 0.7,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      getPageSection(Icons.money_off_csred_rounded,
                          'Track Debt', 'Know which people you owe money so that you can pay it back right in time.', screenHeight),
                      getPageSection(Icons.money_rounded, 'Track Credit',
                          'Know who owes you money so that you remember to get it back.', screenHeight),
                      getPageSection(Icons.security_rounded, 'Stay in Control',
                          'Take complete control of your finances like never before', screenHeight)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: TextButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.ease);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: AppColors.background,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          color: Colors.white,
          child: _currentPage == _numPages - 1
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Center(
                          child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white),
                      ))))
              : const Text(''),
        ));
  }

  // get different page sections
  Widget getPageSection(
      IconData image, String title, String description, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Icon(
            image,
            size: screenHeight * 0.35,
            color: AppColors.background,
          )),
          const SizedBox(height: 30.0),
          Text(title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
              textAlign: TextAlign.center),
          const SizedBox(height: 15.0),
          Text(description,
              style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
