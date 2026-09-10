import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/kyc_models.dart';
import '../controllers/document_upload_controller.dart';

final documentUploadProvider =
    AsyncNotifierProvider<DocumentUploadController, DocumentUploadState>(
  DocumentUploadController.new,
);