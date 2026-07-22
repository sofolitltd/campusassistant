import 'package:flutter/material.dart';

const kAppName = 'Campus Assistant';

/// Default number of items per page for paginated API requests.
const kDefaultPageSize = 20;

// theme color
const Color kPrimaryColor = Color(0xFFFFFFFF);
const Color kSecondaryColor = Color(0xFF000000);

const Color kContentLightColor = Color(0xFFE88F8F);
const Color kContentDarkColor = Color(0xFF1587EE);

// category card color
const Color kCardColor1 = Color(0xFF95E1D3);
const Color kCardColor2 = Color(0xFFEAFFD0);
const Color kCardColor3 = Color(0xFFFCE38A);
const Color kCardColor4 = Color(0xFFFFCCCC);

const List<String> kBottomNav = ['Home', 'Study', 'Profile'];

const List<String> kCourseCategory = [
  'Major Course',
  'Related Course',
  'Practical Course',
];

List kCourseType = ['Chapters', 'Videos', 'Books', 'Questions', 'Syllabus'];

List kArchive = ['Library', 'Research'];

// const List<String> kYearList = [
//   '1st Year',
//   '2nd Year',
//   '3rd Year',
//   '4th Year',
//   'Masters'
// ];

const List<String> kSessionList = ['17-18', '18-19', '19-20', '20-21'];
List<String> kStudentStatus = ['Regular', 'Irregular'];

List<String> kBloodGroup = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

//role
enum UserRole { admin, cr }

// developer info
const kDeveloperName = 'Md Asifuzzaman Reyad';
const kDeveloperId = '18608047';
const kDeveloperBatch = 'Batch 14';
const kDeveloperSession = 'Session: 17-18';
const kDeveloperMobile = '01704340860';
const kAppEmail = 'campusassistantbd@gmail.com';
const kDeveloperFb = 'https://www.facebook.com/asifuzzamanreyad';

// admin contact (shown as a fallback while a club request is pending review)
const kAdminContactName = kDeveloperName;
const kAdminContactPhone = kDeveloperMobile;
const kAdminContactEmail = kAppEmail;

// official fb gr
const kFbGroup = 'https://www.facebook.com/campusassistantbd';
const kYoutubeUrl = 'https://www.youtube.com/@campusassistantbd';
const kPlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.sofolit.campusassistant';

//
const kDevLogo =
    'https://sofolit.vercel.app/_next/image?url=%2Fimages%2Flogo-black.png&w=256&q=75';
const kDevWebsite = 'https://sofolit.vercel.com';
const kDevEmail = 'sofolitltd@gmail.com';
const kDevYoutube = 'https://youtube.com/@sofolitltd';

//
