import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

/// Professional Text Field Widget
///
/// Enterprise-level text input with advanced validation,
/// accessibility features, and Material Design 3 styling.
class ProfessionalTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? semanticLabel;
  final bool showCounter;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;

  const ProfessionalTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.semanticLabel,
    this.showCounter = false,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
  });

  @override
  State<ProfessionalTextField> createState() => _ProfessionalTextFieldState();
}

class _ProfessionalTextFieldState extends State<ProfessionalTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingSmall),
            child: Text(
              widget.label!,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: _isFocused ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),

        // Text Field
        Semantics(
          label: widget.semanticLabel ?? widget.label,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            validator: _validateInput,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            maxLength: widget.showCounter ? widget.maxLength : null,
            inputFormatters: widget.inputFormatters,
            textCapitalization: widget.textCapitalization,
            style: AppTextStyles.bodyLarge.copyWith(
              color: widget.enabled
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    )
                  : null,
              suffixIcon: widget.suffixIcon != null
                  ? IconButton(
                      icon: Icon(
                        widget.suffixIcon,
                        color: _isFocused
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      onPressed: widget.onSuffixPressed,
                    )
                  : null,
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.surface
                  : AppColors.surface.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(AppDimensions.paddingLarge),
              counterStyle: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // Helper Text or Error
        if (widget.helperText != null || _currentError != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppDimensions.spacingSmall,
              left: AppDimensions.paddingMedium,
            ),
            child: Text(
              _currentError ?? widget.helperText!,
              style: AppTextStyles.caption.copyWith(
                color: _currentError != null
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  String? _validateInput(String? value) {
    String? error;

    // Use provided validator first
    if (widget.validator != null) {
      error = widget.validator!(value);
    }

    // Apply built-in validation based on keyboard type
    if (error == null) {
      error = _applyBuiltInValidation(value);
    }

    setState(() {
      _currentError = error;
    });

    return error;
  }

  String? _applyBuiltInValidation(String? value) {
    if (value == null || value.isEmpty) return null;

    switch (widget.keyboardType) {
      case TextInputType.emailAddress:
        return Validators.email(value);
      case TextInputType.phone:
        return Validators.phone(value);
      case TextInputType.url:
        if (!NetworkUtils.isValidUrl(value)) {
          return 'Please enter a valid URL';
        }
        break;
      default:
        break;
    }

    return null;
  }
}

/// Factory methods for common text field types
extension ProfessionalTextFieldFactory on ProfessionalTextField {
  /// Email input field
  static ProfessionalTextField email({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    bool required = false,
  }) {
    return ProfessionalTextField(
      key: key,
      label: label ?? 'Email',
      hint: hint ?? 'Enter your email address',
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email_outlined,
      textInputAction: TextInputAction.next,
      validator: required ? Validators.email : null,
    );
  }

  /// Password input field
  static ProfessionalTextField password({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    bool required = false,
  }) {
    return ProfessionalTextField(
      key: key,
      label: label ?? 'Password',
      hint: hint ?? 'Enter your password',
      controller: controller,
      onChanged: onChanged,
      obscureText: true,
      prefixIcon: Icons.lock_outlined,
      textInputAction: TextInputAction.done,
      validator: required ? Validators.password : null,
    );
  }

  /// Phone number input field
  static ProfessionalTextField phone({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    bool required = false,
  }) {
    return ProfessionalTextField(
      key: key,
      label: label ?? 'Phone Number',
      hint: hint ?? 'Enter your phone number',
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      textInputAction: TextInputAction.next,
      validator: required ? Validators.phone : null,
    );
  }
}
