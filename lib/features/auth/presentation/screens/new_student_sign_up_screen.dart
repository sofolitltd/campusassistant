import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/student/presentation/providers/student_provider.dart';
import '/utils/constants.dart';
import 'package:go_router/go_router.dart';
import '/widgets/common_dropdown_widget.dart';
import '/widgets/common_text_field_widget.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';
import '/core/theme/tokens/app_control.dart';

class NewStudentSignUpScreen extends ConsumerStatefulWidget {
  const NewStudentSignUpScreen({super.key, required this.studentId});

  final String studentId;

  @override
  ConsumerState<NewStudentSignUpScreen> createState() =>
      _NewStudentSignUpScreenState();
}

class _NewStudentSignUpScreenState
    extends ConsumerState<NewStudentSignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _selectedHall;
  String _selectedBloodGroup = 'None';
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final studentAsync = ref.watch(studentByCodeProvider(widget.studentId));

    return studentAsync.when(
      data: (student) {
        final s = student;

        if (!_initialized) {
          _nameController.text = s.studentName ?? '';
          _mobileController.text = s.phone ?? '';
          if (s.bloodGroup.isNotEmpty) {
            _selectedBloodGroup = s.bloodGroup;
          }
          _initialized = true;
        }

        final hallsAsync = ref.watch(hallsByUniversityProvider(s.universityId));
        final universityName = ref.watch(
          universityNameProvider(s.universityId),
        );
        final departmentName = ref.watch(
          departmentNameProvider('${s.universityId}|${s.departmentId}'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign Up(1/2)'),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 800
                      ? MediaQuery.of(context).size.width * .3
                      : 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(RadiusToken.xl),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? context.colors.border
                              : context.colors.border,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          Spacing.lg,
                          Spacing.lg,
                          Spacing.lg,
                          Spacing.lg,
                        ),
                        child: Column(
                          crossAxisAlignment: .stretch,
                          children: [
                            Text(
                              'Hello',
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    fontWeight: .bold,
                                    letterSpacing: 1,
                                  ),
                            ),
                            Text(
                              'Fill your user information',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(fontWeight: .w100),
                            ),
                            const Divider(height: 24),
                            Container(
                              padding: const EdgeInsets.all(Spacing.md),
                              decoration: BoxDecoration(
                                color: context.colors.info,
                                borderRadius: BorderRadius.circular(
                                  RadiusToken.sm,
                                ),
                                border: Border.all(color: context.colors.info),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: context.colors.info,
                                    size: 20,
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Text(
                                    'Pre-verified Student Record',
                                    style: TextStyle(
                                      color: context.colors.info,
                                      fontWeight: .bold,
                                      fontSize: FontSizeToken.sm,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: Spacing.lg),
                            _buildOfficialInfoRow(
                              context,
                              'University',
                              universityName,
                            ),
                            const SizedBox(height: Spacing.sm),
                            _buildOfficialInfoRow(
                              context,
                              'Department',
                              departmentName,
                            ),
                            const SizedBox(height: Spacing.sm),
                            _buildOfficialInfoRow(
                              context,
                              'Student ID',
                              s.studentId,
                            ),
                            const SizedBox(height: Spacing.sm),
                            _buildOfficialInfoRow(context, 'Batch', s.batchId),
                            const Divider(height: 32),
                            Text(
                              'Personal information',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(
                                    fontWeight: .bold,
                                    color: context.colors.textMuted,
                                    letterSpacing: 1,
                                  ),
                            ),
                            const SizedBox(height: Spacing.md),
                            CommonTextFieldWidget(
                              controller: _nameController,
                              heading: 'Full Name',
                              hintText: 'Enter your name as per certificate',
                              keyboardType: .name,
                              textCapitalization: .words,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: Spacing.md),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: CommonTextFieldWidget(
                                    controller: _mobileController,
                                    heading: 'Mobile',
                                    hintText: 'Enter mobile number',
                                    keyboardType: .phone,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'Enter mobile number';
                                      }
                                      if (val.length < 11) {
                                        return 'Mobile number at least 11 digits';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: Spacing.md),
                                Expanded(
                                  flex: 2,
                                  child: CommonDropDownWidget(
                                    heading: 'Blood Group',
                                    hint: 'Blood group',
                                    value: _selectedBloodGroup,
                                    itemList: kBloodGroup,
                                    onChanged: (value) => setState(
                                      () => _selectedBloodGroup = value!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Spacing.md),
                            hallsAsync.when(
                              data: (halls) {
                                final hallNames = halls
                                    .map((e) => e.name)
                                    .toList();

                                String? initialHallName;
                                if (_selectedHall == null && s.hallId != null) {
                                  try {
                                    initialHallName = halls
                                        .firstWhere((h) => h.id == s.hallId)
                                        .name;
                                  } catch (_) {}
                                }

                                return CommonDropDownWidget(
                                  heading: 'Halls ',
                                  hint: 'Select your hall',
                                  value: _selectedHall ?? initialHallName,
                                  itemList: hallNames,
                                  onChanged: (value) =>
                                      setState(() => _selectedHall = value),
                                );
                              },
                              loading: () => const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(Spacing.sm),
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              error: (err, stack) => Text(
                                'Error loading halls: $err',
                                style: TextStyle(
                                  color: context.colors.danger,
                                  fontSize: FontSizeToken.sm,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.xxl),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(
                                  double.infinity,
                                  ControlToken.height,
                                ),
                              ),
                              onPressed: () {
                                if (_globalKey.currentState!.validate()) {
                                  final halls = hallsAsync.asData?.value;
                                  String? hallId = s.hallId;
                                  String hallName = '';

                                  if (_selectedHall != null && halls != null) {
                                    try {
                                      final selectedHall = halls.firstWhere(
                                        (h) => h.name == _selectedHall,
                                      );
                                      hallId = selectedHall.id;
                                      hallName = selectedHall.name;
                                    } catch (_) {}
                                  } else if (s.hallId != null &&
                                      halls != null) {
                                    try {
                                      final initialHall = halls.firstWhere(
                                        (h) => h.id == s.hallId,
                                      );
                                      hallName = initialHall.name;
                                    } catch (_) {}
                                  }

                                  context.pushNamed(
                                    'createAccount',
                                    pathParameters: {
                                      'uid': s.verificationCode.isNotEmpty
                                          ? s.verificationCode
                                          : widget.studentId,
                                    },
                                    extra: {
                                      'universityId': s.universityId,
                                      'departmentId': s.departmentId,
                                      'university': universityName,
                                      'department': departmentName,
                                      'profession': 'student',
                                      'name': _nameController.text.trim(),
                                      'mobile': _mobileController.text.trim(),
                                      'batchId': s.batchId,
                                      'studentId': s.studentId,
                                      'sessionId': s.sessionId,
                                      'hallId': hallId,
                                      'hallName': hallName,
                                      'blood': _selectedBloodGroup,
                                    },
                                  );
                                }
                              },
                              child: Text(
                                'Next',
                                style: const TextStyle(
                                  letterSpacing: 1,
                                  fontWeight: .bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: Spacing.sm),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CupertinoActivityIndicator())),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Text('Error loading student info: $error'),
              const SizedBox(height: Spacing.lg),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(studentByCodeProvider(widget.studentId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfficialInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.colors.textSubtle,
            fontSize: FontSizeToken.xxs,
            fontWeight: .bold,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: Spacing.xxs),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: .w600,
            color: context.colors.text,
          ),
        ),
      ],
    );
  }
}
