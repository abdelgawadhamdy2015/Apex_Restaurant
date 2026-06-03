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
  String get noDateFound {
    return Intl.message(
      'No Data Found',
      name: 'noDateFound',
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
