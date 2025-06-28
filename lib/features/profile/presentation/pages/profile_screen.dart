import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/colors/app_colors.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/assets_path_extension.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:asset_tracker/core/extensions/show_dialog_extension.dart';
import 'package:asset_tracker/core/extensions/snack_bar_extension.dart';
import 'package:asset_tracker/core/margins/margins.dart';
import 'package:asset_tracker/core/routing/route_names.dart';
import 'package:asset_tracker/core/services/user_service/state_management/riverpod/all_providers.dart';
import 'package:asset_tracker/core/utils/profile_screen_features/setting_info_list.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/auth_state_provider.dart';
import 'package:asset_tracker/features/auth/presentation/state_management/user_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(commonUserProvider);

    if (userState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurface.withAlpha(10),
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                ),
                margin: AppMargins.allLowMargins,
                height: MediaQuerySize(context).percent12Height,
                child: Padding(
                  padding: AppPaddings.allDefaultPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      profileImageWidget(context),
                      SizedBox(width: MediaQuerySize(context).percent2Width),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userState.user.username ?? 'Username',
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userState.user.email ?? 'Email',
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: context.colorScheme.onSecondary,
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Çıkış Yap'),
                                content: const Text(
                                    'Çıkış yapmak istediğinize emin misiniz?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('İptal'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await ref
                                          .read(authProvider.notifier)
                                          .signOut();
                                      context.showSnackBar(
                                          "Başarıyla çıkış yapıldı",
                                          Icons.check_circle_outline,
                                          AppColors.success);
                                      Navigator.pushNamed(
                                          context, RouteNames.login);
                                    },
                                    child: const Text('Çıkış Yap'),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            context.showSnackBar("Çıkış yaparken hata oluştu",
                                Icons.error_outline, AppColors.error);
                          }
                        },
                        icon: const Icon(Icons.exit_to_app),
                        color: context.colorScheme.onSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              settingContainerComponentWidget(
                  context, 'Hesap Ayarları', accountSettings(context)),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              settingContainerComponentWidget(
                  context, 'Uygulama Ayarları', appSettings(context, ref)),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              settingContainerComponentWidget(context,
                  'Destek ve Yasal Bilgiler', supportSettings(context)),
              SizedBox(height: MediaQuerySize(context).percent3Height),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileImageWidget(BuildContext context) {
    return Hero(
      tag: 'AccountInfo',
      child: Container(
        width: MediaQuerySize(context).percent15Width,
        height: MediaQuerySize(context).percent15Width,
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
    );
  }

  Widget settingContainerComponentWidget(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> settingsItems,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withAlpha(10),
        borderRadius: AppBorderRadius.defaultBorderRadius,
      ),
      margin: AppMargins.horizontalSimetricDefaultMargins,
      padding: AppPaddings.horizontalSimetricLowPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppPaddings.verticalSimetricLowPadding,
            child: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...List.generate(settingsItems.length, (index) {
            final item = settingsItems[index];
            return Column(
              children: [
                ClipRRect(
                  borderRadius: AppBorderRadius.defaultBorderRadius,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item['onTap'] as VoidCallback,
                      borderRadius: AppBorderRadius.lowBorderRadius,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: ListTile(
                          dense: true,
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -3),
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(item['icon'] as IconData,
                              color: context.colorScheme.onSecondary),
                          title: Text(item['title'] as String,
                              style: context.textTheme.bodyLarge?.copyWith(
                                color: context.colorScheme.onSecondary,
                              )),
                          subtitle: item['subtitle'] != null
                              ? Text(
                                  item['subtitle'] as String,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.onSecondary,
                                  ),
                                )
                              : null,
                          trailing: item['trailing'] as Widget? ??
                              const Icon(Icons.chevron_right),
                        ),
                      ),
                    ),
                  ),
                ),
                if (index != settingsItems.length - 1)
                  Divider(
                    color: context.colorScheme.onSecondary.withAlpha(35),
                    thickness: 1,
                    height: 0,
                  )
              ],
            );
          })
        ],
      ),
    );
  }
}
