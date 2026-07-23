import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/features/auth/presentation/screens/forgot_password_page.dart';
import '/features/auth/presentation/screens/login_page.dart';
import '/features/auth/presentation/screens/new_student_create_account_screen.dart';
import '/features/auth/presentation/screens/new_student_sign_up_screen.dart';
import '/features/auth/presentation/screens/verification_page.dart';
import '/features/bkash/views/bkash_web_view.dart';
import '/features/alumni/presentation/screens/alumni_page.dart';
import '/features/blood/presentation/screens/blood_bank_page.dart';
import '/features/bookmark/presentation/screens/bookmark_page.dart';
import '/features/club/presentation/screens/club_details_page.dart';
import '/features/club/presentation/screens/club_page.dart';
import '/features/club/presentation/screens/suggest_club_page.dart';
import '/features/club/presentation/screens/my_clubs_page.dart';
import '/features/club/presentation/screens/manage_club_page.dart';
import '/features/association/domain/entities/association.dart';
import '/features/association/presentation/screens/association_details_page.dart';
import '/features/association/presentation/screens/association_page.dart';
import '/features/association/presentation/screens/suggest_association_page.dart';
import '/features/association/presentation/screens/joined_associations_page.dart';
import '/features/community/presentation/screens/community_page.dart';
import '/features/inbox/presentation/screens/inbox_page.dart';
import '/features/inbox/presentation/screens/chat_page.dart';
import '/features/inbox/presentation/screens/new_chat_page.dart';
import '/features/inbox/presentation/screens/request_confirmation_page.dart';
import '/features/cr/presentation/screens/cr_page.dart';
import '/features/department/presentation/screens/department_page.dart';
import '/features/notice/presentation/screens/department_notices_page.dart';
import '/features/emergency/presentation/screens/emergency_page.dart';
import '/features/home/home_page.dart';
import '/features/routine/presentation/screens/routine_page.dart';
import '/features/staff/presentation/screens/staff_page.dart';
import '/features/student/presentation/screens/all_students_page.dart';
import '/features/student/presentation/screens/batch_students_page.dart';
import '/features/subscription/presentation/screens/payment_page.dart';
import '/features/subscription/presentation/screens/transaction_history_page.dart';
import '/features/subscription/presentation/screens/subscription_page.dart';
import '/features/teacher/presentation/screens/teacher_details_screen.dart';
import '/features/teacher/presentation/screens/teacher_page.dart';
import '/features/transport/presentation/screens/transport_page.dart';
import '/features/university/presentation/screens/university_page.dart';
import '/features/university/presentation/screens/university_location_page.dart';
import '/features/university/presentation/screens/university_halls_page.dart';
import '/features/university/presentation/screens/university_departments_page.dart';
import '/features/university/presentation/screens/university_faculties_page.dart';
import '/features/university/presentation/screens/faculty_details_page.dart';
import '/features/course/presentation/screens/course_page.dart';
import '/features/study/presentation/screens/details/chapter_notes_screen.dart';
import '/features/study/presentation/screens/details/course_details_page.dart';
import '/features/study/levels/presentation/screens/study_page.dart';
import '/features/study/shortcut/library/library_page.dart';
import '/features/study/shortcut/questions/questions_page.dart';
import '/features/study/shortcut/research/research_page.dart';
import '/features/syllabus/presentation/screens/full_syllabus_page.dart';
import '/widgets/in_app_webview_page.dart';
import '/widgets/youtube_player_page.dart';
import '/features/skill/data/models/skill.dart';
import '/features/skill/presentation/screens/skill_details_page.dart';
import '/features/marketplace/data/models/product.dart';
import '/features/marketplace/presentation/widgets/marketplace_shell.dart';
import '/features/marketplace/presentation/screens/product_detail_screen.dart';
import '/features/marketplace/presentation/screens/merchant_apply_screen.dart';
import '/features/marketplace/presentation/screens/product_list_screen.dart';
import '/features/marketplace/presentation/screens/checkout_screen.dart';
import '/features/marketplace/presentation/screens/order_history_screen.dart';
import '/features/marketplace/presentation/screens/order_detail_screen.dart';
import '/features/marketplace/presentation/screens/address_list_screen.dart';
import '/features/marketplace/presentation/screens/address_form_screen.dart';
import '/features/marketplace/presentation/screens/cart_screen.dart';
import '/features/marketplace/presentation/screens/merchant_profile_screen.dart';
import '/features/marketplace/data/models/category.dart';
import '/features/resource/presentation/screens/add_edit_resource_screen.dart';
import '/widgets/image_viewer.dart';
import '/features/club/domain/entities/club.dart';
import '/features/auth/presentation/screens/get_verification_code_screen.dart';
import '/features/profile/presentation/screens/change_password.dart';
import '/features/profile/presentation/screens/downloaded_files_page.dart';
import '/features/profile/presentation/screens/edit_profile_page.dart';
import '/features/profile/presentation/screens/manage_devices_page.dart';
import '/features/profile/presentation/screens/my_submissions_page.dart';
import '/features/profile/presentation/screens/profile_page.dart';
import '/features/contributor/presentation/screens/contributor_page.dart';
import '/features/notification/presentation/screens/notification_detail_screen.dart';
import '/features/notification/presentation/screens/notification_screen.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/resource/domain/entities/resource.dart';
import '/features/auth/presentation/screens/new_splash_screen.dart';
import '/features/cache/presentation/cache_management_page.dart';
import 'app_route.dart';
import 'scaffold_with_navbar.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(currentUserProvider, (_, _) => notifyListeners());
  }
}

final routerNotifierProvider = Provider((ref) => RouterNotifier(ref));

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (BuildContext context, GoRouterState state) {
      final userAsync = ref.read(currentUserProvider);
      final bool isLoggedIn = userAsync.value != null;
      final bool isLoading = userAsync.isLoading || userAsync.isRefreshing;
      final bool hasError = userAsync.hasError;
      final matchedLocation = state.matchedLocation;

      // ── Splash screen: wait for auth resolution ──
      if (matchedLocation == '/splash') {
        if (isLoading || hasError) {
          return null; // stay on splash while checking auth or on network error
        }
        if (!isLoggedIn) return AppRoute.login.path;
        return AppRoute.home.path; // logged in → go to home
      }

      // ── During auth loading on any other route, just wait ──
      if (isLoading || hasError) return null;

      final isGuestRoute =
          matchedLocation == AppRoute.login.path ||
          matchedLocation == AppRoute.forgotPassword.path ||
          matchedLocation == AppRoute.verification.path ||
          matchedLocation.startsWith('/register') ||
          matchedLocation.startsWith('/create-account');

      if (!isLoggedIn) {
        if (!isGuestRoute) {
          return AppRoute.login.path;
        }
        return null; // Stay on guest routes
      }

      // Logged in — redirect away from guest routes
      if (isLoggedIn && isGuestRoute) {
        return AppRoute.home.path;
      }

      return null;
    },
    routes: [
      // Splash screen shown during initial auth check
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: NewSplashScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.home.name,
                path: AppRoute.home.path,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.study.name,
                path: AppRoute.study.path,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: StudyPage()),
                routes: [
                  GoRoute(
                    path: 'courses',
                    name: 'courses',
                    pageBuilder: (context, state) {
                      final batch = state.uri.queryParameters['batch'];
                      final semesterName =
                          state.uri.queryParameters['semesterName'] ??
                          state.uri.queryParameters['semester']; // fallback
                      final semesterId =
                          state.uri.queryParameters['semesterId'];
                      return NoTransitionPage(
                        child: CoursesPage(
                          batch: batch,
                          semesterName: semesterName,
                          semesterId: semesterId,
                        ),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: ':courseCode',
                        name: AppRoute.courseDetails.name,
                        pageBuilder: (context, state) {
                          final courseCode =
                              state.pathParameters['courseCode']!;
                          final batch = state.uri.queryParameters['batch'];
                          final semester =
                              state.uri.queryParameters['semester'];
                          final tab = state.uri.queryParameters['tab'];
                          return NoTransitionPage(
                            child: CourseDetailsScreen(
                              courseCode: courseCode,
                              batch: batch,
                              semester: semester,
                              initialTabName: tab,
                            ),
                          );
                        },
                        routes: [
                          GoRoute(
                            path: ':chapterNo',
                            name: AppRoute.courseNotes.name,
                            pageBuilder: (context, state) {
                              final courseCode =
                                  state.pathParameters['courseCode']!;
                              final chapterNo =
                                  state.pathParameters['chapterNo']!;
                              final title = state.uri.queryParameters['title'];
                              final batch = state.uri.queryParameters['batch'];
                              final semester =
                                  state.uri.queryParameters['semester'];
                              final universityId =
                                  state.uri.queryParameters['universityId'];
                              final departmentId =
                                  state.uri.queryParameters['departmentId'];
                              final resourceId =
                                  state.uri.queryParameters['resourceId'];
                              return NoTransitionPage(
                                child: CourseNotesScreens(
                                  courseCode: courseCode,
                                  chapterNo: chapterNo,
                                  batch: batch,
                                  semester: semester,
                                  title: title,
                                  universityId: universityId,
                                  departmentId: departmentId,
                                  resourceId: resourceId,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.community.name,
                path: AppRoute.community.path,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CommunityPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoute.profile.name,
                path: AppRoute.profile.path,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfilePage()),
                routes: [
                  GoRoute(
                    name: AppRoute.editProfile.name,
                    path: 'edit',
                    pageBuilder: (context, state) {
                      final uid = state.uri.queryParameters['uid']!;
                      return NoTransitionPage(child: EditProfilePage(uid: uid));
                    },
                  ),
                  GoRoute(
                    name: AppRoute.changePassword.name,
                    path: AppRoute.changePassword.path,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ChangePasswordPage()),
                  ),
                  GoRoute(
                    name: AppRoute.manageDevices.name,
                    path: AppRoute.manageDevices.path,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: ManageDevicesPage()),
                  ),
                  GoRoute(
                    name: AppRoute.mySubmissions.name,
                    path: AppRoute.mySubmissions.path,
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: MySubmissionsPage()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.inbox.name,
        path: AppRoute.inbox.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: InboxPage()),
        routes: [
          GoRoute(
            name: AppRoute.inboxChat.name,
            path: 'chat/:conversationId',
            pageBuilder: (context, state) {
              final conversationId = state.pathParameters['conversationId']!;
              final extra = state.extra as Map<String, dynamic>?;
              final name = extra?['name'] as String? ?? 'Chat';
              final otherUserId = extra?['otherUserId'] as String? ?? '';
              final status = extra?['status'] as String? ?? 'accepted';
              final initiatorId = extra?['initiatorId'] as String?;
              return NoTransitionPage(
                child: ChatPage(
                  conversationId: conversationId,
                  name: name,
                  otherUserId: otherUserId,
                  status: status,
                  initiatorId: initiatorId,
                ),
              );
            },
          ),
          GoRoute(
            name: AppRoute.requestConfirmation.name,
            path: 'request/:conversationId',
            pageBuilder: (context, state) {
              final conversationId = state.pathParameters['conversationId']!;
              final extra = state.extra as Map<String, dynamic>?;
              final name = extra?['name'] as String? ?? 'Unknown';
              final otherUserId = extra?['otherUserId'] as String? ?? '';
              final initiatorId = extra?['initiatorId'] as String?;
              return NoTransitionPage(
                child: RequestConfirmationPage(
                  conversationId: conversationId,
                  name: name,
                  otherUserId: otherUserId,
                  initiatorId: initiatorId,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.routine.name,
        path: AppRoute.routine.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: RoutinePage()),
      ),
      GoRoute(
        name: AppRoute.alumni.name,
        path: AppRoute.alumni.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AlumniPage()),
      ),
      GoRoute(
        name: AppRoute.emergency.name,
        path: AppRoute.emergency.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: EmergencyPage()),
      ),
      GoRoute(
        name: AppRoute.transport.name,
        path: AppRoute.transport.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TransportPage()),
      ),
      GoRoute(
        name: AppRoute.imageViewer.name,
        path: AppRoute.imageViewer.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final title = state.uri.queryParameters['title'] ?? '';
          final time = state.uri.queryParameters['time'] ?? '';
          final image = state.uri.queryParameters['image'] ?? '';
          return NoTransitionPage(
            child: ImageViewer(title: title, time: time, image: image),
          );
        },
      ),
      GoRoute(
        name: AppRoute.club.name,
        path: AppRoute.club.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ClubsPage()),
        routes: [
          GoRoute(
            name: AppRoute.clubDetails.name,
            path: ':clubId',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) {
              // extra carries the already-fetched Club when reached via a
              // list-card tap (no refetch needed); it's null when reached
              // via a deep link (e.g. a club-event push notification), in
              // which case ClubDetailsPage fetches it by clubId itself.
              final club = state.extra as Club?;
              final clubId = state.pathParameters['clubId']!;
              return NoTransitionPage(
                child: ClubDetailsPage(clubId: clubId, club: club),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.suggestClub.name,
        path: AppRoute.suggestClub.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SuggestClubPage()),
      ),
      GoRoute(
        name: AppRoute.association.name,
        path: AppRoute.association.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AssociationsPage()),
        routes: [
          GoRoute(
            name: AppRoute.associationDetails.name,
            path: ':associationId',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) {
              // extra carries the already-fetched Association when reached
              // via a list-card tap (no refetch needed); it's null when
              // reached via a deep link (e.g. an association-event push
              // notification), in which case AssociationDetailsPage fetches
              // it by associationId itself.
              final association = state.extra as Association?;
              final associationId = state.pathParameters['associationId']!;
              return NoTransitionPage(
                child: AssociationDetailsPage(
                  associationId: associationId,
                  association: association,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.suggestAssociation.name,
        path: AppRoute.suggestAssociation.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SuggestAssociationPage()),
      ),
      GoRoute(
        name: AppRoute.joinedAssociations.name,
        path: AppRoute.joinedAssociations.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: JoinedAssociationsPage()),
      ),
      GoRoute(
        name: AppRoute.myClubs.name,
        path: AppRoute.myClubs.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: MyClubsPage()),
      ),
      GoRoute(
        name: AppRoute.manageClub.name,
        path: AppRoute.manageClub.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final clubId = state.pathParameters['clubId']!;
          return NoTransitionPage(child: ManageClubPage(clubId: clubId));
        },
      ),
      GoRoute(
        name: AppRoute.bookmarks.name,
        path: AppRoute.bookmarks.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BookmarkPage()),
      ),
      GoRoute(
        name: AppRoute.downloadedFiles.name,
        path: AppRoute.downloadedFiles.path,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DownloadedFilesPage()),
      ),
      GoRoute(
        name: AppRoute.subscription.name,
        path: AppRoute.subscription.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SubscriptionPage()),
      ),
      GoRoute(
        name: AppRoute.payment.name,
        path: AppRoute.payment.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          final planId =
              args?['plan_id'] ?? state.uri.queryParameters['plan_id'] ?? '';
          final planTitle =
              args?['plan_title'] ??
              state.uri.queryParameters['plan_title'] ??
              'Plan';
          final amount =
              args?['amount'] ?? state.uri.queryParameters['amount'] ?? '0';
          return PaymentPage(
            planId: planId,
            planTitle: planTitle,
            amount: amount,
          );
        },
      ),
      GoRoute(
        name: AppRoute.transactionHistory.name,
        path: AppRoute.transactionHistory.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TransactionHistoryPage()),
      ),
      GoRoute(
        name: AppRoute.bkashWebView.name,
        path: AppRoute.bkashWebView.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return NoTransitionPage(
            child: BkashWebView(
              url: args['url'],
              successURL: args['successURL'],
              failureURL: args['failureURL'],
              cancelURL: args['cancelURL'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoute.blood.name,
        path: AppRoute.blood.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: BloodBank()),
      ),
      GoRoute(
        name: AppRoute.university.name,
        path: AppRoute.university.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: UniversityPage()),
        routes: [
          GoRoute(
            name: AppRoute.universityLocation.name,
            path: AppRoute.universityLocation.path,
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UniversityLocationPage()),
          ),
          GoRoute(
            name: AppRoute.universityHalls.name,
            path: AppRoute.universityHalls.path,
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UniversityHallsPage()),
          ),
          GoRoute(
            name: AppRoute.universityDepartments.name,
            path: AppRoute.universityDepartments.path,
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UniversityDepartmentsPage()),
          ),
          GoRoute(
            name: AppRoute.universityFaculties.name,
            path: AppRoute.universityFaculties.path,
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: UniversityFacultiesPage()),
          ),
          GoRoute(
            name: AppRoute.facultyDetails.name,
            path: AppRoute.facultyDetails.path,
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) {
              final facultyId = state.pathParameters['facultyId'] ?? '';
              final extra = state.extra as Map<String, dynamic>?;
              final facultyName = extra?['facultyName'] as String? ?? '';
              return NoTransitionPage(
                child: FacultyDetailsPage(
                  facultyId: facultyId,
                  facultyName: facultyName,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.department.name,
        path: AppRoute.department.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: DepartmentPage()),
        routes: [
          GoRoute(
            name: 'departmentNotices',
            path: 'notices',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DepartmentNoticesPage()),
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.teacher.name,
        path: AppRoute.teacher.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: TeacherPage()),
        routes: [
          GoRoute(
            path: 'details',
            pageBuilder: (context, state) {
              final id = state.uri.queryParameters['id']!;
              return NoTransitionPage(
                child: TeacherDetailsScreen(teacherId: id),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: 'batchStudents',
        path: '/students/:batch',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final batch = state.pathParameters['batch'];
          return NoTransitionPage(child: BatchStudentsPage(batch: batch!));
        },
      ),
      GoRoute(
        name: 'allStudents',
        path: '/students',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: AllStudentsPage());
        },
      ),
      GoRoute(
        name: AppRoute.cr.name,
        path: AppRoute.cr.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CrPage()),
      ),
      GoRoute(
        name: AppRoute.staff.name,
        path: AppRoute.staff.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: StaffPage()),
      ),
      GoRoute(
        name: AppRoute.library.name,
        path: AppRoute.library.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LibraryPage()),
      ),
      GoRoute(
        name: AppRoute.questions.name,
        path: AppRoute.questions.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: QuestionsPage()),
      ),
      GoRoute(
        name: AppRoute.syllabus.name,
        path: AppRoute.syllabus.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: FullSyllabusPage()),
      ),
      GoRoute(
        name: AppRoute.research.name,
        path: AppRoute.research.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ResearchPage()),
      ),
      GoRoute(
        name: AppRoute.notifications.name,
        path: AppRoute.notifications.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: NotificationScreen()),
        routes: [
          GoRoute(
            name: AppRoute.notificationDetail.name,
            path: ':id',
            parentNavigatorKey: rootNavigatorKey,
            pageBuilder: (context, state) {
              final notification = state.extra;
              return NoTransitionPage(
                child: NotificationDetailScreen(notification: notification),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.newChat.name,
        path: AppRoute.newChat.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: NewChatPage()),
      ),
      GoRoute(
        name: AppRoute.login.name,
        path: AppRoute.login.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: LoginPage()),
      ),
      GoRoute(
        name: AppRoute.forgotPassword.name,
        path: AppRoute.forgotPassword.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ForgotPassword()),
      ),
      GoRoute(
        name: AppRoute.verification.name,
        path: AppRoute.verification.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: VerificationPage()),
      ),
      GoRoute(
        name: AppRoute.getVerificationCode.name,
        path: AppRoute.getVerificationCode.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: GetVerificationCodeScreen()),
      ),
      GoRoute(
        name: AppRoute.contactWithCR.name,
        path: AppRoute.contactWithCR.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ContactWithCR()),
      ),
      GoRoute(
        name: AppRoute.registration.name,
        path: AppRoute.registration.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final studentId = state.pathParameters['studentId']!;
          return NoTransitionPage(
            child: NewStudentSignUpScreen(studentId: studentId),
          );
        },
      ),
      GoRoute(
        name: 'createAccount',
        path: '/create-account/:uid',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final uid = state.pathParameters['uid']!;
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            return const NoTransitionPage(child: VerificationPage());
          }
          return NoTransitionPage(
            child: CreateAccountScreen(
              universityId: args['universityId'],
              departmentId: args['departmentId'],
              university: args['university'],
              department: args['department'],
              profession: args['profession'],
              name: args['name'],
              mobile: args['mobile'],
              batchId: args['batchId'],
              studentId: args['studentId'],
              sessionId: args['sessionId'],
              hallId: args['hallId'],
              hallName: args['hallName'],
              blood: args['blood'],
              verificationUID: uid,
            ),
          );
        },
      ),
      GoRoute(
        path: '/webview',
        builder: (context, state) {
          final url =
              state.uri.queryParameters['url'] ?? 'https://www.google.com';
          return InAppWebViewPage(url: url);
        },
      ),
      GoRoute(
        name: AppRoute.youtubePlayer.name,
        path: AppRoute.youtubePlayer.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final videoId = state.pathParameters['videoId']!;
          final title = state.uri.queryParameters['title'] ?? 'Video Player';
          return YoutubePlayerPage(videoId: videoId, title: title);
        },
      ),
      GoRoute(
        name: AppRoute.skillDetails.name,
        path: AppRoute.skillDetails.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final skill = state.extra as Skill?;
          return SkillDetailsPage(skill: skill);
        },
      ),
      GoRoute(
        name: AppRoute.marketplace.name,
        path: AppRoute.marketplace.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MarketplaceShell(),
      ),
      // NOTE: static /marketplace/* routes must be registered before the
      // dynamic /marketplace/:productId route below — go_router matches
      // routes in declaration order, and :productId would otherwise swallow
      // literal paths like /marketplace/checkout.
      GoRoute(
        name: AppRoute.merchantApply.name,
        path: AppRoute.merchantApply.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MerchantApplyScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceCategoryProducts.name,
        path: AppRoute.marketplaceCategoryProducts.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final category = extra?['category'] as Category?;
          final categoryId = state.pathParameters['categoryId'] ?? category?.id;
          return ProductListScreen(category: category, categoryId: categoryId);
        },
      ),
      GoRoute(
        name: AppRoute.marketplaceCart.name,
        path: AppRoute.marketplaceCart.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceMerchantProfile.name,
        path: AppRoute.marketplaceMerchantProfile.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final merchantId = state.pathParameters['merchantId'] ?? '';
          return MerchantProfileScreen(merchantId: merchantId);
        },
      ),
      GoRoute(
        name: AppRoute.marketplaceCheckout.name,
        path: AppRoute.marketplaceCheckout.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceOrders.name,
        path: AppRoute.marketplaceOrders.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceOrderDetails.name,
        path: AppRoute.marketplaceOrderDetails.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final orderId = state.pathParameters['orderId'] ?? '';
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      GoRoute(
        name: AppRoute.marketplaceAddresses.name,
        path: AppRoute.marketplaceAddresses.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddressListScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceAddressForm.name,
        path: AppRoute.marketplaceAddressForm.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddressFormScreen(),
      ),
      GoRoute(
        name: AppRoute.marketplaceAddressEdit.name,
        path: AppRoute.marketplaceAddressEdit.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final addressId = state.pathParameters['addressId'] ?? '';
          return AddressFormScreen(addressId: addressId);
        },
      ),
      GoRoute(
        name: AppRoute.marketplaceProductDetails.name,
        path: AppRoute.marketplaceProductDetails.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final product = state.extra as Product?;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        name: AppRoute.addResource.name,
        path: AppRoute.addResource.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final universityId = state.pathParameters['universityId']!;
          final departmentId = state.pathParameters['departmentId']!;
          final courseCode = state.pathParameters['courseCode']!;

          final type = state.uri.queryParameters['type'] ?? 'note';
          final lessonNo =
              int.tryParse(state.uri.queryParameters['lessonNo'] ?? '') ?? 0;
          final initialBatchName =
              state.uri.queryParameters['initialBatchName'];

          return NoTransitionPage(
            child: AddEditResourceScreen(
              universityId: universityId,
              departmentId: departmentId,
              courseCode: courseCode,
              lessonNo: lessonNo,
              type: type,
              initialBatchName: initialBatchName,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoute.editResource.name,
        path: AppRoute.editResource.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          final universityId = state.pathParameters['universityId']!;
          final departmentId = state.pathParameters['departmentId']!;
          final courseCode = state.pathParameters['courseCode']!;
          final resource = state.extra as Resource?;

          return NoTransitionPage(
            child: AddEditResourceScreen(
              resource: resource,
              universityId: universityId,
              departmentId: departmentId,
              courseCode: courseCode,
              lessonNo: resource?.lessonNo ?? 0,
              type: resource?.type ?? 'note',
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoute.contributors.name,
        path: AppRoute.contributors.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ContributorPage()),
      ),
      GoRoute(
        name: AppRoute.cacheManagement.name,
        path: AppRoute.cacheManagement.path,
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: CacheManagementPage()),
      ),
    ],
  );
});
