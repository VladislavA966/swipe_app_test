import 'package:flutter/material.dart';

class CardSwiperTest extends StatefulWidget {
  @override
  _CardSwiperTestState createState() => _CardSwiperTestState();
}

class _CardSwiperTestState extends State<CardSwiperTest> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  final double _verticalThreshold = 20.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (details.delta.dy.abs() > details.delta.dx.abs() &&
        details.delta.dy.abs() > _verticalThreshold) {
      if (details.delta.dy > 0) {
        _moveToPage(_currentPageIndex - 1);
      } else {
        _moveToPage(_currentPageIndex + 1);
      }
    } else {
      _handleHorizontalSwipe(details);
    }
  }

  void _handleHorizontalSwipe(DragUpdateDetails details) {
    // Здесь будет логика для горизонтальных свайпов (свайп влево/вправо)
    // Реализуйте как в вашей библиотеке
  }

  void _moveToPage(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < 5 /*Количество страниц*/) {
      setState(() {
        _currentPageIndex = pageIndex;
      });
      _pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: 5, // Количество страниц
        itemBuilder: (context, index) {
          return Center(
            child: Card(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.blue,
                child: Center(child: Text('Page $index')),
              ),
            ),
          );
        },
      ),
    );
  }
}
