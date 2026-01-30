import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joby/features/dashboard/presentation/widgets/avatar.dart';
import 'package:joby/features/dashboard/presentation/widgets/glass_container.dart';
import 'package:joby/features/dashboard/presentation/widgets/header_losading.dart';
import 'package:joby/features/dashboard/presentation/widgets/header_message.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';

class SidebarHeader extends StatelessWidget {
  final UserState userState;

  const SidebarHeader({
    super.key,
    required this.userState,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: userState.maybeWhen(
        loaded: (user) => GlassContainer(
          child: Row(
            children: [
              Avatar(
                letter: user.firstName.isNotEmpty
                    ? user.firstName[0].toUpperCase()
                    : '?',
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.surName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        loading: () => const HeaderLoading(),

        error: (message) => HeaderMessage(
          icon: Icons.error_outline,
          text: message,
        ),

        orElse: () => const HeaderMessage(
          icon: Icons.hourglass_empty,
          text: 'Loading...',
        ),
      ),
    );
  }
}
