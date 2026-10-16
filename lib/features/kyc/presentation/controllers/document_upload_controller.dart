import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/kyc_entity.dart';

class DocumentUploadController extends AsyncNotifier<DocumentUploadState> {
  @override
  FutureOr<DocumentUploadState> build() {
    return const DocumentUploadState();
  }

  void setDocType(IdentityDocType type) {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(docType: type));
  }

  void setFrontImage(File file) {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(frontImage: file));
  }

  void setBackImage(File file) {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(backImage: file));
  }

  void setSelfieImage(File file) {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(selfieImage: file));
  }

  void removeFrontImage() {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(clearFront: true));
  }

  void removeBackImage() {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(clearBack: true));
  }

  void removeSelfieImage() {
    final current = state.value ?? const DocumentUploadState();
    state = AsyncData(current.copyWith(clearSelfie: true));
  }
}