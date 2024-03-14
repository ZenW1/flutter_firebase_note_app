import 'package:flutter/material.dart';

class TestPageLgLg extends StatefulWidget {
  const TestPageLgLg({super.key});

  @override
  State<TestPageLgLg> createState() => _TestPageLgLgState();
}

class _TestPageLgLgState extends State<TestPageLgLg> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  List<String> listImage = [
    // gerate image with different size
    'https://picsum.photos/250?image=9',
    'https://picsum.photos/250?image=10',
    'https://picsum.photos/250?image=11',
    'https://picsum.photos/250?image=12',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TestPage'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Container(
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemCount: listImage.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    listImage[index],
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitHeight,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
