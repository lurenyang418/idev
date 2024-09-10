import 'package:go_router/go_router.dart';
import 'package:idev/ui/drop_file.dart';
import 'package:idev/ui/json_formatter.dart';

class AppRoutes {
  static const String homePath = "/";
  static const String picPath = "/pic";
  // static const String thirdPath = "/third";

  static const String homeNamed = "home_page";
  static const String picNamed = "pic_page";
  // static const String thirdNamed = "third_page";

  GoRouter router = GoRouter(
    initialLocation: homePath,
    routes: [
      GoRoute(
        name: homeNamed,
        path: homePath,
        builder: (context, state) => const FormatterPage(),
      ),
       GoRoute(
        path: picPath,
        name: picNamed,
        builder: (context, state) => const DropFilePage(),
      ),
    ],
  );
}
