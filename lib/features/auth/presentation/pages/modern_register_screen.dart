import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/strings/locale/tr_strings.dart';
import '../../../../core/constants/dimensions/app_dimensions.dart';
import '../../../../core/mixins/screen_mixin/register_screen_mixin.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/utils/validator/auth_validator/email_validator.dart';
import '../../../../core/utils/validator/auth_validator/password_validator.dart';
import '../../../../core/utils/validator/auth_validator/username_validator.dart';

import '../widgets/modern_auth_background.dart';
import '../widgets/modern_auth_logo.dart';
import '../widgets/modern_text_field.dart';
import '../widgets/modern_auth_button.dart';

class ModernRegisterScreen extends ConsumerWidget with RegisterScreenMixin {
    ModernRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FocusNode'ları tanımla
    final usernameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final passwordFocusNode = FocusNode();

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

                  // Logo and title
                  ModernAuthLogo(
                    title: TrStrings.signUp,
                    subtitle: "Ücretsiz hesabınızı oluşturun",
                  ),

                  const Gap(40),

                  // Form card
                  _buildFormCard(context, ref, usernameFocusNode,
                      emailFocusNode, passwordFocusNode),

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

  Widget _buildFormCard(
      BuildContext context,
      WidgetRef ref,
      FocusNode usernameFocusNode,
      FocusNode emailFocusNode,
      FocusNode passwordFocusNode) {
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
              "Başlayalım",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const Gap(8),

            Text(
              "Yeni hesap oluşturun",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
              ),
            ),

            const Gap(30),

            // Username field
            ModernTextField(
              label: TrStrings.labelUsername,
              hint: TrStrings.hintTextUsername,
              prefixIcon: Icons.person_outline,
              controller: usernameController,
              validator: UsernameValidator.usernameValidate,
              textInputAction: TextInputAction.next,
              focusNode: usernameFocusNode,
              nextFocusNode: emailFocusNode,
            ),

            const Gap(20),

            // Email field
            ModernTextField(
              label: TrStrings.labelEmail,
              hint: TrStrings.hintTextEmail,
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              validator: EmailValidator.emailValidate,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              focusNode: emailFocusNode,
              nextFocusNode: passwordFocusNode,
            ),

            const Gap(20),

            // Password field
            ModernTextField(
              label: TrStrings.labelPassword,
              hint: TrStrings.hintTextPassword,
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: passwordController,
              validator: PasswordValidator.passwordValidate,
              textInputAction: TextInputAction.done,
              focusNode: passwordFocusNode,
              onEditingComplete: () {
                // Son field olduğu için klavyeyi kapat ve register yap
                FocusScope.of(context).unfocus();
                if (formKey.currentState!.validate()) {
                  registerButton(context, ref);
                }
              },
            ),

            const Gap(30),

            // Register button
            ModernAuthButton(
              text: TrStrings.signUp,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  registerButton(context, ref);
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
              TrStrings.textForGoToLogin,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 15,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.login);
              },
              child: Text(
                TrStrings.signIn,
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
