import 'package:e_commerce/utils/exports.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({super.key, required this.title, this.onTap});
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFFDB3022),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3FD32525),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ).animate().slideY().fade();
  }
}
