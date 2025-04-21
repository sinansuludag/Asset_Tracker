import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(commonUserProvider).user;
    usernameController = TextEditingController(text: user.username);
    emailController = TextEditingController(text: user.email);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final textTheme = context.textTheme;
    final user = ref.watch(commonUserProvider).user;

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
                Text('Hesap Bilgileri',
                    style: textTheme.headlineMedium?.copyWith(
                      color: color.onSecondary,
                    )),
                SizedBox(height: MediaQuerySize(context).percent2Height),
                Center(
                  child: Hero(
                    tag: 'AccountInfo',
                    child: Container(
                      width: MediaQuerySize(context).percent35Width,
                      height: MediaQuerySize(context).percent35Width,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'defaultUser'.png,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuerySize(context).percent3Height),
                accountInfoTextFormField(
                    context, 'Kullanıcı Adı', usernameController),
                SizedBox(height: MediaQuerySize(context).percent2Height),
                accountInfoTextFormField(context, 'E-posta', emailController),
                SizedBox(height: MediaQuerySize(context).percent4Height),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuerySize(context).percent7Height,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color.primary,
                      foregroundColor: color.onPrimary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.defaultBorderRadius,
                      ),
                    ),
                    onPressed: ref.watch(commonUserProvider).isLoading
                        ? null
                        : () async {
                            final notifier =
                                ref.read(commonUserProvider.notifier);

                            final updatedUser = UserModel(
                              id: user.id,
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              password: user.password, // şifre değişmiyor
                            );

                            await notifier.updateUserProfile(updatedUser);

                            if (ref.watch(commonUserProvider).hasError) {
                              if (context.mounted) {
                                context.showSnackBar(
                                    'Hata oluştu. Lütfen tekrar deneyin.');
                              }
                            } else {
                              if (context.mounted) {
                                context.showSnackBar(
                                    'Hesap bilgileri başarıyla güncellendi!');
                              }
                            }
                          },
                    child: ref.watch(commonUserProvider).isLoading
                        ? CircularProgressIndicator(
                            color: context.colorScheme.onPrimary,
                            strokeWidth: 2,
                          )
                        : const Text('Kaydet'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget accountInfoTextFormField(BuildContext context, String labelText,
      TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSecondary.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      child: Padding(
        padding: AppPaddings.allLowPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                labelText,
                style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Bilgiyi girin',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
