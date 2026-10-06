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

  /// Get the locally cached user profile (for offline use).
  Future<Either<Failure, User>> getCachedUser();

  // Method to check if user is authenticated (e.g. valid token exists)
  Future<bool> isAuthenticated();

  Future<Either<Failure, void>> forgotPassword(String email);

  /// Exchanges the emailed 6-digit code for a single-use reset token.
  Future<Either<Failure, String>> verifyResetCode(String email, String code);

  /// Consumes the reset token and sets the new password.
  Future<Either<Failure, void>> resetPassword(
    String email,
    String resetToken,
    String newPassword,
  );

  Future<Either<Failure, String>> refreshAccessToken();

  /// Changes the password for the currently authenticated user.
  /// Optionally invalidates all other sessions via [logoutOtherDevices].
  /// Returns an updated access token on success.
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
    bool logoutOtherDevices = true,
  });
}
