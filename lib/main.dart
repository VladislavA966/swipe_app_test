import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //key: UniqueKey(),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = CardSwiperController();

  late PageController pageController;
  int currentPage = 0;

  List<int> cards = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
      ),
      body: makeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          reset();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  makeBody() {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: cards.isEmpty ? 1 : cards.length,
      controller: pageController,
      onPageChanged: (page) {
        setState(() => currentPage = page);
      },
      itemBuilder: (context, index) {
        if (cards.isEmpty) {
          return makeFinish();
        }
        if (index == currentPage || cards.length == 1) {
          return makeMainItem(context, index);
        }
        return makeItem(context, index);
      },
    );
  }

  makeFinish() {
    return Container(
      color: Colors.grey,
      child: const Center(
        child: Text("FINISH"),
      ),
    );
  }

  makeItem(context, index) {
    return Container(
      margin: const EdgeInsets.all(12),
      color: Colors.indigo,
      child: Center(
        child: Text("PAGE${cards[index]}"),
      ),
    );
  }

  makeMainItem(context, rootIndex) {
    int nextCard = rootIndex + 1;
    if (nextCard >= cards.length) {
      if (cards.length > 1) {
        nextCard = rootIndex - 1;
      } else {
        nextCard = -1;
      }
    }
    return CardSwiper(
      controller: controller,
      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
        horizontal: true,
        vertical: false,
      ),
      cardsCount: 2,
      onSwipe: (previousIndex, currentIndex, direction) {
        setState(() => cards.removeAt(rootIndex));
        return false;
      },
      //onUndo: _onUndo,
      numberOfCardsDisplayed: 2,
      backCardOffset: const Offset(0, 0),
      padding: const EdgeInsets.all(0),
      cardBuilder: (context, index, horizontalThresholdPercentage,
          verticalThresholdPercentage) {
        if (index == 0) {
          return makeItem(context, rootIndex);
        } else {
          if (nextCard >= 0) {
            return makeItem(context, nextCard);
          }
          return makeFinish();
        }
        //
        // var card = rootIndex + index;
        // if (card >= cards.length) {
        //   if (cards.length > 1) {
        //     card = rootIndex - index;
        //   } else {
        //     return makeFinish();
        //   }
        // }
        // return makeItem(context, card);
      },
    );
  }

  reset() {
    cards = List.generate(10, (index) {
      return index + 1;
    });
    setState(() {
      currentPage = 0;
      pageController.jumpToPage(currentPage);
    });
  }
}
