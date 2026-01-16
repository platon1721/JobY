import 'package:cloud_firestore/cloud_firestore.dart';

class LinkPermissionsSeed {
  static const String _adminUserId = 'KfClHlSaDnXGaxIti2IMvtbuFsl2';
  static const String _adminRoleId = 'admin_role';

  /// Seob KÕIK olemasolevad permissions Admin rolliga
  static Future<void> linkAllPermissionsToAdmin() async {
    final firestore = FirebaseFirestore.instance;
    
    print('🔗 Linking all permissions to Admin role...');
    
    try {
      // 1. Võta kõik permissions
      final permissionsSnapshot = await firestore.collection('permissions').get();
      
      if (permissionsSnapshot.docs.isEmpty) {
        print('❌ No permissions found! Create permissions first.');
        return;
      }
      
      print('   Found ${permissionsSnapshot.docs.length} permissions');
      
      // 2. Kontrolli kas admin roll on olemas
      final adminRoleDoc = await firestore.collection('user_roles').doc(_adminRoleId).get();
      if (!adminRoleDoc.exists) {
        print('❌ Admin role not found! Create it first.');
        return;
      }
      
      // 3. Kustuta vanad seosed (kui on)
      final existingLinks = await firestore
          .collection('user_role_permissions')
          .where('role_id', isEqualTo: _adminRoleId)
          .get();
      
      for (final doc in existingLinks.docs) {
        await doc.reference.delete();
      }
      print('   Cleared ${existingLinks.docs.length} old links');
      
      // 4. Loo uued seosed
      final batch = firestore.batch();
      
      for (final permDoc in permissionsSnapshot.docs) {
        final linkDoc = firestore.collection('user_role_permissions').doc();
        batch.set(linkDoc, {
          'role_id': _adminRoleId,
          'permission_id': permDoc.id,
          'created_at': Timestamp.now(),
          'created_by': 'system',
          'active_till': null,
        });
      }
      
      await batch.commit();
      
      print('✅ Linked ${permissionsSnapshot.docs.length} permissions to Admin role!');
      
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  /// Määra kasutaja Admin rolliks (kui pole veel)
  static Future<void> assignUserAsAdmin() async {
    final firestore = FirebaseFirestore.instance;
    
    print('👤 Assigning Admin role to user $_adminUserId...');
    
    try {
      // Kontrolli kas juba on
      final existing = await firestore
          .collection('user_user_roles')
          .where('user_id', isEqualTo: _adminUserId)
          .where('role_id', isEqualTo: _adminRoleId)
          .where('active_till', isNull: true)
          .get();
      
      if (existing.docs.isNotEmpty) {
        print('   User is already Admin!');
        return;
      }
      
      // Lisa uus seos
      await firestore.collection('user_user_roles').add({
        'user_id': _adminUserId,
        'role_id': _adminRoleId,
        'created_at': Timestamp.now(),
        'created_by': 'system',
        'active_till': null,
      });
      
      print('✅ User $_adminUserId is now Admin!');
      
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  /// Käivita mõlemad
  static Future<void> runAll() async {
    await linkAllPermissionsToAdmin();
    await assignUserAsAdmin();
    print('\n🎉 All done! You are now Admin with all permissions.');
  }
}
