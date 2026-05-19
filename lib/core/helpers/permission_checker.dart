import 'package:apex_restaurant/featchers/home/data/enums/app_permissions.dart';
import 'package:apex_restaurant/featchers/login/data/models/user_info.dart';

class PermissionChecker {
  final List<UserPermissions> _permissions;

  PermissionChecker(this._permissions);

  /// اجيب الـ UserPermissions object الخاص بـ permission معين
  UserPermissions? _get(AppPermission permission) {
    try {
      return _permissions.firstWhere((p) => p.id == permission.id);
    } catch (_) {
      return null;
    }
  }

  bool canAdd(AppPermission permission) => _get(permission)?.isAdd ?? false;
  bool canEdit(AppPermission permission) => _get(permission)?.isEdit ?? false;
  bool canDelete(AppPermission permission) =>
      _get(permission)?.isDelete ?? false;
  bool canShow(AppPermission permission) => _get(permission)?.isShow ?? false;
  bool canPrint(AppPermission permission) => _get(permission)?.isPrint ?? false;

  /// هل المستخدم عنده أي صلاحية على الـ screen دي (حتى لو show بس)
  bool hasAnyAccess(AppPermission permission) {
    final p = _get(permission);
    if (p == null) return false;
    return (p.isAdd ?? false) ||
        (p.isEdit ?? false) ||
        (p.isDelete ?? false) ||
        (p.isShow ?? false) ||
        (p.isPrint ?? false);
  }
}
