import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? gender,
    String? universityId,
    String? departmentId,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  // Method to check if user is authenticated (e.g. valid token exists)
  Future<bool> isAuthenticated();

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, String>> refreshAccessToken();
}
