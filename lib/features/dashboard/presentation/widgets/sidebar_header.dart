import 'package:flutter/material.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';

class SidebarHeader extends StatelessWidget {
  final UserState userState;

  const SidebarHeader({
    super.key,
    required this.userState,});

  @override
  Widget build(BuildContext context) {
    return userState.maybeWhen(
      loaded: (user) => UserAccountsDrawerHeader(
        accountName: Text(user.surName),
        accountEmail: Text(user.email),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
      ),
      loading: () => const DrawerHeader(
        decoration: BoxDecoration(color: Colors.grey),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (message) => DrawerHeader(
        decoration: const BoxDecoration(color: Colors.grey),
        child: Center(
          child: Text(
            'Error: $message',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      orElse: () => const DrawerHeader(
        decoration: BoxDecoration(color: Colors.grey),
        child: Center(
          child: Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
