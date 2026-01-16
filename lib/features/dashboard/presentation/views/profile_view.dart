import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:joby/features/users/presentation/controllers/user_controller.dart';
import 'package:joby/features/users/presentation/controllers/user_state.dart';


class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userControllerProvider.notifier).loadCurrentUser();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateFields(UserState userState) {
    userState.maybeWhen(
      loaded: (user) {
        _firstNameController.text = user.firstName;
        _surNameController.text = user.surName;
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber ?? '';
      },
      orElse: () {},
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(userControllerProvider.notifier).updateUserProfile(
        firstName: _firstNameController.text.trim(),
        surName: _surNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userControllerProvider);

    // Kuula state muutusi success/error jaoks
    ref.listen<UserState>(userControllerProvider, (previous, next) {
      next.maybeWhen(
        success: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.green,
            ),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        loaded: (user) {
          // Uuenda väljad kui andmed laetakse
          if (!_isEditing) {
            _populateFields(next);
          }
        },
        orElse: () {},
      );
    });

    // Täida väljad esimesel laadimisel
    if (!_isEditing) {
      _populateFields(userState);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _populateFields(userState);
                });
              },
            ),
        ],
      ),
      body: userState.maybeWhen(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(userControllerProvider.notifier).loadCurrentUser();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        orElse: () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          _firstNameController.text.isNotEmpty
                              ? _firstNameController.text[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey[200],
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 18),
                              onPressed: () {
                                // TODO: Photo upload
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form fields
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  enabled: _isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _surNameController,
                  decoration: const InputDecoration(
                    labelText: 'Surname',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  enabled: _isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),

                // Save button
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ),

                // Account info (read only)
                if (!_isEditing) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Account Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  userState.maybeWhen(
                    loaded: (user) => Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _InfoRow(
                              label: 'User ID',
                              value: user.userId,
                            ),
                            const Divider(),
                            _InfoRow(
                              label: 'Member since',
                              value: _formatDate(user.createdAt),
                            ),
                            const Divider(),
                            _InfoRow(
                              label: 'Status',
                              value: user.isActive ? 'Active' : 'Inactive',
                              valueColor: user.isActive ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}