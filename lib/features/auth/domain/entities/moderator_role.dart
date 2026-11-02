class ModeratorRole {
  const ModeratorRole({
    required this.id,
    required this.scopeType,
    required this.scopeId,
    required this.scopeName,
    required this.permissions,
    this.termEnd,
  });

  final String id;
  final String scopeType;
  final String scopeId;
  final String scopeName;
  final List<String> permissions;
  final DateTime? termEnd;

  String get title => switch (scopeType) {
    'university' => 'University Moderator',
    'department' => 'Department Moderator',
    'batch' => 'Batch Moderator',
    _ => 'Moderator',
  };

  factory ModeratorRole.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'];
    final permissions = rawPermissions is List
        ? rawPermissions.whereType<String>().toList()
        : rawPermissions is Map
        ? rawPermissions.entries
              .where((entry) => entry.value == true)
              .map((entry) => entry.key.toString())
              .toList()
        : <String>[];
    final scopeType = json['scope_type'] as String? ?? '';
    return ModeratorRole(
      id: json['id']?.toString() ?? '',
      scopeType: scopeType,
      scopeId: json['scope_id']?.toString() ?? '',
      scopeName:
          json['scope_name'] as String? ?? json['name'] as String? ?? scopeType,
      permissions: permissions,
      termEnd: DateTime.tryParse(json['term_end'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'scope_type': scopeType,
    'scope_id': scopeId,
    'scope_name': scopeName,
    'permissions': permissions,
    if (termEnd != null) 'term_end': termEnd!.toIso8601String(),
  };
}

class ModeratorScopeTarget {
  const ModeratorScopeTarget({
    this.batchId,
    this.departmentId,
    this.universityId,
  });

  final String? batchId;
  final String? departmentId;
  final String? universityId;
}

extension ModeratorRoleScope on ModeratorRole {
  bool appliesTo(ModeratorScopeTarget target) => switch (scopeType) {
    'batch' => target.batchId == scopeId,
    'department' =>
      target.departmentId == scopeId &&
          (target.batchId == null || target.batchId!.isNotEmpty),
    'university' =>
      target.universityId == scopeId &&
          (target.batchId == null || target.batchId!.isNotEmpty),
    _ => false,
  };
}
