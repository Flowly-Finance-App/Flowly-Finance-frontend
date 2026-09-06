import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/loading_indicator.dart';
import 'kyc_verification_screen.dart';

class OcrResultScreen extends StatefulWidget {
  const OcrResultScreen({super.key});

  @override
  State<OcrResultScreen> createState() => _OcrResultScreenState();
}

class _OcrResultScreenState extends State<OcrResultScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();
  final _panNumberController = TextEditingController();
  final _dobController = TextEditingController();

  bool _isScanning = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _simulateOcrScan();
  }

  // TODO Day 27: ഇത് real OCR API call ആയി മാറ്റണം (Aadhaar/PAN images അയച്ച്,
  // extracted text response ആയി കിട്ടണം)
  Future<void> _simulateOcrScan() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Placeholder/dummy extracted data — real API വരുമ്പോൾ ഇത് response-ൽ നിന്ന് വരും
    setState(() {
      _nameController.text = 'Rahul Kumar';
      _aadhaarNumberController.text = '1234 5678 9012';
      _panNumberController.text = 'ABCDE1234F';
      _dobController.text = '15/06/1995';
      _isScanning = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aadhaarNumberController.dispose();
    _panNumberController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO Day 27: ഇവിടെ verified info backend-ലേക്ക് save ചെയ്യണം
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const KycVerificationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Verify Details', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: _isScanning ? _buildScanningView() : _buildResultForm(),
      ),
    );
  }

  Widget _buildScanningView() {
    return const LoadingIndicator(
      message: 'Scanning your documents...\nThis will take a few seconds',
    );
  }

  Widget _buildResultForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success indicator
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.success, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Documents scanned successfully. Please verify the details below.',
                      style: AppTextStyles.body.copyWith(color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Extracted Information', style: AppTextStyles.heading),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Edit any incorrect details before continuing',
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppTextField(
              label: 'Full Name (as per document)',
              controller: _nameController,
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name cannot be empty';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Date of Birth',
              controller: _dobController,
              prefixIcon: Icons.calendar_today_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Date of birth cannot be empty';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Aadhaar Number',
              controller: _aadhaarNumberController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Aadhaar number cannot be empty';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'PAN Number',
              controller: _panNumberController,
              prefixIcon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'PAN number cannot be empty';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Confirm & Continue',
              onPressed: _handleConfirm,
              isLoading: _isSubmitting,
            ),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}