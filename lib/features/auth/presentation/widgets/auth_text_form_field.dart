import 'package:e_commerce/utils/exports.dart';

class AuthTextFormField extends StatelessWidget {
  const AuthTextFormField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscure = false,
    this.validator,
    required this.isValid,
    this.suffixIcon,
  });
  final TextEditingController? controller;
  final String hintText;
  final bool obscure;
  final String? Function(String?)? validator;
  final bool? isValid;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        controller!.text = value.toString();
        controller!.selection =
            TextSelection.collapsed(offset: controller!.text.length);
      },
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF9B9B9B),
            fontSize: 14,
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.w500,
            height: 0.10,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(4),
          ),
          suffixIcon: suffixIcon),
      obscureText: obscure,
      validator: validator,
    );
  }
}
