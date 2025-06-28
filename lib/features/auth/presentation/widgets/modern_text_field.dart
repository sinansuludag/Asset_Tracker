import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/constants/dimensions/app_dimensions.dart';

class ModernTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? onEditingComplete;

  const ModernTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.isPassword = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.onEditingComplete,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  bool _isObscured = true;
  bool _isFocused = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Focus listener ekle
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusNode != null) {
      setState(() {
        _isFocused = widget.focusNode!.hasFocus;
      });

      if (_isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _handleEditingComplete() {
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!();
    } else {
      // Varsayılan davranış: bir sonraki field'a geç
      if (widget.nextFocusNode != null) {
        FocusScope.of(context).requestFocus(widget.nextFocusNode);
      } else if (widget.textInputAction == TextInputAction.done) {
        FocusScope.of(context).unfocus();
      } else {
        FocusScope.of(context).nextFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppDimensions.authButtonRadius),
                boxShadow: [
                  BoxShadow(
                    color: _isFocused
                        ? AppColors.primaryGreen.withOpacity(0.2)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: _isFocused ? 15 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                obscureText: widget.isPassword ? _isObscured : false,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                validator: widget.validator,
                onEditingComplete: _handleEditingComplete,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppColors.primaryGreen
                              : AppColors.textSecondary,
                          size: 20,
                        )
                      : null,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          onPressed: () {
                            setState(() => _isObscured = !_isObscured);
                          },
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.authButtonRadius),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.authButtonRadius),
                    borderSide: BorderSide(
                      color: AppColors.primaryGreen,
                      width: 2,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: _isFocused
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceM,
                    vertical: AppDimensions.spaceM,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
