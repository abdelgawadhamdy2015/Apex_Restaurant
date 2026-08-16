import '../../featchers/home/data/enums/app_permissions.dart';
import '../../featchers/login/data/models/login_data.dart';

class PermissionChecker {
  final Map<int, SubPermissionModel> _permissionsMap;

  PermissionChecker(List<PermissionGroupModel>? groups)
    : _permissionsMap = {
        for (final group in groups ?? [])
          for (final permission in group.subPermissions ?? [])
            permission.subFormCode ?? 0: permission,
      };

  SubPermissionModel? _get(AppPermission permission) {
    return _permissionsMap[permission.id];
  }

  bool canAdd(AppPermission permission) => _get(permission)?.isAdd ?? false;

  bool canEdit(AppPermission permission) => _get(permission)?.isEdit ?? false;

  bool canDelete(AppPermission permission) =>
      _get(permission)?.isDelete ?? false;

  bool canShow(AppPermission permission) => _get(permission)?.isShow ?? false;

  bool canPrint(AppPermission permission) => _get(permission)?.isPrint ?? false;

  bool hasAnyAccess(AppPermission permission) {
    final p = _get(permission);

    return p != null &&
        ((p.isAdd ?? false) ||
            (p.isEdit ?? false) ||
            (p.isDelete ?? false) ||
            (p.isShow ?? false) ||
            (p.isPrint ?? false));
  }
}
