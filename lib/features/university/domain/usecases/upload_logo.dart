import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/university_repository.dart';

class UploadLogo implements UseCase<String, UploadLogoParams> {
  final UniversityRepository repository;

  UploadLogo(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadLogoParams params) async {
    if (params.bytes != null && params.fileName != null) {
      return await repository.uploadLogoBytes(
        params.bytes!,
        params.fileName!,
        folder: params.folder,
      );
    }
    return await repository.uploadLogo(params.filePath!, folder: params.folder);
  }
}

class UploadLogoParams {
  final String? filePath;
  final List<int>? bytes;
  final String? fileName;
  final String? folder;

  UploadLogoParams({this.filePath, this.bytes, this.fileName, this.folder});
}
