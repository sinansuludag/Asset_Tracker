import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/features/home/presentation/state_management/provider/all_providers.dart';
import 'package:asset_tracker/features/home/presentation/widgets/appbar_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/currency_list_view_builder_widget.dart';
import 'package:asset_tracker/features/home/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController filterController;
  @override
  void initState() {
    super.initState();
    filterController = TextEditingController();
  }

  @override
  void dispose() {
    filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ref.watch(currencyNotifierProvider);
    final currencyNotifier = ref.read(currencyNotifierProvider.notifier);

    return Scaffold(
      appBar: appBarWidget(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Tüm alanı algılar
        onPanDown: (_) => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: AppPaddings.horizontalSimetricVeryLowPadding,
          child: Column(
            children: [
              customTextFormField(context, currencyNotifier, filterController),
              Expanded(
                child: currencies.isNotEmpty
                    ? Scrollbar(
                        thumbVisibility: true,
                        child:
                            currencyListviewBuilderWidget(currencies, context),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(),
    );
  }

  BottomNavigationBar bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
