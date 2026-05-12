import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'create_edit_child_screen.dart';

class ChildSelectionScreen extends StatefulWidget {
  const ChildSelectionScreen({super.key});

  @override
  State<ChildSelectionScreen> createState() => _ChildSelectionScreenState();
}

class _ChildSelectionScreenState extends State<ChildSelectionScreen> {
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

  void _selectChild(ChildEntity child) {
    context.read<AppState>().setChild(child);
  }

  Future<void> _addChild() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateEditChildScreen()),
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
        automaticallyImplyLeading: false,
        title: const Text(
          'Who is learning today?',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => context.read<AppState>().logout(),
            icon: const Icon(Icons.logout, color: Colors.black54),
            label: const Text(
              'Logout',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _children.isEmpty
              ? _emptyView()
              : _childGrid(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addChild,
        backgroundColor: const Color(0xFFF19335),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Child',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
        ),
      ),
    );
  }

  Widget _emptyView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🧒', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'No child profiles yet!\nTap + to add one.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
          ],
        ),
      );

  Widget _childGrid() => Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _children.length,
          itemBuilder: (_, i) => _childCard(_children[i]),
        ),
      );

  Widget _childCard(ChildEntity child) {
    final emoji = ChildrenRepository.avatarEmojis[
        child.avatarIndex % ChildrenRepository.avatarEmojis.length];
    return GestureDetector(
      onTap: () => _selectChild(child),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 8),
            Text(
              child.name,
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
            Text(
              child.level,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 14,
                color: Color(0xFFF19335),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
