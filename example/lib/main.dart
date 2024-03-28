import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/network_capture.dart';

final navGK = GlobalKey<NavigatorState>();

void main() {
  runApp(NetworkCaptureApp(
    navigatorKey: navGK,
    enable: true,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Capture',
      navigatorKey: navGK,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'NetworkCapture'),
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
  String result = '';
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio()..interceptors.add(CaptureDioInterceptor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _get(),
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: const Text(
                      'Get网络请求',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _post(),
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: const Text(
                      'Post网络请求',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('请求结果: $result'),
            ),
          ],
        ),
      ),
    );
  }

  void _get() {
    dio.get('https://www.wanandroid.com/banner/json',
        queryParameters: {'id': '323', 'name': 'azhon'}).then((value) {
      setState(() {
        result = value.toString();
      });
    });
  }

  void _post() {
    dio.post('https://www.wanandroid.com/user/login',
        data: {'username': 'a_zhon', 'password': '12345'}).then((value) {
      setState(() {
        result = value.toString();
      });
    });
  }
}
