import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/header_gradient_backdrop.dart';
import '/core/theme/tokens/app_control.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/batch/presentation/providers/batch_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/session/presentation/providers/session_provider.dart';
import '/features/student_verification/data/student_verification_request.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/routes/app_route.dart';
import '../providers/placement_selection_provider.dart';
import '../providers/student_verification_provider.dart';

/// Form a signed-in user fills to be verified as a student by document
/// review: batch + roll, a student ID card photo, and a registration card or
/// certificate photo. Pass a previous (rejected) request as [previous] to
/// prefill a resubmission.
class VerificationRequestScreen extends ConsumerStatefulWidget {
  const VerificationRequestScreen({super.key, this.previous});

  final StudentVerificationRequest? previous;

  @override
  ConsumerState<VerificationRequestScreen> createState() =>
      _VerificationRequestScreenState();
}

class _VerificationRequestScreenState
    extends ConsumerState<VerificationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rollController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _universityId;
  String? _departmentId;
  String? _batchId;
  String? _sessionId;
  String _secondDocType = 'registration_card';
  File? _idCardFile;
  File? _secondDocFile;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final prev = widget.previous;
    if (prev != null) {
      _universityId = prev.universityId;
      _departmentId = prev.departmentId;
      _batchId = prev.batchId;
      _sessionId = prev.sessionId;
      _secondDocType = prev.secondDocType;
      _nameController.text = prev.name;
      _rollController.text = prev.studentId;
      _phoneController.text = prev.phone;
    } else {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        _nameController.text = '${user.firstName} ${user.lastName}'.trim();
        _phoneController.text = user.phone ?? '';
      }

      // Carried over from the placement-selection step, so the student
      // doesn't have to pick their university/department/batch again.
      final placement = ref.read(placementSelectionProvider);
      if (placement != null) {
        _universityId = placement.universityId;
        _departmentId = placement.departmentId;
        _batchId = placement.batchId;
        ref.read(placementSelectionProvider.notifier).clear();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<File?> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2000,
    );
    return picked == null ? null : File(picked.path);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCardFile == null || _secondDocFile == null) {
      Fluttertoast.showToast(msg: 'Please add a photo of both documents.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final idCardId = await uploadVerificationDocument(ref, _idCardFile!);
      final secondDocId = await uploadVerificationDocument(
        ref,
        _secondDocFile!,
      );
      await submitStudentVerification(
        ref,
        universityId: _universityId!,
        departmentId: _departmentId!,
        batchId: _batchId!,
        sessionId: _sessionId!,
        studentId: _rollController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        idCardAttachmentId: idCardId,
        secondDocType: _secondDocType,
        secondDocAttachmentId: secondDocId,
      );
      ref.invalidate(myStudentVerificationProvider);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Request submitted for review.');
      context.goNamed(AppRoute.studentVerification.name);
    } catch (e) {
      Fluttertoast.showToast(
        msg: serverErrorMessage(e) ?? 'Could not submit. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.of(context).size.width;

    return HeaderGradientBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: colors.onPrimary),
          title: Text(
            'Verify as a student',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.onPrimary,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusToken.xxxl),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: Spacing.xl,
              horizontal: width > 800 ? width * .25 : Spacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: colors.infoSubtle,
                      borderRadius: BorderRadius.circular(RadiusToken.lg),
                    ),
                    child: Text(
                      'An admin checks your documents and links your account to '
                      'your batch. Your documents are stored privately and are '
                      'only visible to admins.',
                      style: TextStyle(color: colors.text, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  _sectionTitle(context, 'Your class'),
                  ..._placementFields(),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _rollController,
                    decoration: const InputDecoration(
                      labelText: 'Roll / Student ID',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your roll'
                        : null,
                  ),
                  const SizedBox(height: Spacing.xxl),
                  _sectionTitle(context, 'About you'),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full name (as on your ID card)',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: Spacing.lg),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Mobile number',
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  _sectionTitle(context, 'Documents'),
                  _DocumentPicker(
                    label: 'Student ID card',
                    file: _idCardFile,
                    onPick: () async {
                      final f = await _pickImage();
                      if (f != null) setState(() => _idCardFile = f);
                    },
                  ),
                  const SizedBox(height: Spacing.lg),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'registration_card',
                        label: Text('Registration card'),
                      ),
                      ButtonSegment(
                        value: 'certificate',
                        label: Text('Certificate'),
                      ),
                    ],
                    selected: {_secondDocType},
                    onSelectionChanged: (s) =>
                        setState(() => _secondDocType = s.first),
                  ),
                  const SizedBox(height: Spacing.sm),
                  _DocumentPicker(
                    label: _secondDocType == 'registration_card'
                        ? 'University registration card'
                        : 'Certificate copy (SSC/HSC)',
                    file: _secondDocFile,
                    onPick: () async {
                      final f = await _pickImage();
                      if (f != null) setState(() => _secondDocFile = f);
                    },
                  ),
                  const SizedBox(height: Spacing.xxxl),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        ControlToken.height,
                      ),
                    ),
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Submit for review'),
                  ),
                  const SizedBox(height: Spacing.xxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: Spacing.sm),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
        color: context.colors.textMuted,
      ),
    ),
  );

  /// University → department → batch → session cascade.
  List<Widget> _placementFields() {
    Widget dropdown({
      required String label,
      required String? value,
      required List<({String id, String name})> options,
      required ValueChanged<String?> onChanged,
    }) {
      final hasValue = options.any((o) => o.id == value);
      return DropdownButtonFormField<String>(
        // initialValue is only read on first build, so re-key when the
        // selection is changed from outside (cascade reset, auto-picked session).
        key: ValueKey('$label-$value-${options.length}'),
        isExpanded: true,
        initialValue: hasValue ? value : null,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final o in options)
            DropdownMenuItem(
              value: o.id,
              child: Text(o.name, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
        validator: (v) =>
            v == null ? 'Select your ${label.toLowerCase()}' : null,
      );
    }

    Widget asyncField<T>(
      AsyncValue<List<T>> async,
      Widget Function(List<T>) builder,
    ) => async.when(
      data: builder,
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('Could not load: $e'),
    );

    return [
      asyncField(
        ref.watch(allUniversitiesProvider),
        (list) => dropdown(
          label: 'University',
          value: _universityId,
          options: [for (final u in list) (id: u.id, name: u.name)],
          onChanged: (v) => setState(() {
            _universityId = v;
            _departmentId = null;
            _batchId = null;
            _sessionId = null;
          }),
        ),
      ),
      if (_universityId != null) ...[
        const SizedBox(height: Spacing.lg),
        asyncField(
          ref.watch(departmentsByUniversityProvider(_universityId!)),
          (list) => dropdown(
            label: 'Department',
            value: _departmentId,
            options: [for (final d in list) (id: d.id, name: d.name)],
            onChanged: (v) => setState(() {
              _departmentId = v;
              _batchId = null;
              _sessionId = null;
            }),
          ),
        ),
      ],
      if (_departmentId != null) ...[
        const SizedBox(height: Spacing.lg),
        asyncField(
          ref.watch(batchesByDepartmentProvider(_departmentId!)),
          (batches) => dropdown(
            label: 'Batch',
            value: _batchId,
            options: [for (final b in batches) (id: b.id, name: b.name)],
            onChanged: (v) {
              final batch = batches.where((b) => b.id == v).firstOrNull;
              setState(() {
                _batchId = v;
                // Most batches have exactly one session — pick it for them.
                _sessionId = batch?.sessions.length == 1
                    ? batch!.sessions.first.id
                    : null;
              });
            },
          ),
        ),
      ],
      if (_batchId != null) ...[
        const SizedBox(height: Spacing.lg),
        asyncField(
          ref.watch(sessionsByUniversityProvider(_universityId!)),
          (sessions) => dropdown(
            label: 'Session',
            value: _sessionId,
            options: [for (final s in sessions) (id: s.id, name: s.name)],
            onChanged: (v) => setState(() => _sessionId = v),
          ),
        ),
      ],
    ];
  }
}

class _DocumentPicker extends StatelessWidget {
  const _DocumentPicker({
    required this.label,
    required this.file,
    required this.onPick,
  });

  final String label;
  final File? file;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(RadiusToken.lg),
      child: Container(
        height: 160,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(RadiusToken.lg),
          border: Border.all(color: colors.border),
        ),
        child: file != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(file!, fit: BoxFit.cover),
                  Positioned(
                    left: Spacing.sm,
                    bottom: Spacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colors.scrim,
                        borderRadius: BorderRadius.circular(RadiusToken.sm),
                      ),
                      child: Text(
                        '$label · tap to change',
                        style: TextStyle(color: colors.onScrim, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: colors.textMuted),
                  const SizedBox(height: Spacing.sm),
                  Text(label, style: TextStyle(color: colors.textMuted)),
                ],
              ),
      ),
    );
  }
}
