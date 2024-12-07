import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double? height;
  final Widget? buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    required this.textColor,
    this.height,
    this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: height ?? 50, // Varsayılan yükseklik
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 24, // İkonun genişliğini ayarla
                height: 24, // İkonun yüksekliğini ayarla
                child: FittedBox(child: buttonIcon), // İkonu ölçeklendir
              ),
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              Opacity(opacity: 0, child: buttonIcon)
            ],
          ),
        ),
      ),
    );
  }
}
