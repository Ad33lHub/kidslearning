import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class CreateEditChildScreen extends StatefulWidget {
  final ChildEntity? existing;
  const CreateEditChildScreen({super.key, this.existing});

  @override
  State<CreateEditChildScreen> createState() => _CreateEditChildScreenState();
}

class _CreateEditChildScreenState extends State<CreateEditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  int _avatarIndex = 0;
  String _level = 'easy';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _avatarIndex = widget.existing?.avatarIndex ?? 0;
    _level = widget.existing?.level ?? 'easy';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final db = await AppDatabase.instance.database;
      final repo = ChildrenRepository(db);
      if (widget.existing == null) {
        final parentId = context.read<AppState>().parentId!;
        await repo.create(
          parentId: parentId,
          name: _nameCtrl.text,
          avatarIndex: _avatarIndex,
          level: _level,
        );
      } else {
        await repo.update(
          id: widget.existing!.id,
          name: _nameCtrl.text,
          avatarIndex: _avatarIndex,
          level: _level,
        );
        if (mounted) {
          final updated = widget.existing!.copyWith(
            name: _nameCtrl.text,
            avatarIndex: _avatarIndex,
            level: _level,
          );
          context.read<AppState>().refreshChild(updated);
        }
      }
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          isEdit ? 'Edit Child' : 'Add Child',
          style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  ChildrenRepository
                      .avatarEmojis[_avatarIndex % ChildrenRepository.avatarEmojis.length],
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Pick an avatar',
                  style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ChildrenRepository.avatarEmojis.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => _avatarIndex = i),
                    child: Container(
                      width: 56,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _avatarIndex == i
                            ? const Color(0xFFF19335).withOpacity(0.2)
                            : Colors.white,
                        border: _avatarIndex == i
                            ? Border.all(color: const Color(0xFFF19335), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          ChildrenRepository.avatarEmojis[i],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "Child's Name",
                  labelStyle: const TextStyle(fontFamily: 'arlrdbd'),
                  prefixIcon: const Icon(Icons.child_care, color: Color(0xFFF19335)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFF19335), width: 2),
                  ),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Learning Level',
                style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _levelChip('easy', '⭐ Easy'),
                  const SizedBox(width: 8),
                  _levelChip('medium', '⭐⭐ Medium'),
                  const SizedBox(width: 8),
                  _levelChip('hard', '⭐⭐⭐ Hard'),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF19335),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdit ? 'Save Changes' : 'Create Profile',
                          style: const TextStyle(
                            fontFamily: 'arlrdbd',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelChip(String value, String label) {
    final selected = _level == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _level = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF19335) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? const Color(0xFFF19335) : Colors.grey.shade300,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 12,
              color: selected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
