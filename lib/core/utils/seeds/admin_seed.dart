import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSeed {
  static const String _adminUserId = 'KfClHlSaDnXGaxIti2IMvtbuFsl2';

  /// Kõik permission koodid, mis süsteemis on
  static const List<Map<String, String>> _permissions = [
    // User permissions
    {'code': 'user.create', 'name': 'Create Users', 'description': 'Can create new users'},
    {'code': 'user.read', 'name': 'Read Users', 'description': 'Can view user information'},
    {'code': 'user.update', 'name': 'Update Users', 'description': 'Can update user information'},
    {'code': 'user.delete', 'name': 'Delete Users', 'description': 'Can deactivate users'},

    // Department permissions
    {'code': 'department.create', 'name': 'Create Departments', 'description': 'Can create new departments'},
    {'code': 'department.read', 'name': 'Read Departments', 'description': 'Can view department information'},
    {'code': 'department.update', 'name': 'Update Departments', 'description': 'Can update department information'},
    {'code': 'department.delete', 'name': 'Delete Departments', 'description': 'Can deactivate departments'},

    // Role permissions
    {'code': 'role.create', 'name': 'Create Roles', 'description': 'Can create new roles'},
    {'code': 'role.read', 'name': 'Read Roles', 'description': 'Can view role information'},
    {'code': 'role.update', 'name': 'Update Roles', 'description': 'Can update role information'},
    {'code': 'role.delete', 'name': 'Delete Roles', 'description': 'Can deactivate roles'},
    {'code': 'role.assign', 'name': 'Assign Roles', 'description': 'Can assign roles to users'},

    // Permission permissions
    {'code': 'permission.read', 'name': 'Read Permissions', 'description': 'Can view permissions'},
    {'code': 'permission.assign', 'name': 'Assign Permissions', 'description': 'Can assign permissions to roles'},

    // Settings permissions
    {'code': 'settings.read', 'name': 'Read Settings', 'description': 'Can view system settings'},
    {'code': 'settings.update', 'name': 'Update Settings', 'description': 'Can update system settings'},

    // Report permissions
    {'code': 'report.view', 'name': 'View Reports', 'description': 'Can view reports'},
    {'code': 'report.export', 'name': 'Export Reports', 'description': 'Can export reports'},
  ];

  /// Käivita see meetod üks kord, et luua admin kasutaja
  static Future<void> seedAdminUser() async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    print('🚀 Starting admin seed...');

    try {
      // 1. LOO PERMISSIONS
      print('📝 Creating permissions...');
      final permissionIds = <String>[];

      for (final perm in _permissions) {
        final permDoc = firestore.collection('permissions').doc();
        permissionIds.add(permDoc.id);

        batch.set(permDoc, {
          'code': perm['code'],
          'name': perm['name'],
          'description': perm['description'],
          'created_at': Timestamp.now(),
          'created_by': 'system',
          'active_till': null,
        });
      }

      // 2. LOO ADMIN ROLL
      print('👑 Creating Admin role...');
      final adminRoleDoc = firestore.collection('user_roles').doc('admin_role');
      batch.set(adminRoleDoc, {
        'name': 'Admin',
        'description': 'Full system access - can manage all aspects of the system',
        'created_at': Timestamp.now(),
        'created_by': 'system',
        'active_till': null,
      });

      // 3. SEO PERMISSIONS ADMIN ROLLIGA
      print('🔗 Linking permissions to Admin role...');
      for (final permId in permissionIds) {
        final rolePermDoc = firestore.collection('user_role_permissions').doc();
        batch.set(rolePermDoc, {
          'role_id': 'admin_role',
          'permission_id': permId,
          'created_at': Timestamp.now(),
          'created_by': 'system',
          'active_till': null,
        });
      }

      // 4. MÄÄRA KASUTAJA ADMIN ROLLIKS
      print('👤 Assigning Admin role to user $_adminUserId...');
      final userRoleDoc = firestore.collection('user_user_roles').doc();
      batch.set(userRoleDoc, {
        'user_id': _adminUserId,
        'role_id': 'admin_role',
        'created_at': Timestamp.now(),
        'created_by': 'system',
        'active_till': null,
      });

      // 5. SALVESTA KÕIK
      await batch.commit();

      print('✅ Admin seed completed successfully!');
      print('   - Created ${_permissions.length} permissions');
      print('   - Created Admin role');
      print('   - Assigned all permissions to Admin role');
      print('   - Assigned Admin role to user: $_adminUserId');

    } catch (e) {
      print('❌ Error during admin seed: $e');
      rethrow;
    }
  }

  /// Lisa veel üks kasutaja adminiks
  static Future<void> addUserAsAdmin(String userId) async {
    final firestore = FirebaseFirestore.instance;

    // Kontrolli kas admin roll on olemas
    final adminRole = await firestore.collection('user_roles').doc('admin_role').get();
    if (!adminRole.exists) {
      throw Exception('Admin role not found. Run seedAdminUser() first.');
    }

    // Lisa kasutaja admin rolliks
    await firestore.collection('user_user_roles').add({
      'user_id': userId,
      'role_id': 'admin_role',
      'created_at': Timestamp.now(),
      'created_by': 'system',
      'active_till': null,
    });

    print('✅ User $userId is now Admin!');
  }

  /// Loo tavaline kasutaja roll (ilma admin õigusteta)
  static Future<void> seedBasicUserRole() async {
    final firestore = FirebaseFirestore.instance;

    // Loo Basic User roll
    await firestore.collection('user_roles').doc('basic_user_role').set({
      'name': 'Basic User',
      'description': 'Standard user with limited access',
      'created_at': Timestamp.now(),
      'created_by': 'system',
      'active_till': null,
    });

    // Lisa ainult read õigused
    final readPermissions = await firestore
        .collection('permissions')
        .where('code', whereIn: ['user.read', 'department.read', 'role.read'])
        .get();

    final batch = firestore.batch();
    for (final perm in readPermissions.docs) {
      final rolePermDoc = firestore.collection('user_role_permissions').doc();
      batch.set(rolePermDoc, {
        'role_id': 'basic_user_role',
        'permission_id': perm.id,
        'created_at': Timestamp.now(),
        'created_by': 'system',
        'active_till': null,
      });
    }

    await batch.commit();
    print('✅ Basic User role created!');
  }
}