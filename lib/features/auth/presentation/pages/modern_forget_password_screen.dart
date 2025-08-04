import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Gap(60.h),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FadeInLeft(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withAlpha(75),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20.r,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Gap(20.h),

                  // Logo and title
                  const ModernAuthLogo(
                    title: TrStrings.forgetPasswordScreenTitle,
                    subtitle: "Şifrenizi sıfırlayın",
                  ),

                  Gap(40.h),

                  // Form card
                  _buildFormCard(context, ref),

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

  Widget _buildFormCard(BuildContext context, WidgetRef ref) {
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
              "Şifre Sıfırlama",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            Gap(8.h),

            Text(
              TrStrings.forgetPasswordScreenText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(200),
              ),
              textAlign: TextAlign.center,
            ),

            Gap(30.h),

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

            Gap(30.h),

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
        padding: EdgeInsets.all(AppDimensions.spaceM.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withAlpha(50),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TrStrings.fogetPasswordScreenNoAccountText,
              style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontSize: 15.sp,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.register);
              },
              child: Text(
                TrStrings.signUp,
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
