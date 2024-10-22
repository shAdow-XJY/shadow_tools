import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shadow Online Tools',
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 存储当前选中的栏目索引
  int _selectedIndex = 0;

  // 模拟数据
  final List<List<String>> _items = [
    ['Item 1A', 'Item 1B', 'Item 1C'],
    ['Item 2A', 'Item 2B', 'Item 2C'],
    ['Item 3A', 'Item 3B', 'Item 3C'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shadow Online Tools'),
        actions: <Widget>[
          IconButton(
            icon: const ImageIcon(AssetImage('assets/images/GitHub.png')),
            onPressed: () {
              launchUrl(Uri.parse('https://github.com/shAdow-XJY/shadow_tools'));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, 'File'),
                _buildNavItem(1, 'Compute'),
                _buildNavItem(2, 'Other'),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _items[_selectedIndex]
            .map((item) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(item),
          ),
        ))
            .toList(),
      ),
    );
  }

  // 导航栏选项构建
  Widget _buildNavItem(int index, String title) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.greenAccent : Colors.black,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
