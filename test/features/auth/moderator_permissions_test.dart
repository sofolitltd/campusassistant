import 'package:campusassistant/features/auth/data/models/user_model.dart';
import 'package:campusassistant/features/auth/domain/entities/moderator_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('moderator role parsing and permissions', () {
    final user = UserModel.fromJson({
      'id': 'user-1',
      'email': 'moderator@example.com',
      'first_name': 'Campus',
      'last_name': 'Moderator',
      'role': 'student',
      'university_id': 'university-1',
      'department_id': 'department-1',
      'student': {'batch_id': 'batch-1'},
      'moderator_roles': [
        {
          'id': 'role-batch',
          'scope_type': 'batch',
          'scope_id': 'batch-1',
          'scope_name': 'CSE 21',
          'permissions': ['codes.view', 'class_notices.manage'],
        },
        {
          'id': 'role-department',
          'scope_type': 'department',
          'scope_id': 'department-1',
          'scope_name': 'Computer Science',
          'permissions': ['resources.review'],
        },
      ],
    }).toEntity();

    test('parses active roles and exposes moderator status', () {
      expect(user.isModerator, isTrue);
      expect(user.moderatorRoles, hasLength(2));
      expect(user.highestModeratorRole?.scopeType, 'department');
      expect(user.highestModeratorRole?.title, 'Department Moderator');
    });

    test('matches permission at batch and inherited department scopes', () {
      const target = ModeratorScopeTarget(
        batchId: 'batch-1',
        departmentId: 'department-1',
        universityId: 'university-1',
      );

      expect(user.can('codes.view', target), isTrue);
      expect(user.can('class_notices.manage', target), isTrue);
      expect(user.can('resources.review', target), isTrue);
      expect(
        user.can(
          'class_notices.manage',
          const ModeratorScopeTarget(
            batchId: 'batch-2',
            departmentId: 'department-2',
            universityId: 'university-1',
          ),
        ),
        isFalse,
      );
    });

    test('accepts permission maps from older API payloads', () {
      final role = ModeratorRole.fromJson({
        'scope_type': 'university',
        'scope_id': 'university-1',
        'permissions': {'resources.review': true, 'codes.view': false},
      });

      expect(role.permissions, ['resources.review']);
    });
  });
}
