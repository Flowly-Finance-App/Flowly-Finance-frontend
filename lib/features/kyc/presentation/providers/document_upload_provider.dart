import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/kyc_entity.dart';
import '../controllers/document_upload_controller.dart';

final documentUploadProvider =
    AsyncNotifierProvider<DocumentUploadController, DocumentUploadState>(
  DocumentUploadController.new,
);