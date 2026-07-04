import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/university/presentation/providers/university_provider.dart';
import '/features/department/presentation/providers/department_provider.dart';
import '/features/batch/presentation/providers/batch_provider.dart'
    as new_batch;
import '/features/student/presentation/providers/student_provider.dart'
    as new_student;
import 'package:campusassistant/utils/constants.dart';
import 'package:go_router/go_router.dart';
import '/routes/app_route.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import 'package:campusassistant/widgets/open_app.dart';

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Get verification code from CR'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const Text(
                      "Connect with your class representative",
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(height: Spacing.lg),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.push(AppRoute.contactWithCR.path);
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_outlined,
                        color: Colors.green,
                      ),
                      label: Text(
                        'Contact with CR/Moderator'.toUpperCase(),
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Register with facebook'.toUpperCase(),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    const Text(
                      "Like the page and send a message with",
                      style: TextStyle(fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Text(
                      "Requirements:".toUpperCase(),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Colors.deepOrange,
                        letterSpacing: .4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
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
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        OpenApp.withUrl(kFbGroup);
                      },
                      icon: const Icon(
                        Icons.facebook_outlined,
                        color: Colors.blue,
                      ),
                      label: Text(
                        'Go to facebook page'.toUpperCase(),
                        style: const TextStyle(
                          letterSpacing: .5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Contact with Developer".toUpperCase(),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(RadiusToken.sm),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.pink.shade100,
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/reyad.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    const Text(
                      kDeveloperName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('UI/UX Designer, App Developer'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.orange[100],
                          ),
                          child: const Text(
                            kDeveloperBatch,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent[100],
                          ),
                          child: const Text(
                            kDeveloperSession,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Department of Psychology',
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    Text(
                      'University of Chittagong',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: Spacing.lg),
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withNumber(kDeveloperMobile);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.green,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.call, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withEmail(kAppEmail);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.red,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.mail, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          MaterialButton(
                            onPressed: () {
                              OpenApp.withUrl(kDeveloperFb);
                            },
                            minWidth: 32,
                            elevation: 4,
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.facebook,
                              color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              universitiesAsync.when(
                data: (universities) => DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text('Select your university'),
                  initialValue: _selectedUniversityId,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'University',
                  ),
                  items: universities
                      .map(
                        (u) => DropdownMenuItem<String>(
                          value: u.id,
                          child: Text(u.name, overflow: TextOverflow.ellipsis),
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
                          border: OutlineInputBorder(),
                          labelText: 'Department',
                        ),
                        items: departments
                            .map(
                              (d) => DropdownMenuItem<String>(
                                value: d.id,
                                child: Text(
                                  d.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Batch',
                        ),
                        items: batches
                            .map(
                              (b) => DropdownMenuItem<String>(
                                value: b.id,
                                child: Text(
                                  b.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
              const SizedBox(height: 24),
              Text(
                'CR/Moderator List',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
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
                              tileColor: Colors.white,
                              leading: CircleAvatar(
                                backgroundImage: s.imageUrl.isNotEmpty
                                    ? NetworkImage(s.imageUrl)
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
                              trailing: const Icon(
                                Icons.call_outlined,
                                color: Colors.green,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: Spacing.lg),
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
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
