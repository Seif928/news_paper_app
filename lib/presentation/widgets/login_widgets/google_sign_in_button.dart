// presentation/widgets/auth_widgets/google_sign_in_button.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    context.locale;

    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.onSurface,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo\'s/Google__G__logo.svg.webp',
                      width: 20,
                      height: 20,
                      errorBuilder:
                          (_, __, ___) => Icon(
                            Icons.g_mobiledata,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'continue with google'.tr(),
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
