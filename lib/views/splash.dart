import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectx/utils/styles.dart';
import 'package:projectx/values/app_colors.dart';

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
      height: isActive ? 13.0 : 10.0,
      width: isActive ? 13.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? AppColors.background : Colors.grey,
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
                  height: 15,
                ),
                Image.asset(
                  "assets/logo.jpg",
                  width: 60,
                  height: 63,
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
                      getPageSection('assets/logo.jpg', 'Track Debt',
                          '#############', screenHeight),
                      getPageSection('assets/logo.jpg', 'Track Credit',
                          '#############', screenHeight),
                      getPageSection(
                          'assets/logo.jpg',
                          'Stay in Control',
                          '##############',
                          screenHeight)
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.black,
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
                  onTap: () {},
                  child: Container(
                      height: 50.0,
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Center(
                          child: Text(
                        'GET STARTED',
                        style: TextStyle(color: Colors.white, letterSpacing: 2),
                      ))))
              : const Text(''),
        ));
  }

  // get different page sections
  Widget getPageSection(
      String image, String title, String description, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Image.asset(
            image,
            height: screenHeight * 0.4,
          )),
          const SizedBox(height: 30.0),
          Text(title, style: headerBlackMedium, textAlign: TextAlign.center),
          const SizedBox(height: 15.0),
          Text(
              'Get powerful insights on how your business has been performing and AI powered predictions.',
              style: headerBlackSmall,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
