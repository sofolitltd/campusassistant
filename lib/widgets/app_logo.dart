import 'package:material_ui/material_ui.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/splash.png', height: 36));
  }
}
