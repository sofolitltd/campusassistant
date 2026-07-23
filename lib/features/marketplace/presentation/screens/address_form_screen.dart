import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/student/domain/entities/student_address.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/widgets/district_sub_district_picker.dart';
import '../../data/models/address.dart';
import '../providers/marketplace_provider.dart';

const _labelOptions = ['Home', 'Hall', 'Other'];

class AddressFormScreen extends ConsumerStatefulWidget {
  final Address? address;
  final String? addressId;

  const AddressFormScreen({super.key, this.address, this.addressId});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _customLabelController;
  late final TextEditingController _recipientController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  String _labelOption = 'Home';
  String? _districtId;
  String? _districtName;
  String? _subDistrictId;
  String? _subDistrictName;
  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelOption = address == null
        ? 'Home'
        : (_labelOptions.contains(address.label) ? address.label : 'Other');
    _customLabelController = TextEditingController(
      text: _labelOption == 'Other' ? (address?.label ?? '') : '',
    );
    _recipientController = TextEditingController(text: address?.recipientName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _addressController = TextEditingController(text: address?.addressLine ?? '');
    _isDefault = address?.isDefault ?? false;
    if (address == null && widget.addressId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadAddress());
    }
  }

  Future<void> _loadAddress() async {
    final addresses = await ref.read(addressesProvider.future);
    final addr = addresses.where((a) => a.id == widget.addressId).firstOrNull;
    if (addr != null && mounted) {
      setState(() {
        _labelOption = _labelOptions.contains(addr.label) ? addr.label : 'Other';
        _customLabelController.text = _labelOption == 'Other' ? addr.label : '';
        _recipientController.text = addr.recipientName;
        _phoneController.text = addr.phone;
        _addressController.text = addr.addressLine;
        _isDefault = addr.isDefault;
      });
    }
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _applyQuickFill(StudentAddress addr) {
    setState(() {
      _districtId = addr.districtId;
      _districtName = addr.districtName;
      _subDistrictId = addr.subDistrictId;
      _subDistrictName = addr.subDistrictName;
      if (addr.addressLine != null && addr.addressLine!.isNotEmpty) {
        _addressController.text = addr.addressLine!;
      }
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_districtId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a district'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final label = _labelOption == 'Other' ? _customLabelController.text.trim() : _labelOption;
      final city = _subDistrictName != null ? '$_subDistrictName, $_districtName' : _districtName!;
      final address = Address(
        id: widget.address?.id ?? '',
        label: label,
        recipientName: _recipientController.text,
        phone: _phoneController.text,
        addressLine: _addressController.text,
        city: city,
        isDefault: _isDefault,
      );

      if (widget.address != null) {
        await updateAddress(ref, address: address);
      } else {
        await createAddress(ref, address: address);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildQuickFillChips() {
    final userId = ref.watch(currentUserProvider).value?.id;
    if (userId == null) return const SizedBox.shrink();

    final studentAsync = ref.watch(studentByUserIdProvider(userId));
    final present = studentAsync.value?.presentAddress;
    final permanent = studentAsync.value?.permanentAddress;
    if (present == null && permanent == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (present != null)
            ActionChip(
              avatar: const Icon(LucideIcons.home, size: 16),
              label: const Text('Use present address'),
              onPressed: () => _applyQuickFill(present),
            ),
          if (permanent != null)
            ActionChip(
              avatar: const Icon(LucideIcons.mapPin, size: 16),
              label: const Text('Use permanent address'),
              onPressed: () => _applyQuickFill(permanent),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.address != null ? 'Edit Address' : 'Add Address')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildQuickFillChips(),
            DropdownButtonFormField<String>(
              initialValue: _labelOption,
              decoration: const InputDecoration(labelText: 'Label', border: OutlineInputBorder()),
              items: _labelOptions
                  .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                  .toList(),
              onChanged: (v) => setState(() => _labelOption = v ?? 'Home'),
            ),
            if (_labelOption == 'Other') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customLabelController,
                decoration: const InputDecoration(labelText: 'Custom Label', hintText: 'e.g. Dorm'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: _recipientController,
              decoration: const InputDecoration(labelText: 'Recipient Name'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DistrictSubDistrictPicker(
              districtId: _districtId,
              subDistrictId: _subDistrictId,
              onDistrictChanged: (d) => setState(() {
                _districtId = d?.id;
                _districtName = d?.name;
                _subDistrictId = null;
                _subDistrictName = null;
              }),
              onSubDistrictChanged: (s) => setState(() {
                _subDistrictId = s?.id;
                _subDistrictName = s?.name;
              }),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Set as default address'),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(width: 20, height: 20, child: CupertinoActivityIndicator())
                    : Text(widget.address != null ? 'Update' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
