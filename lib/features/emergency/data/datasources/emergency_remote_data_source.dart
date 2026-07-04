import '../../../../core/network/api_client.dart';
import '../models/emergency_contact_model.dart';

abstract class EmergencyRemoteDataSource {
  Future<PaginatedEmergencyContactsModel> getEmergencyContacts({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  });

  Future<EmergencyContactModel> createContact(EmergencyContactModel contact);
  Future<EmergencyContactModel> updateContact(EmergencyContactModel contact);
  Future<void> deleteContact(String id);
}

class PaginatedEmergencyContactsModel {
  final List<EmergencyContactModel> contacts;
  final int total;

  PaginatedEmergencyContactsModel({
    required this.contacts,
    required this.total,
  });
}

class EmergencyRemoteDataSourceImpl implements EmergencyRemoteDataSource {
  final ApiClient apiClient;

  EmergencyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedEmergencyContactsModel> getEmergencyContacts({
    String? universityId,
    String? departmentId,
    String? scope,
    String? search,
    int? limit,
    int? offset,
  }) async {
    final response = await apiClient.get(
      '/emergency-contacts',
      queryParameters: {
        'university_id': ?universityId,
        'department_id': ?departmentId,
        'scope': ?scope,
        'search': ?search,
        'limit': ?limit,
        'offset': ?offset,
      },
    );

    final List<dynamic> contactsJson = response.data['data'] ?? [];
    final int total = response.data['count'] ?? 0;

    return PaginatedEmergencyContactsModel(
      contacts: contactsJson
          .map((json) => EmergencyContactModel.fromJson(json))
          .toList(),
      total: total,
    );
  }

  @override
  Future<EmergencyContactModel> createContact(
    EmergencyContactModel contact,
  ) async {
    final response = await apiClient.post(
      '/emergency-contacts',
      data: contact.toJson(),
    );
    return EmergencyContactModel.fromJson(response.data);
  }

  @override
  Future<EmergencyContactModel> updateContact(
    EmergencyContactModel contact,
  ) async {
    final response = await apiClient.put(
      '/emergency-contacts/${contact.id}',
      data: contact.toJson(),
    );
    return EmergencyContactModel.fromJson(response.data);
  }

  @override
  Future<void> deleteContact(String id) async {
    await apiClient.delete('/emergency-contacts/$id');
  }
}
