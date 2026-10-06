import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/batch/presentation/providers/batch_provider.dart'
    as new_batch;
import '/features/student/presentation/providers/student_provider.dart'
    as new_student;
import '/utils/constants.dart';
import 'package:go_router/go_router.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/widgets/open_app.dart';
import '/core/network/api_endpoints.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_font_size.dart';

class GetVerificationCodeScreen extends StatelessWidget {
  const GetVerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Verification Code'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .3
                : 16,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
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
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'Get verification code from CR',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: .w600,
                        color: context.colors.textMuted,
                      ),
                    ),
                    const Text(
                      "Connect with your class representative",
                      style: TextStyle(fontWeight: .w100),
                    ),
                    const SizedBox(height: Spacing.lg),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push(AppRoute.contactWithCR.path);
                      },
                      icon: Icon(
                        Icons.play_circle_fill_outlined,
                        color: context.colors.success,
                      ),
                      label: Text(
                        'Contact with CR/Moderator',
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxl),
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
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
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    Text(
                      'Register with Facebook',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: .w600,
                        color: context.colors.textMuted,
                      ),
                    ),
                    const Text(
                      "Like the page and send a message with",
                      style: TextStyle(fontWeight: .w100),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text(
                      "Requirements:",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: context.colors.warning,
                        letterSpacing: .4,
                        fontWeight: .bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    const Text(
                      "1. Full Name (as per certificate)."
                      "\n2. University, Department & Student ID."
                      "\n3. Photo of Student ID (Clear photo).",
                      style: TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Text(
                      "We will register your email as soon as possible.",
                    ),
                    const SizedBox(height: Spacing.sm),
                    OutlinedButton.icon(
                      onPressed: () {
                        OpenApp.withUrl(kFbGroup);
                      },
                      icon: Icon(
                        Icons.facebook_outlined,
                        color: context.colors.info,
                      ),
                      label: Text(
                        'Go to Facebook page',
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxl),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                child: Text("Contact with developer", textAlign: .center),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                padding: const EdgeInsets.all(Spacing.sm),
                child: Column(
                  crossAxisAlignment: .center,
                  mainAxisSize: .max,
                  children: [
                    const SizedBox(height: Spacing.sm),
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink.shade100,
                        image: const DecorationImage(
                          fit: .cover,
                          image: AssetImage('assets/images/reyad.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Text(
                      kDeveloperName,
                      style: TextStyle(
                        fontSize: FontSizeToken.xxl,
                        fontWeight: .w600,
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
                    const Text('UI/UX Designer, App Developer'),
                    const SizedBox(height: Spacing.sm),
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(RadiusToken.xs),
                            color: context.colors.warning,
                          ),
                          child: Text(
                            kDeveloperBatch,
                            style: TextStyle(
                              fontWeight: .w500,
                              color: context.colors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(RadiusToken.xs),
                            color: context.colors.success,
                          ),
                          child: Text(
                            kDeveloperSession,
                            style: TextStyle(
                              fontWeight: .w500,
                              color: context.colors.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Department of Psychology',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Text(
                      'University of Chittagong',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: .center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withNumber(kDeveloperMobile);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: context.colors.success,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(Spacing.md),
                            child: Icon(
                              Icons.call,
                              color: context.colors.onPrimary,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withEmail(kAppEmail);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: context.colors.danger,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(Spacing.md),
                            child: Icon(
                              Icons.mail,
                              color: context.colors.onPrimary,
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withUrl(kDeveloperFb);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: context.colors.info,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(Spacing.md),
                            child: Icon(
                              Icons.facebook,
                              color: context.colors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactWithCR extends ConsumerStatefulWidget {
  const ContactWithCR({super.key});

  @override
  ConsumerState<ContactWithCR> createState() => _ContactWithCRState();
}

class _ContactWithCRState extends ConsumerState<ContactWithCR> {
  String? _selectedUniversityId;
  String? _selectedDepartmentId;
  String? _selectedBatchId;

  @override
  Widget build(BuildContext context) {
    final universitiesAsync = ref.watch(allUniversitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact with CR/Moderator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800
                ? MediaQuery.of(context).size.width * .3
                : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              universitiesAsync.when(
                data: (universities) => DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text('Select your university'),
                  initialValue: _selectedUniversityId,
                  decoration: const InputDecoration(labelText: 'University'),
                  items: universities
                      .map(
                        (u) => DropdownMenuItem<String>(
                          value: u.id,
                          child: Text(u.name, overflow: .ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversityId = value;
                      _selectedDepartmentId = null;
                      _selectedBatchId = null;
                    });
                  },
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: Spacing.lg),
              if (_selectedUniversityId != null)
                ref
                    .watch(
                      departmentsByUniversityProvider(_selectedUniversityId!),
                    )
                    .when(
                      data: (departments) => DropdownButtonFormField<String>(
                        isExpanded: true,
                        hint: const Text('Select your department'),
                        initialValue: _selectedDepartmentId,
                        decoration: const InputDecoration(
                          labelText: 'Department',
                        ),
                        items: departments
                            .map(
                              (d) => DropdownMenuItem<String>(
                                value: d.id,
                                child: Text(d.name, overflow: .ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartmentId = value;
                            _selectedBatchId = null;
                          });
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
              const SizedBox(height: Spacing.lg),
              if (_selectedDepartmentId != null)
                ref
                    .watch(
                      new_batch.batchesByDepartmentProvider(
                        _selectedDepartmentId!,
                      ),
                    )
                    .when(
                      data: (batches) => DropdownButtonFormField<String>(
                        isExpanded: true,
                        hint: const Text('Select your batch'),
                        initialValue: _selectedBatchId,
                        decoration: const InputDecoration(labelText: 'Batch'),
                        items: batches
                            .map(
                              (b) => DropdownMenuItem<String>(
                                value: b.id,
                                child: Text(b.name, overflow: .ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedBatchId = value;
                          });
                        },
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('Error: $e'),
                    ),
              const SizedBox(height: Spacing.xxl),
              Text(
                'CR/Moderator List',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: .bold),
              ),
              const Divider(),
              if (_selectedBatchId != null)
                ref
                    .watch(
                      new_student.studentsByBatchProvider(_selectedBatchId!),
                    )
                    .when(
                      data: (students) {
                        final crs = students.where((s) => s.isCR).toList();

                        if (crs.isEmpty) {
                          return const Text('No CR/Moderator found!');
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: crs.length,
                          itemBuilder: (context, index) {
                            final s = crs[index];
                            return ListTile(
                              onTap: () {
                                if (s.phone != null) {
                                  OpenApp.withNumber(s.phone!);
                                }
                              },
                              tileColor: context.colors.onPrimary,
                              leading: CircleAvatar(
                                backgroundImage: s.imageUrl.isNotEmpty
                                    ? NetworkImage(
                                        ApiEndpoints.resolveImageUrl(
                                          s.imageUrl,
                                        ),
                                      )
                                    : const AssetImage(
                                            'assets/images/pp_placeholder.png',
                                          )
                                          as ImageProvider,
                              ),
                              title: Text(s.name),
                              subtitle: Text(
                                '${s.studentId} ${s.phone != null ? "• ${s.phone}" : ""}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: Icon(
                                Icons.call_outlined,
                                color: context.colors.success,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Spacing.lg),
                        );
                      },
                      loading: () =>
                          const Center(child: CupertinoActivityIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    )
              else
                const Text(
                  'Select University, Department and Batch to see CRs',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
