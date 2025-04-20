import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/media_query_sizes/media_query_size.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:flutter/material.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int selectedStars = 0;
  final TextEditingController commentController = TextEditingController();

  void _submitRating() {
    final comment = commentController.text.trim();
    // Gönderme işlemi burada yapılabilir (örneğin Firebase, REST API)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Değerlendirmeniz gönderildi!")),
    );
    commentController.clear();
    setState(() => selectedStars = 0);
  }

  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        Icons.star,
        color: index < selectedStars
            ? Colors.amber
            : context.colorScheme.onSurface.withAlpha(60),
        size: 36,
      ),
      onPressed: () {
        setState(() {
          selectedStars = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Uygulamayı Değerlendir",
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colorScheme.onSecondary,
            )),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: AppPaddings.allNormalPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Text(
                "Uygulamayı Beğendiniz mi?",
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, _buildStar),
              ),
              SizedBox(height: MediaQuerySize(context).percent3Height),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Yorumunuz (isteğe bağlı)",
                  style: context.textTheme.bodySmall,
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent1Height),
              TextFormField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Bir yorum yazın",
                  filled: true,
                  fillColor: color.onSecondary.withAlpha(10),
                  border: const OutlineInputBorder(
                    borderRadius: AppBorderRadius.defaultBorderRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: MediaQuerySize(context).percent2Height),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedStars == 0 ? null : _submitRating,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStars == 0
                        ? color.onSurface.withAlpha(60)
                        : color.primary,
                    foregroundColor: color.onPrimary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.defaultBorderRadius,
                    ),
                  ),
                  child: const Text("Gönder"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
