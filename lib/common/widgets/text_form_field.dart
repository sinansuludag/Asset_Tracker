import 'package:asset_tracker/core/constants/border_radius/border_radius.dart';
import 'package:asset_tracker/core/constants/paddings/paddings.dart';
import 'package:asset_tracker/core/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    required this.controller,
    required this.keyboardType,
    required this.textInputAction,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: context.colorScheme.onError.withAlpha(75),
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: AppPaddings.allLowPadding,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.onPrimary,
              borderRadius: AppBorderRadius.lowBorderRadius,
            ),
            child: widget.prefixIcon,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: AppBorderRadius.highBorderRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppBorderRadius.highBorderRadius,
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: widget.isPassword ? !_isPasswordVisible : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
    );
  }
}
