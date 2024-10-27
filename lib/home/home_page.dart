import 'package:flutter/material.dart';
import 'package:shadow_tools/config/st_config_global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import '../pages/page_entry.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OverlayEntry? _overlayEntry;
  final GlobalKey _navKey1 = GlobalKey();
  final GlobalKey _navKey2 = GlobalKey();
  final GlobalKey _navKey3 = GlobalKey();
  bool _isHoveredOverList = false; // 用于检测鼠标是否在浮窗上
  bool _isHoveredOverItem = false;
  final ScrollController _scrollController = ScrollController(); // 用于监听滚动事件
  String selectedText = "Please select an option";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 显示浮窗
  void _showFloatingList(BuildContext context, GlobalKey key, String component) {
    _hideFloatingList(); // 显示新的浮窗前移除旧的

    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    const alertWidth = 200.0;
    List<String> componentList = STConfigGlobal.getListWithComponent(component);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx,
          top: AppBar().preferredSize.height, // 使用动态获取的 SliverAppBar 高度
          width: alertWidth,
          child: MouseRegion(
            onEnter: (_) {
              _isHoveredOverList = true;
            },
            onExit: (_) {
              _isHoveredOverList = false;
              _hideFloatingList(); // 鼠标离开浮窗时隐藏
            },
            child: Material(
              elevation: 4.0,
              child: Container(
                width: alertWidth,
                height: 150, // 控制浮窗的高度
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: ListView.builder(
                  itemCount: componentList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(componentList[index]),
                      onTap: () {
                        setState(() {
                          selectedText = componentList[index]; // 更新选中的文字
                        });
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
  // 隐藏浮窗
  void _hideFloatingList() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 导航栏组件
  Widget _buildNavItem(String title, GlobalKey key) {
    return MouseRegion(
      onEnter: (event) {
        _isHoveredOverItem = true;
        _showFloatingList(context, key, title); // 显示浮窗
      },
      onExit: (event) {
        _isHoveredOverItem = false;
        Future.delayed(const Duration(milliseconds: 100), () {
          if (!_isHoveredOverList && !_isHoveredOverItem) {
            _hideFloatingList(); // 如果鼠标没有移入浮窗或其他导航栏项目，则隐藏浮窗
          }
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showFloatingList(context, key, title); // 显示浮窗
        },
        child: SizedBox(  // 用 Container 包裹，指定高度为导航栏的高度
          height: AppBar().preferredSize.height, // 设置 hover 区域的高度为导航栏高度
          child: Row(
            key: key,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              const Icon(Icons.arrow_drop_down), // 下拉箭头图标
            ],
          ),
        ),
      ),
    );
  }

  // 构建上方按钮容器
  Widget _buildButtonContainer() {
    List<String> buttons = STConfigGlobal.getAllItems();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 10, // 按钮之间的间距
        runSpacing: 10, // 行之间的间距
        children: buttons.map((buttonText) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                selectedText = buttonText; // 更新选中的文字
              });
            },
            child: Text(buttonText),
          );
        }).toList(),
      ),
    );
  }

  // 构建动态显示区域
  Widget _buildTextDisplay(String text) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey.shade200,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 在页面其他区域点击时隐藏浮窗
      onTap: () {
        _hideFloatingList();
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController, // 绑定 ScrollController
          slivers: [
            // 使用 SliverAppBar 作为滚动导航栏
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              expandedHeight: 0.0, // AppBar 扩展高度
              floating: true, // 设置为 true，使其在向下滚动时消失
              pinned: false, // 不固定在顶部
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // 让标题居中对齐
                titlePadding: const EdgeInsetsDirectional.only(start: 0, bottom: 0), // 移除底部的空白
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // 你可以根据需要调整 padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 左边图标和标题
                      Row(
                        children: [
                          IconButton(
                            icon: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar.png',
                                width: 32,
                                height: 32,
                                fit: BoxFit.cover, // 适应图像填充
                              ),
                            ),
                            onPressed: () {
                              // 刷新当前网页
                              html.window.location.reload();
                            },
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Shadow Tools',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // 中间三个组件
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNavItem(STConfigGlobal.fileComponent, _navKey1),
                          const SizedBox(width: 20),
                          _buildNavItem(STConfigGlobal.convertComponent, _navKey2),
                          const SizedBox(width: 20),
                          _buildNavItem(STConfigGlobal.otherComponent, _navKey3),
                        ],
                      ),
                      // 右边图标
                      IconButton(
                        icon: const ImageIcon(AssetImage('assets/images/GitHub.png')),
                        onPressed: () {
                          launchUrl(Uri.parse('https://github.com/shAdow-XJY/shadow_tools'));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 按钮容器的内容
            SliverToBoxAdapter(
              child: _buildButtonContainer(),
            ),

            // 动态文字显示内容
            SliverToBoxAdapter(
              child: _buildTextDisplay(selectedText),
            ),

            // 主体内容
            SliverToBoxAdapter(
              child: STPageEntry.getWidgetWithType(selectedText),
            ),
          ],
        ),
      ),
    );
  }
}
