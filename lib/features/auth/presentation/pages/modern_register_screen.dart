import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceL.r,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Gap(50.h),

                  // Logo and title
                  const ModernAuthLogo(
                    title: TrStrings.signUp,
                    subtitle: "Ücretsiz hesabınızı oluşturun",
                  ),

                  Gap(30.h),

                  // Form card
                  _buildFormCard(context, ref, usernameFocusNode,
                      emailFocusNode, passwordFocusNode),

                  Gap(30.h),

                  // Footer
                  _buildFooter(context),

                  Gap(40.h),
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
        padding: EdgeInsets.all(AppDimensions.spaceL.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.authCardRadius.r),
          color: Colors.white.withAlpha(35),
          border: Border.all(
            color: Colors.white.withAlpha(50),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
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
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            Gap(8.h),

            Text(
              "Yeni hesap oluşturun",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(200),
              ),
            ),

            Gap(30.h),

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

            Gap(20.h),

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

            Gap(20.h),

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

            Gap(30.h),

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
        padding: EdgeInsets.all(AppDimensions.spaceM.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withAlpha(50),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TrStrings.textForGoToLogin,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 14.sp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.login);
              },
              child: Text(
                TrStrings.signIn,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
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
