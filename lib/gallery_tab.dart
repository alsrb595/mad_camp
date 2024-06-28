import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Tab 1'),
//             Tab(text: 'Tab 2'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: const [
//           Tab1(),
//           Tab2(),
//         ],
//       ),
//     );
//   }
// }
//
// class Tab1 extends StatelessWidget {
//   const Tab1({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(25.0),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 10.0,
//           mainAxisSpacing: 10.0,
//         ),
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           return Container(
//             color: Colors.blue,
//             child: const Center(
//               child: Text(
//                 'Item',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class GalleryTab extends StatelessWidget {
  const GalleryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/1.jpg',
      'assets/images/2.jpg',
      'assets/images/3.jpg',
      'assets/images/4.jpg',
      'assets/images/5.jpg',
      'assets/images/6.jpg',
    ];
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            //color: Colors.white,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              // bottomLeft: Radius.circular(30),
              // bottomRight: Radius.circular(30)),
              image: DecorationImage(
                image: AssetImage(images[index]),
                fit: BoxFit.cover,
                // child: Center(
                //   child: Image.asset(
                //     images[index],
                //     fit: BoxFit.cover,
                // child: Text(
                //   'Item',
                //   style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
