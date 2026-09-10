import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/kyc_repository.dart';
import '../../domain/kyc_models.dart';

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

  Future<void> uploadAll() async {
    final current = state.value;
    if (current == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(kycRepositoryProvider);

      if (current.frontImage != null) {
        await repo.uploadDocument(current.frontImage!, 'front');
      }
      if (current.needsBackSide && current.backImage != null) {
        await repo.uploadDocument(current.backImage!, 'back');
      }
      if (current.selfieImage != null) {
        await repo.uploadDocument(current.selfieImage!, 'selfie');
      }

      return current.copyWith(isUploaded: true);
    });
  }
}