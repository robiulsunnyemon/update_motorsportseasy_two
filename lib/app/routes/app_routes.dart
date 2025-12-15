part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const EVENT = _Paths.EVENT;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const RACING_DETAILS = _Paths.RACING_DETAILS;
  static const BOTTOM_NAVIGATION_BAR = _Paths.BOTTOM_NAVIGATION_BAR;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const REQUEST_RACE = _Paths.REQUEST_RACE;
  static const SUBSCRIPTION = _Paths.SUBSCRIPTION;
  static const OTP_VERIFICATION = _Paths.OTP_VERIFICATION;
  static const FORGET_PASSWORD = _Paths.FORGET_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const TERMS_AND_REGULATION = _Paths.TERMS_AND_REGULATION;
  static const REQUEST_FORM = _Paths.REQUEST_FORM;
  static const REPORT_FORM = _Paths.REPORT_FORM;
  static const PRIVACY = _Paths.PRIVACY;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const EVENT = '/event';
  static const NOTIFICATION = '/notification';
  static const RACING_DETAILS = '/racing-details';
  static const BOTTOM_NAVIGATION_BAR = '/bottom-navigation-bar';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const REQUEST_RACE = '/request-race';
  static const SUBSCRIPTION = '/subscription';
  static const OTP_VERIFICATION = '/otp-verification';
  static const FORGET_PASSWORD = '/forget-password';
  static const RESET_PASSWORD = '/reset-password';
  static const TERMS_AND_REGULATION = '/terms-and-regulation';
  static const REQUEST_FORM = '/request-form';
  static const REPORT_FORM = '/report-form';
  static const PRIVACY = '/privacy';
  static const PROFILE = '/profile';
}
