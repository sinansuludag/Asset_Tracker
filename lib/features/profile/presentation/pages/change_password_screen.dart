import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = true;
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonUserNotifier = ref.read(commonUserProvider.notifier);
    final isLoading = ref.watch(commonUserProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPaddings.horizontalSimetricDefaultPadding,
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Şifre Değiştir',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: context.colorScheme.onSecondary,
                    )),
                SizedBox(height: MediaQuerySize(context).percent5Height),

                // Mevcut Şifre
                accountInfoTextFormField(
                  context,
                  'Mevcut Şifre',
                  'Mevcut Şifrenizi Giriniz',
                  _currentPasswordController,
                  _isCurrentPasswordVisible,
                  () => setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  }),
                ),
                SizedBox(height: MediaQuerySize(context).percent2Height),

                // Yeni Şifre
                accountInfoTextFormField(
                  context,
                  'Yeni Şifre',
                  'Yeni Şifrenizi Girin',
                  _newPasswordController,
                  _isNewPasswordVisible,
                  () => setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  }),
                ),
                SizedBox(height: MediaQuerySize(context).percent2Height),

                // Yeni Şifre Tekrar
                accountInfoTextFormField(
                  context,
                  'Yeni Şifre (Tekrar)',
                  'Yeni Şifrenizi tekrar girin',
                  _confirmPasswordController,
                  _isConfirmPasswordVisible,
                  () => setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }),
                ),

                SizedBox(height: MediaQuerySize(context).percent4Height),

                // Kaydet Butonu
                SizedBox(
                  width: double.infinity,
                  height: MediaQuerySize(context).percent7Height,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                      foregroundColor: context.colorScheme.onPrimary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.defaultBorderRadius,
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            final current = _currentPasswordController.text;
                            final newPass = _newPasswordController.text;
                            final confirm = _confirmPasswordController.text;

                            final isVerified = await commonUserNotifier
                                .verifyCurrentPassword(current);

                            if (!isVerified) {
                              context.showSnackBar(
                                  'Mevcut şifreniz yanlış. Lütfen kontrol edin.',
                                  Icons.error_outline,
                                  AppColors.error);
                              return;
                            }

                            if (current == newPass) {
                              context.showSnackBar(
                                  'Yeni şifre mevcut şifreyle aynı olamaz.',
                                  Icons.error_outline,
                                  AppColors.error);
                              return;
                            }

                            if (newPass != confirm) {
                              context.showSnackBar(
                                  'Yeni şifreler eşleşmiyor, lütfen kontrol edin.',
                                  Icons.error_outline,
                                  AppColors.error);
                              return;
                            }

                            await commonUserNotifier
                                .updateUserPassword(newPass);

                            if (ref.read(commonUserProvider).hasError) {
                              context.showSnackBar(
                                  'Şifre güncellenirken bir hata oluştu.',
                                  Icons.error_outline,
                                  AppColors.error);
                            } else {
                              context.showSnackBar(
                                  'Şifre başarıyla güncellendi!',
                                  Icons.check_circle_outline,
                                  AppColors.success);
                            }
                          },
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: context.colorScheme.onPrimary,
                            strokeWidth: 2)
                        : const Text('Kaydet'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextFormField with toggle visibility
  Container accountInfoTextFormField(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController controller,
    bool isPasswordVisible,
    VoidCallback onToggleVisibility,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      child: Padding(
        padding: AppPaddings.allLowPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              labelText,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextFormField(
              controller: controller,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
