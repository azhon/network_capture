import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:network_capture/network_capture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NetWorkCaptureInit(
        child: MyHomePage(title: 'NetWorkCapture'),
      ),
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
          children: [
            GestureDetector(
              onTap: () => _get(),
              child: Container(
                color: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: const Text(
                  '网络请求',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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
    Dio()
        .get('http://www.wanandroid.com/banner/json?id=323&name=zhon')
        .then((value) {
      setState(() {
        result = value.toString();
      });
    });
  }
}
