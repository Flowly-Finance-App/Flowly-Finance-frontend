import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';


enum Gender { male, female, other }

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dobController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  Gender? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _dobController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final initialDate = DateTime(today.year - 18, today.month, today.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(today.year - 18, today.month, today.day),
      helpText: 'Select Date of Birth',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      });
    }
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO Day 27: ഇവിടെ actual KYC Submit API call ചെയ്യണം
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('KYC info saved (API not connected yet)')),
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
        title: Text('KYC Verification', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Information', style: AppTextStyles.heading),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Please provide your personal details for verification',
                  style: AppTextStyles.bodySecondary,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Date of Birth (Read-only, opens date picker)
                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: AppTextField(
                      label: 'Date of Birth',
                      hintText: 'DD/MM/YYYY',
                      controller: _dobController,
                      prefixIcon: Icons.calendar_today_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Gender Selection
                Text('Gender', style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildGenderOption(Gender.male, 'Male'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildGenderOption(Gender.female, 'Female'),
                    const SizedBox(width: AppSpacing.sm),
                    _buildGenderOption(Gender.other, 'Other'),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                Text('Address', style: AppTextStyles.subheading),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Address Line 1',
                  hintText: 'House / Flat No, Building Name',
                  controller: _addressLine1Controller,
                  prefixIcon: Icons.home_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Address Line 2 (Optional)',
                  hintText: 'Street, Landmark',
                  controller: _addressLine2Controller,
                  prefixIcon: Icons.location_on_outlined,
                ),

                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'City',
                  hintText: 'Enter your city',
                  controller: _cityController,
                  prefixIcon: Icons.location_city_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'State',
                  hintText: 'Enter your state',
                  controller: _stateController,
                  prefixIcon: Icons.map_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Pincode',
                  hintText: 'Enter 6-digit pincode',
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.pin_drop_outlined,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your pincode';
                    }
                    if (value.trim().length != 6) {
                      return 'Enter a valid 6-digit pincode';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  label: 'Continue',
                  onPressed: _handleContinue,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(Gender gender, String label) {
    final isSelected = _selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}