import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/strings/locale/tr_strings.dart';
import '../../../../core/constants/dimensions/app_dimensions.dart';
import '../../../../core/mixins/screen_mixin/forget_password_screen_mixin.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/validator/auth_validator/email_validator.dart';

import '../widgets/modern_auth_background.dart';
import '../widgets/modern_auth_logo.dart';
import '../widgets/modern_text_field.dart';
import '../widgets/modern_auth_button.dart';

class ModernForgetPasswordScreen extends ConsumerWidget
    with ForgetPasswordScreenMixin {
  ModernForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ModernAuthBackground(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceL,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Gap(60),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInLeft(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Gap(20),

                  // Logo and title
                  ModernAuthLogo(
                    title: TrStrings.forgetPasswordScreenTitle,
                    subtitle: "Şifrenizi sıfırlayın",
                  ),

                  const Gap(40),

                  // Form card
                  _buildFormCard(context, ref),

                  const Gap(30),

                  // Footer
                  _buildFooter(context),

                  const Gap(40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(BuildContext context, WidgetRef ref) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.authCardRadius),
          color: Colors.white.withOpacity(0.15),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Şifre Sıfırlama",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const Gap(8),

            Text(
              TrStrings.forgetPasswordScreenText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            const Gap(30),

            // Email field
            ModernTextField(
              label: TrStrings.labelEmail,
              hint: TrStrings.hintTextEmail,
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              validator: EmailValidator.emailValidate,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),

            const Gap(30),

            // Send reset email button
            ModernAuthButton(
              text: TrStrings.forgetPasswordScreenButtonText,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  forgetPasswordButton(context, ref);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TrStrings.fogetPasswordScreenNoAccountText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.register);
              },
              child: Text(
                TrStrings.signUp,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
