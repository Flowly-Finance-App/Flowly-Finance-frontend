import '../entities/apply_loan_form_state.dart';
import '../entities/application_result_entity.dart';

abstract class ApplyLoanRepository {
  Future<ApplicationResult> submitApplication(ApplyLoanFormState form);

  Future<List<dynamic>> getMyApplications();

  Future<Map<String, dynamic>> resubmitDocuments({
    required String applicationId,
    required Map<String, dynamic> data,
  });

  Future<Map<String, dynamic>> acceptSanction({
    required String applicationId,
  });

  Future<Map<String, dynamic>> esignLoan({
    required String applicationId,
    required String signatureHash,
  });
}