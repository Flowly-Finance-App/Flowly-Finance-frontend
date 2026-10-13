import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/apply_loan_form_provider.dart';
import 'employment_details_screen.dart';

class PersonalDetailsApplyScreen extends ConsumerStatefulWidget {
  const PersonalDetailsApplyScreen({super.key});

  @override
  ConsumerState<PersonalDetailsApplyScreen> createState() =>
      _PersonalDetailsApplyScreenState();
}

class _PersonalDetailsApplyScreenState
    extends ConsumerState<PersonalDetailsApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _panController;

  @override
  void initState() {
    super.initState();
    final form = ref.read(applyLoanFormProvider);
    _nameController = TextEditingController(text: form.fullName);
    _mobileController = TextEditingController(text: form.mobile);
    _emailController = TextEditingController(text: form.email);
    _dobController = TextEditingController(text: form.dob);
    _panController = TextEditingController(text: form.panNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _panController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dobController.text =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
    }
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(applyLoanFormProvider.notifier)
        .updatePersonalDetails(
          fullName: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          email: _emailController.text.trim(),
          dob: _dobController.text.trim(),
          panNumber: _panController.text.trim().toUpperCase(),
        );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EmploymentDetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Personal Details', style: AppTextStyles.subheading),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  label: 'Full Name',
                  hintText: 'Enter Full Name',
                  controller: _nameController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your full name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Mobile Number',
                  hintText: 'Enter Mobile Number',
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your mobile number';
                    if (v.trim().length != 10)
                      return 'Enter a valid 10-digit mobile number';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email Address',
                  hintText: 'Enter email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your email';
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (!emailRegex.hasMatch(v.trim()))
                      return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onTap: _pickDob,
                  child: AbsorbPointer(
                    child: AppTextField(
                      label: 'Date of Birth',
                      hintText: 'DD/MM/YYYY',
                      controller: _dobController,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'PAN Number',
                  hintText: 'Enter PAN number',
                  controller: _panController,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Please enter your PAN number';
                    if (v.trim().length != 10)
                      return 'Enter a valid 10-character PAN';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(label: 'Next', onPressed: _handleNext),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
