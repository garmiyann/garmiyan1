import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../controllers/auth_controller.dart';

/// OTP Verification Page
///
/// Professional OTP verification screen with auto-detection,
/// resend functionality, and security features.
class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String? email;
  final OtpType type;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    this.email,
    this.type = OtpType.phone,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final AuthController _authController = AuthController();

  bool _isLoading = false;
  int _resendCountdown = 60;
  bool _canResend = false;
  String _enteredOtp = '';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startCountdown();
    _authController.init();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  void _startCountdown() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _canResend = true;
          }
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: _buildBody(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppBar(),
          const SizedBox(height: AppDimensions.spacingXLarge),
          _buildHeader(),
          const SizedBox(height: AppDimensions.spacingXLarge),
          _buildOtpInputs(),
          const SizedBox(height: AppDimensions.spacingLarge),
          _buildResendSection(),
          const SizedBox(height: AppDimensions.spacingXLarge),
          _buildVerifyButton(),
          const SizedBox(height: AppDimensions.spacingLarge),
          _buildSecurityInfo(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Text(
          'Verification',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48), // Balance the back button
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXLarge),
          ),
          child: Icon(
            widget.type == OtpType.phone ? Icons.phone : Icons.email,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLarge),
        Text(
          'Enter Verification Code',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMedium),
        Text(
          widget.type == OtpType.phone
              ? 'We sent a 6-digit code to ${_formatPhoneNumber(widget.phoneNumber)}'
              : 'We sent a 6-digit code to ${widget.email}',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 45,
          height: 55,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
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
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide(
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
            ),
            onChanged: (value) => _onOtpChanged(index, value),
          ),
        );
      }),
    );
  }

  Widget _buildResendSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (_canResend)
          GestureDetector(
            onTap: _resendOtp,
            child: Text(
              'Resend',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          Text(
            'Resend in ${_resendCountdown}s',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ProfessionalButton(
        text: 'Verify Code',
        onPressed: _enteredOtp.length == 6 ? _verifyOtp : null,
        type: ButtonType.primary,
        size: ButtonSize.large,
        isLoading: _isLoading,
        icon: Icons.verified_user,
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.security,
            color: AppColors.info,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingSmall),
          Expanded(
            child: Text(
              'This code will expire in 10 minutes for security reasons.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      }
    } else {
      // Move to previous field on backspace
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Update entered OTP
    _enteredOtp = _controllers.map((c) => c.text).join();
    setState(() {});

    // Auto-verify when all digits are entered
    if (_enteredOtp.length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length != 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success and navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification successful!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to next screen or login
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid verification code. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear OTP inputs
        _clearOtp();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    try {
      // Simulate resend API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _canResend = false;
          _resendCountdown = 60;
        });

        _startCountdown();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.type == OtpType.phone
                  ? 'New code sent to ${_formatPhoneNumber(widget.phoneNumber)}'
                  : 'New code sent to ${widget.email}',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to resend code. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _clearOtp() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _enteredOtp = '';
    _focusNodes[0].requestFocus();
  }

  String _formatPhoneNumber(String phone) {
    if (phone.length >= 10) {
      return '${phone.substring(0, 3)}***${phone.substring(phone.length - 4)}';
    }
    return phone;
  }
}

/// OTP Type Enum
enum OtpType {
  phone,
  email,
}
