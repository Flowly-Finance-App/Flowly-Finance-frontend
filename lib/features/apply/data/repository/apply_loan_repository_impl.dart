import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/apply_loan_form_state.dart';
import '../../domain/entities/application_result_entity.dart';
import '../../domain/repository/apply_loan_repository.dart';
import '../datasource/apply_loan_remote_datasource.dart';

class ApplyLoanRepositoryImpl implements ApplyLoanRepository {
  final ApplyLoanRemoteDataSource _remote;

  ApplyLoanRepositoryImpl(this._remote);

  @override
  Future<ApplicationResult> submitApplication(ApplyLoanFormState form) async {
    final responseData = await _remote.submitApplication(form.toJson());

    final application = responseData['application'];
    if (application is Map<String, dynamic>) {
      return ApplicationResult.fromJson(application);
    }
    if (responseData['applicationNumber'] != null) {
      return ApplicationResult.fromJson(responseData);
    }
    throw Exception('Invalid response received from loan application API');
  }

  @override
  Future<List<dynamic>> getMyApplications() {
    return _remote.getMyApplications();
  }

  @override
  Future<Map<String, dynamic>> resubmitDocuments({
    required String applicationId,
    required Map<String, dynamic> data,
  }) {
    return _remote.resubmitDocuments(applicationId: applicationId, data: data);
  }

  @override
  Future<Map<String, dynamic>> acceptSanction({
    required String applicationId,
  }) {
    return _remote.acceptSanction(applicationId: applicationId);
  }

  @override
  Future<Map<String, dynamic>> esignLoan({
    required String applicationId,
    required String signatureHash,
  }) {
    return _remote.esignLoan(
      applicationId: applicationId,
      signatureHash: signatureHash,
    );
  }
}

final applyLoanRepositoryProvider = Provider<ApplyLoanRepository>((ref) {
  final remote = ref.watch(applyLoanRemoteDataSourceProvider);
  return ApplyLoanRepositoryImpl(remote);
});