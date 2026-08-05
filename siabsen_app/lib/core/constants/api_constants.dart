class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // 10.0.2.2 = localhost dari Android emulator

  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String checkIn = '/check-in';
  static const String checkOut = '/check-out';
  static const String history = '/attendances/history';
  static const String allAttendances = '/attendances/all';
  static const String dashboardSummary = '/dashboard/summary';
  static const String monthlyRecap = '/attendances/monthly-recap';
  static const String employees = '/employees';
}