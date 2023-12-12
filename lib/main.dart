import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Offset offset = const Offset(0, 0);
  late AnimationController _animationControllerScale;
  late AnimationController _animationControllerStegger;
  late Animation _animationScale;
  late Animation<Offset> _animationSlideIcon;
  late Animation<double> _animationOpacity;
  late Animation<double> _animationSizeWidth;
  late Animation<double> _animationSizeHeight;

  @override
  void initState() {
    super.initState();
    _animationControllerScale = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        setState(() {});
      });
    _animationScale = Tween<double>(begin: 0.0, end: 1).animate(CurvedAnimation(
        parent: _animationControllerScale, curve: Curves.linear));
    _animationControllerScale.forward();

    //steggered Animation Controller:
    _animationControllerStegger =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            setState(() {});
          });
    _animationSlideIcon = Tween<Offset>(
            begin: Offset(offset.dx - 0.35, offset.dy),
            end: Offset(offset.dx + 0.4, offset.dy))
        .animate(CurvedAnimation(
            parent: _animationControllerStegger,
            curve: const Interval(0.0, 0.2)));
    _animationOpacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: _animationControllerStegger, curve: const Interval(0.2, 0.4)));
    _animationSizeWidth = Tween<double>(begin: 300, end: 600).animate(
        CurvedAnimation(
            parent: _animationControllerStegger,
            curve: const Interval(0.4, 0.6)));
    _animationSizeHeight = Tween<double>(begin: 70, end: 1000).animate(
        CurvedAnimation(
            parent: _animationControllerStegger,
            curve: const Interval(0.4, 0.6)));
  }

  @override
  void dispose() {
    _animationControllerScale.dispose();
    _animationControllerStegger.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    _animationControllerStegger.reverse();
  }

  void _steggeredStart() {
    _animationControllerStegger.forward();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/earth1.jpg'))),
          child: Transform(
            transform: Matrix4.identity()..scale(_animationScale.value),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: Width * 0.07,
                  top: height * 0.5,
                  child: const Text(
                    'Welcome Back',
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: Width * 0.07,
                  top: height * 0.65,
                  child: SizedBox(
                    width: Width * 0.4,
                    height: height * 0.15,
                    child: const Text(
                      'We will provide you the most anticipated offers that you never thought! ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.7),
                  child: InkWell(
                    onTap: _steggeredStart,
                    onDoubleTap: _incrementCounter,
                    child: Container(
                      height: _animationSizeHeight.value,
                      width: _animationSizeWidth.value,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60)),
                      child: Opacity(
                        opacity: _animationOpacity.value,
                        child: SlideTransition(
                          position: _animationSlideIcon,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 70,
                            weight: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
