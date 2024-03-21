import 'package:e_commerce/utils/exports.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget(
      {super.key,
      required this.title,
      this.bottomPadding = 70,
      this.topPadding = 20,
      this.fontSize = 36});
  final String title;
  final double bottomPadding;
  final double topPadding;

  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding, top: topPadding),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF222222),
          fontSize: fontSize,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.w900,
        ),
      ),
    ).animate().slideY().fade();
  }
}
