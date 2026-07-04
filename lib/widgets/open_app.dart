import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenApp {
  //
  static Future<void> withUrl(String path) async {
    var url = Uri.parse(path);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //
  static Future<void> openPdf(String path) async {
    var url = Uri.parse(path);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //
  static Future<void> withNumber(String? number) async {
    if (number == null || number == '') {
      Fluttertoast.showToast(msg: 'No number found');
    } else {
      var url = Uri(scheme: 'tel', path: number);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  //
  static Future<void> withEmail(String? email) async {
    if (email == null || email == '') {
      Fluttertoast.showToast(msg: 'No email found');
    } else {
      var url = Uri(scheme: 'mailto', path: email);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }

  static Future<void> withEmailNew(String email, {String? subject, String? message}) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'No email found');
    } else {
      var url = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject= $subject&body=$message',
      );
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
  }
}
