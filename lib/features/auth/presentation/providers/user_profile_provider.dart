import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/profile/data/models/profile_model.dart';
import '/features/student/presentation/providers/student_provider.dart';

final userProvider = FutureProvider<ProfileModel>((ref) async {
  final user = await ref.watch(currentUserProvider.future)
      .timeout(const Duration(seconds: 10));

  if (user == null) {
    throw Exception('User not logged in');
  }

  // Create a ProfileModel from the new User entity
  return ProfileModel(
    uid: user.id,
    university: user.universityId ?? '',
    department: user.departmentId ?? '',
    profession: user.role,
    name: user.fullName,
    mobile: user.phone ?? '',
    email: user.email,
    image: user.profileImage ?? '',
    token: '',
    information: Information(
      batch: user.batch,
      id: user.id,
      session: user.session,
      hall: user.hall,
      blood: user.blood,
      universityId: user.universityId,
      departmentId: user.departmentId,
      status: Status(
        subscriber: user.subscriptionStatus,
        moderator: user.isModerator,
        admin: user.isAdmin,
        cr: user.isCr,
      ),
    ),
  );
});


final userProfileByUidProvider = FutureProvider.family<ProfileModel, String>((
  ref,
  uid,
) async {
  // Use studentByUserIdProvider to get student info which includes more details
  final student = await ref.watch(studentByUserIdProvider(uid).future);

  if (student == null) {
    throw Exception('User profile not found');
  }

  return ProfileModel(
    uid: uid,
    university: student.universityId,
    department: student.departmentId,
    profession: 'student',
    name: student.name,
    mobile: student.phone ?? '',
    email: student.email ?? '',
    image: student.imageUrl,
    token: student.verificationCode,
    information: Information(
      batch: student.batchId,
      id: student.studentId,
      session: student.sessionId,
      hall: student.hallName,
      blood: student.bloodGroup,
      status: Status(
        subscriber: 'basic',
        moderator: false,
        admin: false,
        cr: false,
      ),
    ),
  );
});
