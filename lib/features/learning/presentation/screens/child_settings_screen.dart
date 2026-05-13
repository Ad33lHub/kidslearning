import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class ChildSettingsScreen extends StatefulWidget {
  const ChildSettingsScreen({super.key});

  @override
  State<ChildSettingsScreen> createState() => _ChildSettingsScreenState();
}

class _ChildSettingsScreenState extends State<ChildSettingsScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  int _avatarIndex = 0;
  bool _saving = false;

  final List<String> _avatars = [
    '🐙', '🦁', '🐼', '🐯', '🦊', '🐻', '🐸', '🦄', '🐱', '🐶', '🦉', '🐧'
  ];

  @override
  void initState() {
    super.initState();
    final child = context.read<AppState>().currentChild;
    if (child != null) {
      _nameCtrl.text = child.name;
      _ageCtrl.text = child.age?.toString() ?? '';
      _avatarIndex = child.avatarIndex.clamp(0, _avatars.length - 1);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    final appState = context.read<AppState>();
    final child = appState.currentChild!;
    final age = int.tryParse(_ageCtrl.text);

    final db = await AppDatabase.instance.database;
    final repo = ChildrenRepository(db);
    
    await repo.update(
      id: child.id,
      name: name,
      age: age,
      avatarIndex: _avatarIndex,
      level: child.level,
    );

    final updated = child.copyWith(
      name: name,
      age: age,
      avatarIndex: _avatarIndex,
    );
    appState.refreshChild(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated! ✨')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Profile Settings',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your Avatar',
              style: TextStyle(
                fontFamily: 'arlrdbd',
                color: Color(0xFFC7C5CE),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _avatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final isSelected = _avatarIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _avatarIndex = i),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _avatars[i],
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildField(
              label: 'My Name',
              controller: _nameCtrl,
              hint: 'Enter your name',
            ),
            const SizedBox(height: 20),
            _buildField(
              label: 'My Age',
              controller: _ageCtrl,
              hint: 'How old are you?',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            color: Color(0xFFC7C5CE),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontFamily: 'arlrdbd'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
