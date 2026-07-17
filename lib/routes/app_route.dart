class AppRoute {
  final String name;
  final String path;
  final String Function(Map<String, String>? params)? buildPath;

  const AppRoute({required this.name, required this.path, this.buildPath});

  String toPath([Map<String, String>? params]) {
    if (buildPath != null) {
      return buildPath!(params);
    }
    String result = path;
    if (params != null) {
      params.forEach((key, value) {
        result = result.replaceAll(':$key', value);
      });
    }
    return result;
  }

  // All routes defined below

  //////// home ////////
  static const home = AppRoute(name: 'home', path: '/');
  static const community = AppRoute(name: 'community', path: '/community');
  static const inbox = AppRoute(name: 'inbox', path: '/inbox');
  static const inboxChat = AppRoute(name: 'inboxChat', path: 'chat/:conversationId');
  static const requestConfirmation = AppRoute(name: 'requestConfirmation', path: 'request/:conversationId');
  static const newChat = AppRoute(name: 'newChat', path: '/new-chat');

  //
  static const routine = AppRoute(name: 'routine', path: '/routine');
  static const alumni = AppRoute(name: 'alumni', path: '/alumni');
  static const emergency = AppRoute(name: 'emergency', path: '/emergency');
  static const transport = AppRoute(name: 'transport', path: '/transport');
  static const imageViewer = AppRoute(
    name: 'imageViewer',
    path: '/image-viewer',
  );
  static const club = AppRoute(name: 'club', path: '/club');
  static const clubDetails = AppRoute(
    name: 'clubDetails',
    path: '/clubs/:clubId',
  );
  static const addClub = AppRoute(name: 'addClub', path: '/add-club');
  static const blood = AppRoute(name: 'blood', path: '/blood-bank');

  //
  static const subscription = AppRoute(
    name: 'subscription',
    path: '/subscription',
  );

  //
  static const payment = AppRoute(name: 'payment', path: '/payment');
  static const bkashWebView = AppRoute(
    name: 'bkashWebView',
    path: '/bkash-webview',
  );

  //
  static const university = AppRoute(name: 'university', path: '/university');
  static const universityLocation = AppRoute(
    name: 'universityLocation',
    path: 'location',
  );
  static const universityHalls = AppRoute(
    name: 'universityHalls',
    path: 'halls',
  );
  static const universityDepartments = AppRoute(
    name: 'universityDepartments',
    path: 'departments',
  );
  static const universityFaculties = AppRoute(
    name: 'universityFaculties',
    path: 'faculties',
  );
  static const department = AppRoute(name: 'department', path: '/department');
  static const teacher = AppRoute(name: 'teacher', path: '/teacher');
  static const student = AppRoute(name: 'student', path: '/student');

  static const cr = AppRoute(name: 'cr', path: '/cr');
  static const staff = AppRoute(name: 'staff', path: '/staff');

  //////  study ///////
  static const study = AppRoute(name: 'study', path: '/study');
  static const courseDetails = AppRoute(
    name: 'courseDetails',
    path: '/study/courses/:courseCode',
  );
  static const courseNotes = AppRoute(
    name: 'courseNotes',
    path: '/study/courses/:courseCode/:chapterNo',
  );
  static const youtubePlayer = AppRoute(
    name: 'youtubePlayer',
    path: '/video-player/:videoId',
  );

  static const library = AppRoute(name: 'library', path: '/library');
  static const questions = AppRoute(name: 'questions', path: '/questions');
  static const syllabus = AppRoute(name: 'syllabus', path: '/syllabus');
  static const research = AppRoute(name: 'research', path: '/research');
  static const bookmarks = AppRoute(name: 'bookmarks', path: '/bookmarks');

  static const addResource = AppRoute(
    name: 'addResource',
    path:
        '/universities/:universityId/departments/:departmentId/courses/:courseCode/resources/add',
  );
  static const editResource = AppRoute(
    name: 'editResource',
    path:
        '/universities/:universityId/departments/:departmentId/courses/:courseCode/resources/edit/:resourceId',
  );
  static const downloadedFiles = AppRoute(
    name: 'downloadedFiles',
    path: '/downloads',
  );

  //profile
  static const profile = AppRoute(name: 'profile', path: '/profile');
  static const editProfile = AppRoute(name: 'editProfile', path: 'edit');
  static const mySubmissions = AppRoute(
    name: 'mySubmissions',
    path: '/my-submissions',
  );
  static const noticeGroup = AppRoute(name: 'noticeGroup', path: '/notices');
  static const contributors = AppRoute(
    name: 'contributors',
    path: '/contributors',
  );

  //login
  static const login = AppRoute(name: 'login', path: '/login');

  //forgotPassword
  static const forgotPassword = AppRoute(
    name: 'forgotPassword',
    path: '/forgot-password',
  );

  static const changePassword = AppRoute(
    name: 'changePassword',
    path: 'change-password',
  );

  //register
  static const verification = AppRoute(
    name: 'verification',
    path: '/verification',
  );
  static const getVerificationCode = AppRoute(
    name: 'getVerificationCode',
    path: '/get-verification-code',
  );
  static const notifications = AppRoute(
    name: 'notifications',
    path: '/notifications',
  );
  static const notificationDetail = AppRoute(
    name: 'notificationDetail',
    path: '/notifications/:id',
  );
  static const contactWithCR = AppRoute(
    name: 'contactWithCR',
    path: '/contact-with-cr',
  );
  static const cacheManagement = AppRoute(
    name: 'cacheManagement',
    path: '/cache',
  );
  static const registration = AppRoute(
    name: 'register',
    path: '/register/:studentId',
  );
}
