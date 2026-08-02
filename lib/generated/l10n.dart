// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Please check your email for password reset instructions.`
  String get checkYourEmail {
    return Intl.message(
      'Please check your email for password reset instructions.',
      name: 'checkYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email address not found. Please try again.`
  String get emailNotFound {
    return Intl.message(
      'Email address not found. Please try again.',
      name: 'emailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Log out `
  String get logout {
    return Intl.message('Log out ', name: 'logout', desc: '', args: []);
  }

  /// `DataBase Name`
  String get dbName {
    return Intl.message('DataBase Name', name: 'dbName', desc: '', args: []);
  }

  /// ` Email`
  String get email {
    return Intl.message(' Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message('Remember me', name: 'rememberMe', desc: '', args: []);
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Control Board`
  String get controlBoard {
    return Intl.message(
      'Control Board',
      name: 'controlBoard',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Movements today`
  String get attendanceMovementsToday {
    return Intl.message(
      'Movements today',
      name: 'attendanceMovementsToday',
      desc: '',
      args: [],
    );
  }

  /// `Attendance `
  String get transaction {
    return Intl.message('Attendance ', name: 'transaction', desc: '', args: []);
  }

  /// `Approvals`
  String get approvals {
    return Intl.message('Approvals', name: 'approvals', desc: '', args: []);
  }

  /// `Salaries`
  String get salaries {
    return Intl.message('Salaries', name: 'salaries', desc: '', args: []);
  }

  /// `Times of work`
  String get timesOfWork {
    return Intl.message(
      'Times of work',
      name: 'timesOfWork',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message('Reports', name: 'reports', desc: '', args: []);
  }

  /// `Requests`
  String get myRequests {
    return Intl.message('Requests', name: 'myRequests', desc: '', args: []);
  }

  /// `Quick access list`
  String get quickAccessList {
    return Intl.message(
      'Quick access list',
      name: 'quickAccessList',
      desc: '',
      args: [],
    );
  }

  /// `Events and approvals`
  String get eventsApprovals {
    return Intl.message(
      'Events and approvals',
      name: 'eventsApprovals',
      desc: '',
      args: [],
    );
  }

  /// `Attendance`
  String get attendance {
    return Intl.message('Attendance', name: 'attendance', desc: '', args: []);
  }

  /// `Leaving`
  String get leaving {
    return Intl.message('Leaving', name: 'leaving', desc: '', args: []);
  }

  /// `Annual`
  String get annual {
    return Intl.message('Annual', name: 'annual', desc: '', args: []);
  }

  /// `ٌRecord presence and leave`
  String get recordPresenceAndLeave {
    return Intl.message(
      'ٌRecord presence and leave',
      name: 'recordPresenceAndLeave',
      desc: '',
      args: [],
    );
  }

  /// `Attendance recorded at `
  String get attendanceRecord {
    return Intl.message(
      'Attendance recorded at ',
      name: 'attendanceRecord',
      desc: '',
      args: [],
    );
  }

  /// `Leave recorded at `
  String get leaveRecord {
    return Intl.message(
      'Leave recorded at ',
      name: 'leaveRecord',
      desc: '',
      args: [],
    );
  }

  /// `Leave for reset`
  String get leaveForReset {
    return Intl.message(
      'Leave for reset',
      name: 'leaveForReset',
      desc: '',
      args: [],
    );
  }

  /// `Come from reset`
  String get comeFromReset {
    return Intl.message(
      'Come from reset',
      name: 'comeFromReset',
      desc: '',
      args: [],
    );
  }

  /// `Check-out `
  String get signOut {
    return Intl.message('Check-out ', name: 'signOut', desc: '', args: []);
  }

  /// `Check-in `
  String get signIn {
    return Intl.message('Check-in ', name: 'signIn', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Work Time`
  String get workTime {
    return Intl.message('Work Time', name: 'workTime', desc: '', args: []);
  }

  /// `My Location`
  String get location {
    return Intl.message('My Location', name: 'location', desc: '', args: []);
  }

  /// `from 9:00 A.M to 6:00 P.M`
  String get dailyWorkingHours {
    return Intl.message(
      'from 9:00 A.M to 6:00 P.M',
      name: 'dailyWorkingHours',
      desc: '',
      args: [],
    );
  }

  /// `Rest 60 minutes`
  String get restMinutes {
    return Intl.message(
      'Rest 60 minutes',
      name: 'restMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `please fill `
  String get pleaseFill {
    return Intl.message('please fill ', name: 'pleaseFill', desc: '', args: []);
  }

  /// `Request Leave`
  String get requestLeave {
    return Intl.message(
      'Request Leave',
      name: 'requestLeave',
      desc: '',
      args: [],
    );
  }

  /// `From Date `
  String get fromDate {
    return Intl.message('From Date ', name: 'fromDate', desc: '', args: []);
  }

  /// ` To Date`
  String get toDate {
    return Intl.message(' To Date', name: 'toDate', desc: '', args: []);
  }

  /// `Type of Leave`
  String get typeOfLeave {
    return Intl.message(
      'Type of Leave',
      name: 'typeOfLeave',
      desc: '',
      args: [],
    );
  }

  /// `Annual leave`
  String get annualLeave {
    return Intl.message(
      'Annual leave',
      name: 'annualLeave',
      desc: '',
      args: [],
    );
  }

  /// `Sick leave`
  String get sickLeave {
    return Intl.message('Sick leave', name: 'sickLeave', desc: '', args: []);
  }

  /// `Emergency leave`
  String get emergencyLeave {
    return Intl.message(
      'Emergency leave',
      name: 'emergencyLeave',
      desc: '',
      args: [],
    );
  }

  /// `Request Permission`
  String get RequestPermission {
    return Intl.message(
      'Request Permission',
      name: 'RequestPermission',
      desc: '',
      args: [],
    );
  }

  /// `Permission`
  String get permission {
    return Intl.message('Permission', name: 'permission', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `The start date must be before the end date`
  String get dateWarning {
    return Intl.message(
      'The start date must be before the end date',
      name: 'dateWarning',
      desc: '',
      args: [],
    );
  }

  /// `from`
  String get from {
    return Intl.message('from', name: 'from', desc: '', args: []);
  }

  /// `to`
  String get to {
    return Intl.message('to', name: 'to', desc: '', args: []);
  }

  /// `Attendance Time`
  String get attendanceTime {
    return Intl.message(
      'Attendance Time',
      name: 'attendanceTime',
      desc: '',
      args: [],
    );
  }

  /// `Leave Time`
  String get leaveTime {
    return Intl.message('Leave Time', name: 'leaveTime', desc: '', args: []);
  }

  /// `Work Hours`
  String get workHours {
    return Intl.message('Work Hours', name: 'workHours', desc: '', args: []);
  }

  /// `No Data Found`
  String get noDataFound {
    return Intl.message(
      'No Data Found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Performance Panel`
  String get performancePanel {
    return Intl.message(
      'Performance Panel',
      name: 'performancePanel',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message('Days', name: 'days', desc: '', args: []);
  }

  /// `A.M`
  String get am {
    return Intl.message('A.M', name: 'am', desc: '', args: []);
  }

  /// `P.M`
  String get pm {
    return Intl.message('P.M', name: 'pm', desc: '', args: []);
  }

  /// ` you not signIn yet`
  String get notAttendance {
    return Intl.message(
      ' you not signIn yet',
      name: 'notAttendance',
      desc: '',
      args: [],
    );
  }

  /// `you not signOut yet`
  String get notLeave {
    return Intl.message(
      'you not signOut yet',
      name: 'notLeave',
      desc: '',
      args: [],
    );
  }

  /// `Departures`
  String get departures {
    return Intl.message('Departures', name: 'departures', desc: '', args: []);
  }

  /// `bad response please login again`
  String get badeResponse {
    return Intl.message(
      'bad response please login again',
      name: 'badeResponse',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Attendance Reports`
  String get attendanceReports {
    return Intl.message(
      'Attendance Reports',
      name: 'attendanceReports',
      desc: '',
      args: [],
    );
  }

  /// `first shift`
  String get shift1 {
    return Intl.message('first shift', name: 'shift1', desc: '', args: []);
  }

  /// `second shift`
  String get shift2 {
    return Intl.message('second shift', name: 'shift2', desc: '', args: []);
  }

  /// `third shift`
  String get shift3 {
    return Intl.message('third shift', name: 'shift3', desc: '', args: []);
  }

  /// `fourth shift`
  String get shift4 {
    return Intl.message('fourth shift', name: 'shift4', desc: '', args: []);
  }

  /// `Hour`
  String get hours {
    return Intl.message('Hour', name: 'hours', desc: '', args: []);
  }

  /// `Temp`
  String get temporary {
    return Intl.message('Temp', name: 'temporary', desc: '', args: []);
  }

  /// `Day`
  String get fullDay {
    return Intl.message('Day', name: 'fullDay', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Permission Type`
  String get permissionType {
    return Intl.message(
      'Permission Type',
      name: 'permissionType',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// ` time format (7:00 , 12:30)`
  String get matchTimeFormat {
    return Intl.message(
      ' time format (7:00 , 12:30)',
      name: 'matchTimeFormat',
      desc: '',
      args: [],
    );
  }

  /// `The shift extends to the next day`
  String get shiftToSecondDay {
    return Intl.message(
      'The shift extends to the next day',
      name: 'shiftToSecondDay',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `OK`
  String get okDialog {
    return Intl.message('OK', name: 'okDialog', desc: '', args: []);
  }

  /// `Please select your holiday type `
  String get holidayNotSelected {
    return Intl.message(
      'Please select your holiday type ',
      name: 'holidayNotSelected',
      desc: '',
      args: [],
    );
  }

  /// ` No internet , check your connection and try again`
  String get noInternet {
    return Intl.message(
      ' No internet , check your connection and try again',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Are you shure you need log signOut? `
  String get needSignOut {
    return Intl.message(
      'Are you shure you need log signOut? ',
      name: 'needSignOut',
      desc: '',
      args: [],
    );
  }

  /// `Late time `
  String get lateTime {
    return Intl.message('Late time ', name: 'lateTime', desc: '', args: []);
  }

  /// `Extra Time`
  String get extraTime {
    return Intl.message('Extra Time', name: 'extraTime', desc: '', args: []);
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `Microfone`
  String get microfone {
    return Intl.message('Microfone', name: 'microfone', desc: '', args: []);
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Please read the line below clearly to confirm attendance. `
  String get readSentance {
    return Intl.message(
      'Please read the line below clearly to confirm attendance. ',
      name: 'readSentance',
      desc: '',
      args: [],
    );
  }

  /// `Record`
  String get record {
    return Intl.message('Record', name: 'record', desc: '', args: []);
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Play`
  String get play {
    return Intl.message('Play', name: 'play', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Branch`
  String get branch {
    return Intl.message('Branch', name: 'branch', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Request Number`
  String get requestNumber {
    return Intl.message(
      'Request Number',
      name: 'requestNumber',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get waiting {
    return Intl.message('Waiting', name: 'waiting', desc: '', args: []);
  }

  /// `Approved`
  String get approved {
    return Intl.message('Approved', name: 'approved', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Absence`
  String get absence {
    return Intl.message('Absence', name: 'absence', desc: '', args: []);
  }

  /// `Vacations`
  String get vacations {
    return Intl.message('Vacations', name: 'vacations', desc: '', args: []);
  }

  /// `Actual WorkingHours`
  String get actualWorkingHours {
    return Intl.message(
      'Actual WorkingHours',
      name: 'actualWorkingHours',
      desc: '',
      args: [],
    );
  }

  /// `Overall`
  String get overallReport {
    return Intl.message('Overall', name: 'overallReport', desc: '', args: []);
  }

  /// `Detailed`
  String get detailedReport {
    return Intl.message('Detailed', name: 'detailedReport', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Mobile`
  String get mobile {
    return Intl.message('Mobile', name: 'mobile', desc: '', args: []);
  }

  /// `Day Status`
  String get dayStatus {
    return Intl.message('Day Status', name: 'dayStatus', desc: '', args: []);
  }

  /// `are you sure you need delete this request`
  String get sureDelete {
    return Intl.message(
      'are you sure you need delete this request',
      name: 'sureDelete',
      desc: '',
      args: [],
    );
  }

  /// `Time Period`
  String get period {
    return Intl.message('Time Period', name: 'period', desc: '', args: []);
  }

  /// `Request Type`
  String get requestType {
    return Intl.message(
      'Request Type',
      name: 'requestType',
      desc: '',
      args: [],
    );
  }

  /// `Please wait until the current location data is loaded`
  String get waitLocation {
    return Intl.message(
      'Please wait until the current location data is loaded',
      name: 'waitLocation',
      desc: '',
      args: [],
    );
  }

  /// `click again to exit`
  String get exitApp {
    return Intl.message(
      'click again to exit',
      name: 'exitApp',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get userProfile {
    return Intl.message(
      'User Profile',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `Employee Definition`
  String get employeeDefinition {
    return Intl.message(
      'Employee Definition',
      name: 'employeeDefinition',
      desc: '',
      args: [],
    );
  }

  /// `Employee information`
  String get employeeInformation {
    return Intl.message(
      'Employee information',
      name: 'employeeInformation',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personalInformation {
    return Intl.message(
      'Personal information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Employee Name (Arabic)`
  String get employeeNameAr {
    return Intl.message(
      'Employee Name (Arabic)',
      name: 'employeeNameAr',
      desc: '',
      args: [],
    );
  }

  /// `Employee Name (English)`
  String get employeeNameEn {
    return Intl.message(
      'Employee Name (English)',
      name: 'employeeNameEn',
      desc: '',
      args: [],
    );
  }

  /// `Employee Code`
  String get employeeCode {
    return Intl.message(
      'Employee Code',
      name: 'employeeCode',
      desc: '',
      args: [],
    );
  }

  /// `Employee Email`
  String get employeeEmail {
    return Intl.message(
      'Employee Email',
      name: 'employeeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Employee Mobile`
  String get employeeMobile {
    return Intl.message(
      'Employee Mobile',
      name: 'employeeMobile',
      desc: '',
      args: [],
    );
  }

  /// `Employee Branch`
  String get employeeBranch {
    return Intl.message(
      'Employee Branch',
      name: 'employeeBranch',
      desc: '',
      args: [],
    );
  }

  /// `Employee Job`
  String get employeeJob {
    return Intl.message(
      'Employee Job',
      name: 'employeeJob',
      desc: '',
      args: [],
    );
  }

  /// `Employee Status`
  String get employeeStatus {
    return Intl.message(
      'Employee Status',
      name: 'employeeStatus',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `Branchs`
  String get branchs {
    return Intl.message('Branchs', name: 'branchs', desc: '', args: []);
  }

  /// `Shift`
  String get shift {
    return Intl.message('Shift', name: 'shift', desc: '', args: []);
  }

  /// `Section`
  String get section {
    return Intl.message('Section', name: 'section', desc: '', args: []);
  }

  /// `Group`
  String get group {
    return Intl.message('Group', name: 'group', desc: '', args: []);
  }

  /// `Department`
  String get department {
    return Intl.message('Department', name: 'department', desc: '', args: []);
  }

  /// `Direct Manager`
  String get directManager {
    return Intl.message(
      'Direct Manager',
      name: 'directManager',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message('Project', name: 'project', desc: '', args: []);
  }

  /// `Task`
  String get task {
    return Intl.message('Task', name: 'task', desc: '', args: []);
  }

  /// `Attendance Method`
  String get attendanceMethod {
    return Intl.message(
      'Attendance Method',
      name: 'attendanceMethod',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get nationality {
    return Intl.message('Nationality', name: 'nationality', desc: '', args: []);
  }

  /// `National ID`
  String get nationalId {
    return Intl.message('National ID', name: 'nationalId', desc: '', args: []);
  }

  /// `Religion`
  String get religion {
    return Intl.message('Religion', name: 'religion', desc: '', args: []);
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message('Birth Date', name: 'birthDate', desc: '', args: []);
  }

  /// `Phone Numbers`
  String get phoneNumbers {
    return Intl.message(
      'Phone Numbers',
      name: 'phoneNumbers',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Insert DataBase Name`
  String get insertDBName {
    return Intl.message(
      'Insert DataBase Name',
      name: 'insertDBName',
      desc: '',
      args: [],
    );
  }

  /// `Insert Email`
  String get insertEmail {
    return Intl.message(
      'Insert Email',
      name: 'insertEmail',
      desc: '',
      args: [],
    );
  }

  /// `Insert Password`
  String get insertPassword {
    return Intl.message(
      'Insert Password',
      name: 'insertPassword',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `Permissions`
  String get permissions {
    return Intl.message('Permissions', name: 'permissions', desc: '', args: []);
  }

  /// `Vacations`
  String get vaccations {
    return Intl.message('Vacations', name: 'vaccations', desc: '', args: []);
  }

  /// `Vacations Reports`
  String get vaccationsReports {
    return Intl.message(
      'Vacations Reports',
      name: 'vaccationsReports',
      desc: '',
      args: [],
    );
  }

  /// `Permissions Reports`
  String get permissionsReports {
    return Intl.message(
      'Permissions Reports',
      name: 'permissionsReports',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `You don’t have permission to access location, which is required to use the app. Would you like to request permission now?`
  String get requestLocationPermission {
    return Intl.message(
      'You don’t have permission to access location, which is required to use the app. Would you like to request permission now?',
      name: 'requestLocationPermission',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSetting {
    return Intl.message(
      'Open Settings',
      name: 'openSetting',
      desc: '',
      args: [],
    );
  }

  /// `Close App`
  String get closeApp {
    return Intl.message('Close App', name: 'closeApp', desc: '', args: []);
  }

  /// `Location Services Disabled`
  String get locationServicesDisabled {
    return Intl.message(
      'Location Services Disabled',
      name: 'locationServicesDisabled',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred. Please try again.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `Total vacation days`
  String get totalDays {
    return Intl.message(
      'Total vacation days',
      name: 'totalDays',
      desc: '',
      args: [],
    );
  }

  /// `Request  Fingerprint`
  String get requestFingerPrint {
    return Intl.message(
      'Request  Fingerprint',
      name: 'requestFingerPrint',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint`
  String get fingerPrint {
    return Intl.message('Fingerprint', name: 'fingerPrint', desc: '', args: []);
  }

  /// `Fingerprints`
  String get fingerPrints {
    return Intl.message(
      'Fingerprints',
      name: 'fingerPrints',
      desc: '',
      args: [],
    );
  }

  /// `Fingerprint Type`
  String get fingerPrintType {
    return Intl.message(
      'Fingerprint Type',
      name: 'fingerPrintType',
      desc: '',
      args: [],
    );
  }

  /// `Request sent successfully`
  String get requestSentSuccessfully {
    return Intl.message(
      'Request sent successfully',
      name: 'requestSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Request failed`
  String get requestFailed {
    return Intl.message(
      'Request failed',
      name: 'requestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please authenticate to login`
  String get PleaseAuthenticateToLogin {
    return Intl.message(
      'Please authenticate to login',
      name: 'PleaseAuthenticateToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Biometric authentication required!`
  String get biometricRequired {
    return Intl.message(
      'Oops! Biometric authentication required!',
      name: 'biometricRequired',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication is not available on this device.`
  String get biometricNotAvailable {
    return Intl.message(
      'Biometric authentication is not available on this device.',
      name: 'biometricNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No biometric credentials are enrolled. Please set up biometric authentication in your device settings.`
  String get biometricNotEnrolled {
    return Intl.message(
      'No biometric credentials are enrolled. Please set up biometric authentication in your device settings.',
      name: 'biometricNotEnrolled',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed. Please try again.`
  String get biometricAuthenticationFailed {
    return Intl.message(
      'Biometric authentication failed. Please try again.',
      name: 'biometricAuthenticationFailed',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during biometric authentication. Please try again.`
  String get biometricAuthenticationError {
    return Intl.message(
      'An error occurred during biometric authentication. Please try again.',
      name: 'biometricAuthenticationError',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication successful. Logging in...`
  String get biometricAuthenticationSuccess {
    return Intl.message(
      'Biometric authentication successful. Logging in...',
      name: 'biometricAuthenticationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication canceled by user.`
  String get biometricAuthenticationCanceled {
    return Intl.message(
      'Biometric authentication canceled by user.',
      name: 'biometricAuthenticationCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Too many failed attempts. Biometric authentication is temporarily locked out. Please try again later.`
  String get biometricAuthenticationLockout {
    return Intl.message(
      'Too many failed attempts. Biometric authentication is temporarily locked out. Please try again later.',
      name: 'biometricAuthenticationLockout',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication is already in progress. Please wait.`
  String get biometricAuthenticationInProgress {
    return Intl.message(
      'Biometric authentication is already in progress. Please wait.',
      name: 'biometricAuthenticationInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Location spoofing detected. The app will be closed.`
  String get locationSpoofingDetected {
    return Intl.message(
      'Location spoofing detected. The app will be closed.',
      name: 'locationSpoofingDetected',
      desc: '',
      args: [],
    );
  }

  /// `Security Warning`
  String get securityWarning {
    return Intl.message(
      'Security Warning',
      name: 'securityWarning',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully`
  String get savedSuccessfully {
    return Intl.message(
      'Saved successfully',
      name: 'savedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save. Please try again.`
  String get saveFailed {
    return Intl.message(
      'Failed to save. Please try again.',
      name: 'saveFailed',
      desc: '',
      args: [],
    );
  }

  /// `This company is not a restaurant.`
  String get notRestaurantCompany {
    return Intl.message(
      'This company is not a restaurant.',
      name: 'notRestaurantCompany',
      desc: '',
      args: [],
    );
  }

  /// `Dine-in `
  String get dineInOrder {
    return Intl.message('Dine-in ', name: 'dineInOrder', desc: '', args: []);
  }

  /// `Takeaway `
  String get takeawayOrder {
    return Intl.message('Takeaway ', name: 'takeawayOrder', desc: '', args: []);
  }

  /// `Pickup `
  String get deliveryOrder {
    return Intl.message('Pickup ', name: 'deliveryOrder', desc: '', args: []);
  }

  /// `Table`
  String get table {
    return Intl.message('Table', name: 'table', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Sales Screen`
  String get salesScreen {
    return Intl.message(
      'Sales Screen',
      name: 'salesScreen',
      desc: '',
      args: [],
    );
  }

  /// ` To Restaurant`
  String get toRestaurant {
    return Intl.message(
      ' To Restaurant',
      name: 'toRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message('Pay', name: 'pay', desc: '', args: []);
  }

  /// `Floors`
  String get floors {
    return Intl.message('Floors', name: 'floors', desc: '', args: []);
  }

  /// `Tables`
  String get tables {
    return Intl.message('Tables', name: 'tables', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `VAT`
  String get vat {
    return Intl.message('VAT', name: 'vat', desc: '', args: []);
  }

  /// `Tax`
  String get tax {
    return Intl.message('Tax', name: 'tax', desc: '', args: []);
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `No Add-ons`
  String get noAddons {
    return Intl.message('No Add-ons', name: 'noAddons', desc: '', args: []);
  }

  /// `Tap an item to add it to the order`
  String get tapAnyItemToAdd {
    return Intl.message(
      'Tap an item to add it to the order',
      name: 'tapAnyItemToAdd',
      desc: '',
      args: [],
    );
  }

  /// `POS`
  String get pos {
    return Intl.message('POS', name: 'pos', desc: '', args: []);
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Active Now`
  String get activeNow {
    return Intl.message('Active Now', name: 'activeNow', desc: '', args: []);
  }

  /// `Not Active`
  String get notActive {
    return Intl.message('Not Active', name: 'notActive', desc: '', args: []);
  }

  /// `Current Order`
  String get currentOrder {
    return Intl.message(
      'Current Order',
      name: 'currentOrder',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Confirm additives`
  String get confirmAdditives {
    return Intl.message(
      'Confirm additives',
      name: 'confirmAdditives',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `Add Additives`
  String get addAdditives {
    return Intl.message(
      'Add Additives',
      name: 'addAdditives',
      desc: '',
      args: [],
    );
  }

  /// `Tap items to select`
  String get tapItemsToSelect {
    return Intl.message(
      'Tap items to select',
      name: 'tapItemsToSelect',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get sar {
    return Intl.message('SAR', name: 'sar', desc: '', args: []);
  }

  /// `Please select the required action to continue`
  String get homeSubtitle {
    return Intl.message(
      'Please select the required action to continue',
      name: 'homeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Access the dashboard, orders and sales`
  String get salesScreenSubtitle {
    return Intl.message(
      'Access the dashboard, orders and sales',
      name: 'salesScreenSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Please check in first`
  String get pleaseCheckInFirst {
    return Intl.message(
      'Please check in first',
      name: 'pleaseCheckInFirst',
      desc: '',
      args: [],
    );
  }

  /// `Check in to start your new work shift`
  String get signInSubtitle {
    return Intl.message(
      'Check in to start your new work shift',
      name: 'signInSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Shift has not started yet`
  String get shiftNotStarted {
    return Intl.message(
      'Shift has not started yet',
      name: 'shiftNotStarted',
      desc: '',
      args: [],
    );
  }

  /// `Current status: Off shift`
  String get currentStatusOffShift {
    return Intl.message(
      'Current status: Off shift',
      name: 'currentStatusOffShift',
      desc: '',
      args: [],
    );
  }

  /// `Last check out`
  String get lastCheckOut {
    return Intl.message(
      'Last check out',
      name: 'lastCheckOut',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday, 11:30 PM`
  String get lastCheckOutValue {
    return Intl.message(
      'Yesterday, 11:30 PM',
      name: 'lastCheckOutValue',
      desc: '',
      args: [],
    );
  }

  /// `System time`
  String get systemTime {
    return Intl.message('System time', name: 'systemTime', desc: '', args: []);
  }

  /// `Shift Start`
  String get shiftStart {
    return Intl.message('Shift Start', name: 'shiftStart', desc: '', args: []);
  }

  /// `Opening Cash`
  String get openingCash {
    return Intl.message(
      'Opening Cash',
      name: 'openingCash',
      desc: '',
      args: [],
    );
  }

  /// `Notes (optional)`
  String get optionalNotes {
    return Intl.message(
      'Notes (optional)',
      name: 'optionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `Add your notes here...`
  String get addNotesHint {
    return Intl.message(
      'Add your notes here...',
      name: 'addNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Save and Open Shift`
  String get saveAndOpenShift {
    return Intl.message(
      'Save and Open Shift',
      name: 'saveAndOpenShift',
      desc: '',
      args: [],
    );
  }

  /// `Select Branch`
  String get selectBranch {
    return Intl.message(
      'Select Branch',
      name: 'selectBranch',
      desc: '',
      args: [],
    );
  }

  /// `Choose Delivery Company`
  String get chooseDeliveryCompany {
    return Intl.message(
      'Choose Delivery Company',
      name: 'chooseDeliveryCompany',
      desc: '',
      args: [],
    );
  }

  /// `Select Invoice Type`
  String get selectInvoiceType {
    return Intl.message(
      'Select Invoice Type',
      name: 'selectInvoiceType',
      desc: '',
      args: [],
    );
  }

  /// `DeliveryCompany`
  String get deliveryCompany {
    return Intl.message(
      'DeliveryCompany',
      name: 'deliveryCompany',
      desc: '',
      args: [],
    );
  }

  /// `Session Expired`
  String get sessionExpired {
    return Intl.message(
      'Session Expired',
      name: 'sessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOutTitle {
    return Intl.message('Sign Out', name: 'signOutTitle', desc: '', args: []);
  }

  /// `Identity Confirmed`
  String get identityConfirmed {
    return Intl.message(
      'Identity Confirmed',
      name: 'identityConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Verification Failed`
  String get verificationFailed {
    return Intl.message(
      'Verification Failed',
      name: 'verificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Action`
  String get confirmAction {
    return Intl.message(
      'Confirm Action',
      name: 'confirmAction',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message('Notice', name: 'notice', desc: '', args: []);
  }

  /// `Verified`
  String get verified {
    return Intl.message('Verified', name: 'verified', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Access Denied`
  String get accessDenied {
    return Intl.message(
      'Access Denied',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Total Amount Required`
  String get totalAmountRequired {
    return Intl.message(
      'Total Amount Required',
      name: 'totalAmountRequired',
      desc: '',
      args: [],
    );
  }

  /// `SAR`
  String get currencySar {
    return Intl.message('SAR', name: 'currencySar', desc: '', args: []);
  }

  /// `SAR`
  String get currencySarShort {
    return Intl.message('SAR', name: 'currencySarShort', desc: '', args: []);
  }

  /// `Cash`
  String get paymentMethodCash {
    return Intl.message('Cash', name: 'paymentMethodCash', desc: '', args: []);
  }

  /// `Card`
  String get paymentMethodCard {
    return Intl.message('Card', name: 'paymentMethodCard', desc: '', args: []);
  }

  /// `... Other`
  String get paymentMethodOther {
    return Intl.message(
      '... Other',
      name: 'paymentMethodOther',
      desc: '',
      args: [],
    );
  }

  /// `Amount Due`
  String get amountDue {
    return Intl.message('Amount Due', name: 'amountDue', desc: '', args: []);
  }

  /// `Amount Paid`
  String get amountPaid {
    return Intl.message('Amount Paid', name: 'amountPaid', desc: '', args: []);
  }

  /// `Remaining`
  String get amountRemaining {
    return Intl.message(
      'Remaining',
      name: 'amountRemaining',
      desc: '',
      args: [],
    );
  }

  /// `Reference Number`
  String get referenceNumber {
    return Intl.message(
      'Reference Number',
      name: 'referenceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter transaction number .....`
  String get enterTransactionNumber {
    return Intl.message(
      'Enter transaction number .....',
      name: 'enterTransactionNumber',
      desc: '',
      args: [],
    );
  }

  /// `Visa`
  String get paymentMethodVisa {
    return Intl.message('Visa', name: 'paymentMethodVisa', desc: '', args: []);
  }

  /// `Bank Transfer`
  String get paymentMethodBankTransfer {
    return Intl.message(
      'Bank Transfer',
      name: 'paymentMethodBankTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Loyalty Points`
  String get paymentMethodLoyaltyPoints {
    return Intl.message(
      'Loyalty Points',
      name: 'paymentMethodLoyaltyPoints',
      desc: '',
      args: [],
    );
  }

  /// `Voucher`
  String get paymentMethodVoucher {
    return Intl.message(
      'Voucher',
      name: 'paymentMethodVoucher',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get paymentMethodCredit {
    return Intl.message(
      'Credit',
      name: 'paymentMethodCredit',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Order No.`
  String get orderNumber {
    return Intl.message('Order No.', name: 'orderNumber', desc: '', args: []);
  }

  /// `Invoice No.`
  String get invoiceNumber {
    return Intl.message(
      'Invoice No.',
      name: 'invoiceNumber',
      desc: '',
      args: [],
    );
  }

  /// `Takeaway`
  String get takeaway {
    return Intl.message('Takeaway', name: 'takeaway', desc: '', args: []);
  }

  /// `Dine-in`
  String get dineIn {
    return Intl.message('Dine-in', name: 'dineIn', desc: '', args: []);
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Delivery Companies`
  String get deliveryCompanies {
    return Intl.message(
      'Delivery Companies',
      name: 'deliveryCompanies',
      desc: '',
      args: [],
    );
  }

  /// `Registered Customer`
  String get registeredCustomer {
    return Intl.message(
      'Registered Customer',
      name: 'registeredCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Add Customer`
  String get addCustomer {
    return Intl.message(
      'Add Customer',
      name: 'addCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Select Waiter`
  String get selectWaiter {
    return Intl.message(
      'Select Waiter',
      name: 'selectWaiter',
      desc: '',
      args: [],
    );
  }

  /// `Select Table`
  String get selectTable {
    return Intl.message(
      'Select Table',
      name: 'selectTable',
      desc: '',
      args: [],
    );
  }

  /// `Select Delivery Agent`
  String get selectDeliveryAgent {
    return Intl.message(
      'Select Delivery Agent',
      name: 'selectDeliveryAgent',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Company Info`
  String get deliveryCompanyDetails {
    return Intl.message(
      'Delivery Company Info',
      name: 'deliveryCompanyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Size: {size}`
  String sizeWithVal(Object size) {
    return Intl.message(
      'Size: $size',
      name: 'sizeWithVal',
      desc: '',
      args: [size],
    );
  }

  /// `Add-ons: {addons}`
  String addonsWithVal(Object addons) {
    return Intl.message(
      'Add-ons: $addons',
      name: 'addonsWithVal',
      desc: '',
      args: [addons],
    );
  }

  /// `Notes: {notes}`
  String notesWithVal(Object notes) {
    return Intl.message(
      'Notes: $notes',
      name: 'notesWithVal',
      desc: '',
      args: [notes],
    );
  }

  /// `Coupon`
  String get coupon {
    return Intl.message('Coupon', name: 'coupon', desc: '', args: []);
  }

  /// `Direct Discount`
  String get directDiscount {
    return Intl.message(
      'Direct Discount',
      name: 'directDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Enter discount code`
  String get enterDiscountCode {
    return Intl.message(
      'Enter discount code',
      name: 'enterDiscountCode',
      desc: '',
      args: [],
    );
  }

  /// `Discount (Coupon)`
  String get discountCoupon {
    return Intl.message(
      'Discount (Coupon)',
      name: 'discountCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery Fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `VAT (15%)`
  String get vat15 {
    return Intl.message('VAT (15%)', name: 'vat15', desc: '', args: []);
  }

  /// `Grand Total`
  String get grandTotal {
    return Intl.message('Grand Total', name: 'grandTotal', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `Hold Order`
  String get holdOrder {
    return Intl.message('Hold Order', name: 'holdOrder', desc: '', args: []);
  }

  /// `Shopping Cart`
  String get shoppingCart {
    return Intl.message(
      'Shopping Cart',
      name: 'shoppingCart',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  }

  /// `Add to Cart {price} SAR`
  String addToCartWithPrice(Object price) {
    return Intl.message(
      'Add to Cart $price SAR',
      name: 'addToCartWithPrice',
      desc: '',
      args: [price],
    );
  }

  /// `{count, plural, =1{1 Item} other{{count} Items}}`
  String itemsCount(num count) {
    return Intl.plural(
      count,
      one: '1 Item',
      other: '$count Items',
      name: 'itemsCount',
      desc: '',
      args: [count],
    );
  }

  /// `View Cart`
  String get viewCart {
    return Intl.message('View Cart', name: 'viewCart', desc: '', args: []);
  }

  /// `Percentage (%)`
  String get percentageDiscount {
    return Intl.message(
      'Percentage (%)',
      name: 'percentageDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Fixed Amount`
  String get fixedAmountDiscount {
    return Intl.message(
      'Fixed Amount',
      name: 'fixedAmountDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get popular {
    return Intl.message('Popular', name: 'popular', desc: '', args: []);
  }

  /// `Free`
  String get free {
    return Intl.message('Free', name: 'free', desc: '', args: []);
  }

  /// `+{price} SAR`
  String plusPriceWithCurrency(Object price) {
    return Intl.message(
      '+$price SAR',
      name: 'plusPriceWithCurrency',
      desc: '',
      args: [price],
    );
  }

  /// `Select the appropriate size and desired add-ons`
  String get customizationSubtitle {
    return Intl.message(
      'Select the appropriate size and desired add-ons',
      name: 'customizationSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Product Size`
  String get productSize {
    return Intl.message(
      'Product Size',
      name: 'productSize',
      desc: '',
      args: [],
    );
  }

  /// `Add-ons`
  String get addons {
    return Intl.message('Add-ons', name: 'addons', desc: '', args: []);
  }

  /// `Special Discount`
  String get specialDiscount {
    return Intl.message(
      'Special Discount',
      name: 'specialDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Enter discount value`
  String get enterDiscountValue {
    return Intl.message(
      'Enter discount value',
      name: 'enterDiscountValue',
      desc: '',
      args: [],
    );
  }

  /// `Special Notes`
  String get specialNotes {
    return Intl.message(
      'Special Notes',
      name: 'specialNotes',
      desc: '',
      args: [],
    );
  }

  /// `Example: Extra cooked, put sauce on the side...`
  String get specialNotesHint {
    return Intl.message(
      'Example: Extra cooked, put sauce on the side...',
      name: 'specialNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `{price} SAR`
  String priceWithCurrency(Object price) {
    return Intl.message(
      '$price SAR',
      name: 'priceWithCurrency',
      desc: '',
      args: [price],
    );
  }

  /// `Settings`
  String get navSettings {
    return Intl.message('Settings', name: 'navSettings', desc: '', args: []);
  }

  /// `Cart`
  String get navCart {
    return Intl.message('Cart', name: 'navCart', desc: '', args: []);
  }

  /// `Orders`
  String get navOrders {
    return Intl.message('Orders', name: 'navOrders', desc: '', args: []);
  }

  /// `Menu`
  String get navMenu {
    return Intl.message('Menu', name: 'navMenu', desc: '', args: []);
  }

  /// `All`
  String get filterAll {
    return Intl.message('All', name: 'filterAll', desc: '', args: []);
  }

  /// `🔥 Best Seller`
  String get filterBestSeller {
    return Intl.message(
      '🔥 Best Seller',
      name: 'filterBestSeller',
      desc: '',
      args: [],
    );
  }

  /// `⭐ Favorites`
  String get filterFavorites {
    return Intl.message(
      '⭐ Favorites',
      name: 'filterFavorites',
      desc: '',
      args: [],
    );
  }

  /// `🆕 New`
  String get filterNew {
    return Intl.message('🆕 New', name: 'filterNew', desc: '', args: []);
  }

  /// `🎁 Today's Offers`
  String get filterTodayOffers {
    return Intl.message(
      '🎁 Today\'s Offers',
      name: 'filterTodayOffers',
      desc: '',
      args: [],
    );
  }

  /// `Offer`
  String get badgeOffer {
    return Intl.message('Offer', name: 'badgeOffer', desc: '', args: []);
  }

  /// `New`
  String get badgeNew {
    return Intl.message('New', name: 'badgeNew', desc: '', args: []);
  }

  /// `Restaurant Manager`
  String get restaurantManager {
    return Intl.message(
      'Restaurant Manager',
      name: 'restaurantManager',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful`
  String get paymentSuccessful {
    return Intl.message(
      'Payment Successful',
      name: 'paymentSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Order processed successfully and sent to kitchen`
  String get orderProcessedSuccessfully {
    return Intl.message(
      'Order processed successfully and sent to kitchen',
      name: 'orderProcessedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount Paid`
  String get totalPaid {
    return Intl.message(
      'Total Amount Paid',
      name: 'totalPaid',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Date`
  String get transactionDate {
    return Intl.message(
      'Transaction Date',
      name: 'transactionDate',
      desc: '',
      args: [],
    );
  }

  /// `{year}/{month}/{day} - {hour}:{minute}`
  String formattedDateTime(
    Object year,
    Object month,
    Object day,
    Object hour,
    Object minute,
  ) {
    return Intl.message(
      '$year/$month/$day - $hour:$minute',
      name: 'formattedDateTime',
      desc: '',
      args: [year, month, day, hour, minute],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Qty: {quantity}`
  String quantityWithCount(Object quantity) {
    return Intl.message(
      'Qty: $quantity',
      name: 'quantityWithCount',
      desc: '',
      args: [quantity],
    );
  }

  /// `New Order`
  String get btnNewOrder {
    return Intl.message('New Order', name: 'btnNewOrder', desc: '', args: []);
  }

  /// `Print Receipt`
  String get btnPrintReceipt {
    return Intl.message(
      'Print Receipt',
      name: 'btnPrintReceipt',
      desc: '',
      args: [],
    );
  }

  /// `Print Kitchen`
  String get btnPrintKitchen {
    return Intl.message(
      'Print Kitchen',
      name: 'btnPrintKitchen',
      desc: '',
      args: [],
    );
  }

  /// `Previous Orders`
  String get btnPreviousOrders {
    return Intl.message(
      'Previous Orders',
      name: 'btnPreviousOrders',
      desc: '',
      args: [],
    );
  }

  /// `Previous Orders`
  String get previousOrders {
    return Intl.message(
      'Previous Orders',
      name: 'previousOrders',
      desc: '',
      args: [],
    );
  }

  /// `Held Orders`
  String get heldOrders {
    return Intl.message('Held Orders', name: 'heldOrders', desc: '', args: []);
  }

  /// `Invoice Number`
  String get invoiceNumberLabel {
    return Intl.message(
      'Invoice Number',
      name: 'invoiceNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Ex: INV-1024`
  String get invoiceNumberHint {
    return Intl.message(
      'Ex: INV-1024',
      name: 'invoiceNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name`
  String get customerNameLabel {
    return Intl.message(
      'Customer Name',
      name: 'customerNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Customer Name or Mobile`
  String get customerNameHint {
    return Intl.message(
      'Customer Name or Mobile',
      name: 'customerNameHint',
      desc: '',
      args: [],
    );
  }

  /// `mm/dd/yyyy`
  String get datePlaceholder {
    return Intl.message(
      'mm/dd/yyyy',
      name: 'datePlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Print`
  String get print {
    return Intl.message('Print', name: 'print', desc: '', args: []);
  }

  /// `Total Held Orders`
  String get totalHeldOrders {
    return Intl.message(
      'Total Held Orders',
      name: 'totalHeldOrders',
      desc: '',
      args: [],
    );
  }

  /// `{count} Orders`
  String ordersCount(Object count) {
    return Intl.message(
      '$count Orders',
      name: 'ordersCount',
      desc: '',
      args: [count],
    );
  }

  /// `1 Item`
  String get singleItemCount {
    return Intl.message('1 Item', name: 'singleItemCount', desc: '', args: []);
  }

  /// `Restore Order`
  String get restoreOrder {
    return Intl.message(
      'Restore Order',
      name: 'restoreOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delete Order`
  String get deleteOrder {
    return Intl.message(
      'Delete Order',
      name: 'deleteOrder',
      desc: '',
      args: [],
    );
  }

  /// `Reservations`
  String get reservations {
    return Intl.message(
      'Reservations',
      name: 'reservations',
      desc: '',
      args: [],
    );
  }

  /// `Table Arrangement`
  String get tableArrangement {
    return Intl.message(
      'Table Arrangement',
      name: 'tableArrangement',
      desc: '',
      args: [],
    );
  }

  /// `1st Floor`
  String get firstFloor {
    return Intl.message('1st Floor', name: 'firstFloor', desc: '', args: []);
  }

  /// `2nd Floor`
  String get secondFloor {
    return Intl.message('2nd Floor', name: 'secondFloor', desc: '', args: []);
  }

  /// `Indoor Terrace`
  String get indoorTerrace {
    return Intl.message(
      'Indoor Terrace',
      name: 'indoorTerrace',
      desc: '',
      args: [],
    );
  }

  /// `Outdoor Area`
  String get outdoorArea {
    return Intl.message(
      'Outdoor Area',
      name: 'outdoorArea',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Reserved`
  String get reserved {
    return Intl.message('Reserved', name: 'reserved', desc: '', args: []);
  }

  /// `seats`
  String get seats {
    return Intl.message('seats', name: 'seats', desc: '', args: []);
  }

  /// `Add New Reservation`
  String get addNewReservation {
    return Intl.message(
      'Add New Reservation',
      name: 'addNewReservation',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message('Floor', name: 'floor', desc: '', args: []);
  }

  /// `Customer Name`
  String get customerName {
    return Intl.message(
      'Customer Name',
      name: 'customerName',
      desc: '',
      args: [],
    );
  }

  /// `mm/dd/yyyy`
  String get dateFormatHint {
    return Intl.message(
      'mm/dd/yyyy',
      name: 'dateFormatHint',
      desc: '',
      args: [],
    );
  }

  /// `hh:mm`
  String get timeFormatHint {
    return Intl.message('hh:mm', name: 'timeFormatHint', desc: '', args: []);
  }

  /// `No reservations found`
  String get noReservations {
    return Intl.message(
      'No reservations found',
      name: 'noReservations',
      desc: '',
      args: [],
    );
  }

  /// `Seats / Duration`
  String get seatsAndDurationHeader {
    return Intl.message(
      'Seats / Duration',
      name: 'seatsAndDurationHeader',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get hour {
    return Intl.message('hour', name: 'hour', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Enter customer name`
  String get enterCustomerNameHint {
    return Intl.message(
      'Enter customer name',
      name: 'enterCustomerNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Select table`
  String get selectTableHint {
    return Intl.message(
      'Select table',
      name: 'selectTableHint',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Number of Guests`
  String get guestsCount {
    return Intl.message(
      'Number of Guests',
      name: 'guestsCount',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 3`
  String get guestsCountHint {
    return Intl.message('e.g. 3', name: 'guestsCountHint', desc: '', args: []);
  }

  /// `Additional Notes`
  String get additionalNotes {
    return Intl.message(
      'Additional Notes',
      name: 'additionalNotes',
      desc: '',
      args: [],
    );
  }

  /// `Write operation details here...`
  String get additionalNotesHint {
    return Intl.message(
      'Write operation details here...',
      name: 'additionalNotesHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Reservation`
  String get confirmReservation {
    return Intl.message(
      'Confirm Reservation',
      name: 'confirmReservation',
      desc: '',
      args: [],
    );
  }

  /// `Walk-in Customer`
  String get cashCustomer {
    return Intl.message(
      'Walk-in Customer',
      name: 'cashCustomer',
      desc: '',
      args: [],
    );
  }

  /// `No Tables Available`
  String get noTablesAvailable {
    return Intl.message(
      'No Tables Available',
      name: 'noTablesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Cashier Custody`
  String get cashierCustody {
    return Intl.message(
      'Cashier Custody',
      name: 'cashierCustody',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get returns {
    return Intl.message('Returns', name: 'returns', desc: '', args: []);
  }

  /// `Close Custody`
  String get closeCustody {
    return Intl.message(
      'Close Custody',
      name: 'closeCustody',
      desc: '',
      args: [],
    );
  }

  /// `Suspend Session`
  String get suspendSession {
    return Intl.message(
      'Suspend Session',
      name: 'suspendSession',
      desc: '',
      args: [],
    );
  }

  /// `Close Session`
  String get closeSession {
    return Intl.message(
      'Close Session',
      name: 'closeSession',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Custody Log`
  String get custodyLog {
    return Intl.message('Custody Log', name: 'custodyLog', desc: '', args: []);
  }

  /// `Recent Transactions Summary`
  String get recentTransactionsSummary {
    return Intl.message(
      'Recent Transactions Summary',
      name: 'recentTransactionsSummary',
      desc: '',
      args: [],
    );
  }

  /// `Add Balance`
  String get addBalance {
    return Intl.message('Add Balance', name: 'addBalance', desc: '', args: []);
  }

  /// `Expense Withdrawal`
  String get withdrawExpenses {
    return Intl.message(
      'Expense Withdrawal',
      name: 'withdrawExpenses',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} min ago`
  String minutesAgo(Object minutes) {
    return Intl.message(
      '$minutes min ago',
      name: 'minutesAgo',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours} hours ago`
  String hoursAgo(Object hours) {
    return Intl.message(
      '$hours hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [hours],
    );
  }

  /// `View Full Custody Log`
  String get viewFullCustodyLog {
    return Intl.message(
      'View Full Custody Log',
      name: 'viewFullCustodyLog',
      desc: '',
      args: [],
    );
  }

  /// `Add Custody`
  String get addCustody {
    return Intl.message('Add Custody', name: 'addCustody', desc: '', args: []);
  }

  /// `Withdraw Custody`
  String get withdrawCustody {
    return Intl.message(
      'Withdraw Custody',
      name: 'withdrawCustody',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Operation Reason`
  String get operationReason {
    return Intl.message(
      'Operation Reason',
      name: 'operationReason',
      desc: '',
      args: [],
    );
  }

  /// `Select reason`
  String get selectReason {
    return Intl.message(
      'Select reason',
      name: 'selectReason',
      desc: '',
      args: [],
    );
  }

  /// `Opening Custody`
  String get openingCustody {
    return Intl.message(
      'Opening Custody',
      name: 'openingCustody',
      desc: '',
      args: [],
    );
  }

  /// `Expense Reimbursement`
  String get expenseReimbursement {
    return Intl.message(
      'Expense Reimbursement',
      name: 'expenseReimbursement',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Enter operation details here...`
  String get writeOperationDetailsHint {
    return Intl.message(
      'Enter operation details here...',
      name: 'writeOperationDetailsHint',
      desc: '',
      args: [],
    );
  }

  /// `Attach Receipt or Invoice`
  String get attachReceiptOrInvoice {
    return Intl.message(
      'Attach Receipt or Invoice',
      name: 'attachReceiptOrInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Click to upload file`
  String get clickToUploadFile {
    return Intl.message(
      'Click to upload file',
      name: 'clickToUploadFile',
      desc: '',
      args: [],
    );
  }

  /// `(JPG, PNG, PDF max size 5MB)`
  String get maxFileSizeHint {
    return Intl.message(
      '(JPG, PNG, PDF max size 5MB)',
      name: 'maxFileSizeHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Transaction`
  String get confirmTransaction {
    return Intl.message(
      'Confirm Transaction',
      name: 'confirmTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Current Available Balance`
  String get currentAvailableBalance {
    return Intl.message(
      'Current Available Balance',
      name: 'currentAvailableBalance',
      desc: '',
      args: [],
    );
  }

  /// `Total Withdrawals`
  String get totalWithdrawals {
    return Intl.message(
      'Total Withdrawals',
      name: 'totalWithdrawals',
      desc: '',
      args: [],
    );
  }

  /// `Total Additions`
  String get totalAdditions {
    return Intl.message(
      'Total Additions',
      name: 'totalAdditions',
      desc: '',
      args: [],
    );
  }

  /// `Additions`
  String get additions {
    return Intl.message('Additions', name: 'additions', desc: '', args: []);
  }

  /// `Withdrawals`
  String get withdrawals {
    return Intl.message('Withdrawals', name: 'withdrawals', desc: '', args: []);
  }

  /// `Export CSV`
  String get exportCsv {
    return Intl.message('Export CSV', name: 'exportCsv', desc: '', args: []);
  }

  /// `Transaction Log`
  String get transactionLog {
    return Intl.message(
      'Transaction Log',
      name: 'transactionLog',
      desc: '',
      args: [],
    );
  }

  /// `Opening Custody`
  String get openingCustodyTitle {
    return Intl.message(
      'Opening Custody',
      name: 'openingCustodyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Petty Expenses`
  String get pettyExpenses {
    return Intl.message(
      'Petty Expenses',
      name: 'pettyExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Transfer from Management`
  String get transferFromManagement {
    return Intl.message(
      'Transfer from Management',
      name: 'transferFromManagement',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Payment`
  String get supplierPayment {
    return Intl.message(
      'Supplier Payment',
      name: 'supplierPayment',
      desc: '',
      args: [],
    );
  }

  /// `Addition`
  String get additionTag {
    return Intl.message('Addition', name: 'additionTag', desc: '', args: []);
  }

  /// `Withdrawal`
  String get withdrawalTag {
    return Intl.message(
      'Withdrawal',
      name: 'withdrawalTag',
      desc: '',
      args: [],
    );
  }

  /// `e.g., INV-1024`
  String get invoiceNumberExample {
    return Intl.message(
      'e.g., INV-1024',
      name: 'invoiceNumberExample',
      desc: '',
      args: [],
    );
  }

  /// `{count} Item`
  String itemCountSingle(Object count) {
    return Intl.message(
      '$count Item',
      name: 'itemCountSingle',
      desc: '',
      args: [count],
    );
  }

  /// `Full Return`
  String get fullReturn {
    return Intl.message('Full Return', name: 'fullReturn', desc: '', args: []);
  }

  /// `Partial Return`
  String get partialReturn {
    return Intl.message(
      'Partial Return',
      name: 'partialReturn',
      desc: '',
      args: [],
    );
  }

  /// `Reservation Period`
  String get reservationPeriod {
    return Intl.message(
      'Reservation Period',
      name: 'reservationPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Select Reservation Period`
  String get selectReservationPeriod {
    return Intl.message(
      'Select Reservation Period',
      name: 'selectReservationPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Reservation Period ({minutes} min)`
  String reservationPeriodInMinutes(Object minutes) {
    return Intl.message(
      'Reservation Period ($minutes min)',
      name: 'reservationPeriodInMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `Please select both date and time`
  String get selectDateAndTimeError {
    return Intl.message(
      'Please select both date and time',
      name: 'selectDateAndTimeError',
      desc: '',
      args: [],
    );
  }

  /// `Reservation added successfully`
  String get reservationSuccess {
    return Intl.message(
      'Reservation added successfully',
      name: 'reservationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Add New Customer`
  String get addNewCustomer {
    return Intl.message(
      'Add New Customer',
      name: 'addNewCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Alternate Phone (optional)`
  String get alternatePhoneOptional {
    return Intl.message(
      'Alternate Phone (optional)',
      name: 'alternatePhoneOptional',
      desc: '',
      args: [],
    );
  }

  /// `Customer Addresses`
  String get customerAddresses {
    return Intl.message(
      'Customer Addresses',
      name: 'customerAddresses',
      desc: '',
      args: [],
    );
  }

  /// `You can add more than one address for the customer`
  String get addMoreAddressesHint {
    return Intl.message(
      'You can add more than one address for the customer',
      name: 'addMoreAddressesHint',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `District`
  String get district {
    return Intl.message('District', name: 'district', desc: '', args: []);
  }

  /// `Street Name`
  String get streetName {
    return Intl.message('Street Name', name: 'streetName', desc: '', args: []);
  }

  /// `Building Number`
  String get buildingNumber {
    return Intl.message(
      'Building Number',
      name: 'buildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Apartment Number`
  String get apartmentNumber {
    return Intl.message(
      'Apartment Number',
      name: 'apartmentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add Another Address`
  String get addAnotherAddress {
    return Intl.message(
      'Add Another Address',
      name: 'addAnotherAddress',
      desc: '',
      args: [],
    );
  }

  /// `No customer selected`
  String get noCustomerSelected {
    return Intl.message(
      'No customer selected',
      name: 'noCustomerSelected',
      desc: '',
      args: [],
    );
  }

  /// `Select Customer`
  String get selectCustomer {
    return Intl.message(
      'Select Customer',
      name: 'selectCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Search by name or phone`
  String get searchCustomerHint {
    return Intl.message(
      'Search by name or phone',
      name: 'searchCustomerHint',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Edit Customer`
  String get editCustomer {
    return Intl.message(
      'Edit Customer',
      name: 'editCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Is Default Address`
  String get isDefaultAddress {
    return Intl.message(
      'Is Default Address',
      name: 'isDefaultAddress',
      desc: '',
      args: [],
    );
  }

  /// `Branches`
  String get branches {
    return Intl.message('Branches', name: 'branches', desc: '', args: []);
  }

  /// `Customers`
  String get customers {
    return Intl.message('Customers', name: 'customers', desc: '', args: []);
  }

  /// `Customer Selection`
  String get customerSelection {
    return Intl.message(
      'Customer Selection',
      name: 'customerSelection',
      desc: '',
      args: [],
    );
  }

  /// `Open Invoice`
  String get openInvoice {
    return Intl.message(
      'Open Invoice',
      name: 'openInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Change address`
  String get changeAddress {
    return Intl.message(
      'Change address',
      name: 'changeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Add new address`
  String get addNewAddress {
    return Intl.message(
      'Add new address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Selected Table`
  String get selectedTable {
    return Intl.message(
      'Selected Table',
      name: 'selectedTable',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
