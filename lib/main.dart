import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:idev/ui/b64_image.dart';
// import 'package:idev/router.dart';
import 'package:idev/ui/drop_file.dart';
import 'package:idev/ui/hash.dart';
import 'package:idev/ui/index.dart';
import 'package:idev/ui/json_formatter.dart';
import 'package:idev/ui/qr.dart';
import 'package:idev/ui/sqlite.dart';
import 'package:window_manager/window_manager.dart';

/// Flutter code sample for [NavigationRail].

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1080, 960),
    minimumSize: Size(960, 720),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    // titleBarStyle: TitleBarStyle.hidden,
    // windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const NavigationRailExampleApp());
}

class NavigationRailExampleApp extends StatelessWidget {
  const NavigationRailExampleApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     title: "idev",
  //     theme: ThemeData(primarySwatch: Colors.blue),
  //     routerConfig: AppRoutes().router,
  //   );
  // }
  Widget build(BuildContext context) {
    final virtualWindowFrameBuilder = VirtualWindowFrameInit();
    final botToastBuilder = BotToastInit();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const NavRailExample(),
        builder: (context, child) {
          child = virtualWindowFrameBuilder(context, child);
          child = botToastBuilder(context, child);
          return child;
        },
        navigatorObservers: [BotToastNavigatorObserver()]);
  }
}

class NavRailExample extends StatefulWidget {
  const NavRailExample({super.key});

  @override
  State<NavRailExample> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends State<NavRailExample> {
  double groupAlignment = -1.0;
  bool extended = false;

  final PageController _controller = PageController();
  final ValueNotifier<int> _selectIndex = ValueNotifier(0);

  void _onDestinationSelected(int value) {
    _controller.jumpToPage(value); // tag1
    _selectIndex.value = value; //tag2
  }

  @override
  void dispose() {
    _controller.dispose();
    _selectIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: _selectIndex,
              builder: (_, index, __) => _buildLeftNavigation(index),
            ),
            const VerticalDivider(
              thickness: 10,
              width: 10,
              // color: Colors.pink,
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                // 禁止滚动
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  IndexPage(),
                  FormatterPage(),
                  DropFilePage(),
                  QrPage(),
                  HashPage(),
                  SqlitePage(),
                  B64Image(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftNavigation(index) {
    return NavigationRail(
      leading: extended
          ? IconButton(
              onPressed: () => {
                    setState(() {
                      extended = !extended;
                    })
                  },
              icon: const Icon(Icons.menu))
          : IconButton(
              onPressed: () => {
                setState(() {
                  extended = !extended;
                })
              },
              icon: const Icon(
                Icons.menu_open,
                color: Colors.grey,
              ),
            ),
      // minExtendedWidth: 80,
      selectedIndex: index,
      groupAlignment: groupAlignment,
      onDestinationSelected: _onDestinationSelected,
      labelType: NavigationRailLabelType.none,
      extended: extended,
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ),
      ),
      destinations: const <NavigationRailDestination>[
         NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_outlined),
          label: Text('启动页'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.javascript),
          selectedIcon: Icon(Icons.javascript_outlined),
          label: Text('JSON格式化'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.today),
          selectedIcon: Icon(Icons.today_outlined),
          label: Text('图片'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.qr_code),
          selectedIcon: Icon(Icons.qr_code_outlined),
          label: Text('QRCode'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.no_encryption),
          selectedIcon: Icon(Icons.no_encryption_outlined),
          label: Text('Hash'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.table_rows),
          selectedIcon: Icon(Icons.table_rows_outlined),
          label: Text('SQLite'),
        ),
         NavigationRailDestination(
          icon: Icon(Icons.image),
          selectedIcon: Icon(Icons.image_outlined),
          label: Text('B64Image'),
        ),
      ],
    );
  }
}
