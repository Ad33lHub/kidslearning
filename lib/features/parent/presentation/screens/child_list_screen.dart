import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'create_edit_child_screen.dart';

class ChildListScreen extends StatefulWidget {
  const ChildListScreen({super.key});

  @override
  State<ChildListScreen> createState() => _ChildListScreenState();
}

class _ChildListScreenState extends State<ChildListScreen> {
  List<ChildEntity> _children = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final parentId = context.read<AppState>().parentId;
    if (parentId == null) return;
    final db = await AppDatabase.instance.database;
    final repo = ChildrenRepository(db);
    final children = await repo.listByParent(parentId);
    if (mounted) setState(() {
      _children = children;
      _loading = false;
    });
  }

  Future<void> _delete(ChildEntity child) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Profile', style: TextStyle(fontFamily: 'arlrdbd')),
        content: Text(
          'Remove ${child.name}\'s profile?',
          style: const TextStyle(fontFamily: 'arlrdbd'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final db = await AppDatabase.instance.database;
    final repo = ChildrenRepository(db);
    await repo.delete(child.id);
    if (mounted) {
      final current = context.read<AppState>().currentChild;
      if (current?.id == child.id) {
        context.read<AppState>().clearChild();
      }
      _load();
    }
  }

  Future<void> _edit(ChildEntity child) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateEditChildScreen(existing: child),
      ),
    );
    if (result == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Child Profiles',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateEditChildScreen()),
          );
          if (result == true) _load();
        },
        backgroundColor: const Color(0xFFF19335),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _children.isEmpty
              ? const Center(
                  child: Text(
                    'No profiles yet.\nTap + to add a child.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _children.length,
                  itemBuilder: (_, i) => _tile(_children[i]),
                ),
    );
  }

  Widget _tile(ChildEntity child) {
    final emoji = ChildrenRepository
        .avatarEmojis[child.avatarIndex % ChildrenRepository.avatarEmojis.length];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Text(emoji, style: const TextStyle(fontSize: 40)),
        title: Text(
          child.name,
          style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
        ),
        subtitle: Text(
          'Level: ${child.level}',
          style: const TextStyle(fontFamily: 'arlrdbd', color: Color(0xFFF19335)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF6DB072)),
              onPressed: () => _edit(child),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _delete(child),
            ),
          ],
        ),
      ),
    );
  }
}
