import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/apply_loan_form_provider.dart';
import 'loan_amount_screen.dart';

class EmploymentDetailsScreen extends ConsumerStatefulWidget {
  const EmploymentDetailsScreen({super.key});

  @override
  ConsumerState<EmploymentDetailsScreen> createState() =>
      _EmploymentDetailsScreenState();
}

class _EmploymentDetailsScreenState
    extends ConsumerState<EmploymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _incomeController;
  late final TextEditingController _companyController;

  String? _employmentType;
  String? _workExperience;

  final _employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Business Owner',
    'Freelancer',
  ];
  final _experienceOptions = ['< 1 year', '1-3 years', '3-5 years', '5+ years'];

  @override
  void initState() {
    super.initState();
    final form = ref.read(applyLoanFormProvider);
    _incomeController = TextEditingController(text: form.monthlyIncome);
    _companyController = TextEditingController(text: form.companyName);
    _employmentType = form.employmentType.isNotEmpty
        ? form.employmentType
        : null;
    _workExperience = form.workExperience.isNotEmpty
        ? form.workExperience
        : null;
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;
    if (_employmentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your employment type')),
      );
      return;
    }
    if (_workExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your work experience')),
      );
      return;
    }

    ref
        .read(applyLoanFormProvider.notifier)
        .updateEmploymentDetails(
          employmentType: _employmentType!,
          monthlyIncome: _incomeController.text.trim(),
          companyName: _companyController.text.trim(),
          workExperience: _workExperience!,
        );

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoanAmountScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Employment Details', style: AppTextStyles.subheading),
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
                Text('Employment Type', style: AppTextStyles.body),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _employmentType,
                  items: _employmentTypes
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _employmentType = value),
                  decoration: const InputDecoration(
                    hintText: 'Select employment type',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Monthly Income',
                  hintText: 'Enter monthly income',
                  controller: _incomeController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.currency_rupee,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your monthly income'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Company Name',
                  hintText: 'Enter company name',
                  controller: _companyController,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your company name'
                      : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Work Experience', style: AppTextStyles.body),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _workExperience,
                  items: _experienceOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _workExperience = value),
                  decoration: const InputDecoration(
                    hintText: 'Select experience',
                  ),
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
