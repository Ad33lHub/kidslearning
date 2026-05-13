import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
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
    if (mounted) {
      setState(() {
        _children = children;
        _loading = false;
      });
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

  Future<void> _eraseProgress(ChildEntity child) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Erase Progress',
          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
        ),
        content: Text(
          "This will erase all learning data for ${child.name}. "
          "The profile will not be deleted. This cannot be undone.",
          style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'arlrdbd'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warning,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Erase',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final db = await AppDatabase.instance.database;
    await ChildrenRepository(db).clearData(child.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${child.name}'s progress has been erased.",
          style: const TextStyle(fontFamily: 'arlrdbd'),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _delete(ChildEntity child) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Profile',
          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
        ),
        content: Text(
          "Permanently remove ${child.name}'s profile and all data?",
          style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'arlrdbd'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final db = await AppDatabase.instance.database;
    await ChildrenRepository(db).deleteWithData(child.id);
    if (!mounted) return;
    final current = context.read<AppState>().currentChild;
    if (current?.id == child.id) {
      context.read<AppState>().clearChild();
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Child Profiles',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.headerGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else if (_children.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👨‍👩‍👧', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    const Text(
                      'No profiles yet.\nTap + to add a child.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _ChildTile(
                    child: _children[i],
                    onEdit: () => _edit(_children[i]),
                    onErase: () => _eraseProgress(_children[i]),
                    onDelete: () => _delete(_children[i]),
                  ),
                  childCount: _children.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateEditChildScreen()),
          );
          if (result == true) _load();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Add Child',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
        ),
      ),
    );
  }
}

class _ChildTile extends StatelessWidget {
  final ChildEntity child;
  final VoidCallback onEdit;
  final VoidCallback onErase;
  final VoidCallback onDelete;

  const _ChildTile({
    required this.child,
    required this.onEdit,
    required this.onErase,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = ChildrenRepository.avatarEmojis[
        child.avatarIndex % ChildrenRepository.avatarEmojis.length];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.headerGradient,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        title: Text(
          child.name,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          'Level: ${child.level}',
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 13,
            color: AppColors.primary,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onSelected: (val) {
            switch (val) {
              case 'edit':
                onEdit();
              case 'erase':
                onErase();
              case 'delete':
                onDelete();
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined,
                      color: Color(0xFF10B981), size: 20),
                  SizedBox(width: 10),
                  Text('Edit', style: TextStyle(fontFamily: 'arlrdbd')),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'erase',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep_outlined,
                      color: Color(0xFFF59E0B), size: 20),
                  SizedBox(width: 10),
                  Text('Erase Progress',
                      style: TextStyle(fontFamily: 'arlrdbd')),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.person_remove_outlined,
                      color: Color(0xFFEF4444), size: 20),
                  SizedBox(width: 10),
                  Text('Delete Profile',
                      style: TextStyle(fontFamily: 'arlrdbd')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
