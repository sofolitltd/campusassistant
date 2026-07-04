import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di.dart';
import '../../../university/presentation/providers/university_provider.dart';
import '../../../department/presentation/providers/department_provider.dart';
import '../../data/datasources/emergency_remote_data_source.dart';
import '../../data/repositories/emergency_repository_impl.dart';
import '../../domain/entities/emergency_contact.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../../domain/usecases/get_emergency_contacts.dart';

part 'emergency_provider.g.dart';

@Riverpod(keepAlive: true)
EmergencyRemoteDataSource emergencyRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EmergencyRemoteDataSourceImpl(apiClient: apiClient);
}

@Riverpod(keepAlive: true)
EmergencyRepository emergencyRepository(Ref ref) {
  final remoteDataSource = ref.watch(emergencyRemoteDataSourceProvider);
  return EmergencyRepositoryImpl(remoteDataSource: remoteDataSource);
}

@Riverpod(keepAlive: true)
GetEmergencyContacts getEmergencyContacts(Ref ref) {
  final repository = ref.watch(emergencyRepositoryProvider);
  return GetEmergencyContacts(repository);
}

class EmergencyState {
  final List<EmergencyContact> contacts;
  final bool hasMore;
  final bool isLoadingMore;
  final int offset;

  EmergencyState({
    required this.contacts,
    required this.hasMore,
    required this.isLoadingMore,
    required this.offset,
  });

  EmergencyState copyWith({
    List<EmergencyContact>? contacts,
    bool? hasMore,
    bool? isLoadingMore,
    int? offset,
  }) {
    return EmergencyState(
      contacts: contacts ?? this.contacts,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      offset: offset ?? this.offset,
    );
  }
}

@riverpod
class EmergencySearchQuery extends _$EmergencySearchQuery {
  @override
  String build() => "";
  void updateQuery(String value) => state = value;
}

@riverpod
class EmergencyScope extends _$EmergencyScope {
  @override
  int build() => 0; // 0: Dept, 1: Uni, 2: Nat
  void updateScope(int value) => state = value;
}

@riverpod
class EmergencyPagination extends _$EmergencyPagination {
  static const int _limit = 20;

  @override
  Future<EmergencyState> build(int scopeIndex) async {
    final search = ref.watch(emergencySearchQueryProvider);

    return _fetchPage(offset: 0, search: search, scopeIndex: scopeIndex);
  }

  Future<EmergencyState> _fetchPage({
    required int offset,
    required String search,
    required int scopeIndex,
  }) async {
    final getContacts = ref.read(getEmergencyContactsProvider);
    final scope = ['department', 'university', 'national'][scopeIndex];

    String? universityId;
    String? departmentId;

    if (scope == 'department') {
      final university = await ref.watch(myUniversityProvider.future);
      final department = await ref.watch(myDepartmentProvider.future);
      universityId = university.id;
      departmentId = department.id;
    } else if (scope == 'university') {
      final university = await ref.watch(myUniversityProvider.future);
      universityId = university.id;
    }

    final result = await getContacts(
      GetEmergencyContactsParams(
        universityId: universityId,
        departmentId: departmentId,
        scope: scope,
        search: search.isEmpty ? null : search,
        limit: _limit,
        offset: offset,
      ),
    );

    return result.fold(
      (failure) => throw failure,
      (paginated) {
        return EmergencyState(
          contacts: paginated.contacts,
          hasMore: paginated.total > (offset + paginated.contacts.length),
          isLoadingMore: false,
          offset: offset + paginated.contacts.length,
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state.value;
    if (currentState == null ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(isLoadingMore: true));

    final search = ref.read(emergencySearchQueryProvider);

    try {
      final nextPage = await _fetchPage(
        offset: currentState.offset,
        search: search,
        scopeIndex: scopeIndex,
      );

      state = AsyncValue.data(
        currentState.copyWith(
          contacts: [...currentState.contacts, ...nextPage.contacts],
          hasMore: nextPage.hasMore,
          isLoadingMore: false,
          offset: nextPage.offset,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
