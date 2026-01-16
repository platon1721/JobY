import 'package:flutter/material.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

class DepartmentTreeNode extends StatelessWidget {
  final DepartmentEntity department;
  final int level;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onTap;
  final VoidCallback onAddChild;
  final VoidCallback onMove;
  final VoidCallback onRemoveFromParent;

  const DepartmentTreeNode({
    super.key,
    required this.department,
    required this.level,
    required this.hasChildren,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onTap,
    required this.onAddChild,
    required this.onMove,
    required this.onRemoveFromParent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: level == 0 ? 2 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // Expand/Collapse button
              if (hasChildren)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: _getColorForLevel(level),
                  ),
                  onPressed: onToggleExpand,
                  tooltip: isExpanded ? 'Collapse' : 'Expand',
                )
              else
                const SizedBox(width: 48), // Placeholder for alignment

              // Department icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getColorForLevel(level).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getColorForLevel(level).withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  _getIconForLevel(level),
                  color: _getColorForLevel(level),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Department info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      department.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: level == 0 ? 16 : 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getColorForLevel(level).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getLevelName(level),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getColorForLevel(level),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (hasChildren) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.subdirectory_arrow_right,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Has children',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                        if (!department.isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Inactive',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Action menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'view':
                      onTap();
                      break;
                    case 'add_child':
                      onAddChild();
                      break;
                    case 'move':
                      onMove();
                      break;
                    case 'remove_parent':
                      onRemoveFromParent();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'add_child',
                    child: Row(
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text('Add Child'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'move',
                    child: Row(
                      children: [
                        Icon(Icons.drive_file_move, size: 20),
                        SizedBox(width: 8),
                        Text('Move'),
                      ],
                    ),
                  ),
                  if (level > 0)
                    const PopupMenuItem(
                      value: 'remove_parent',
                      child: Row(
                        children: [
                          Icon(Icons.link_off, size: 20, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Remove from Parent',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForLevel(int level) {
    switch (level) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForLevel(int level) {
    switch (level) {
      case 0:
        return Icons.business;
      case 1:
        return Icons.account_tree;
      case 2:
        return Icons.folder;
      case 3:
        return Icons.group;
      case 4:
        return Icons.person;
      default:
        return Icons.circle;
    }
  }

  String _getLevelName(int level) {
    switch (level) {
      case 0:
        return 'Company';
      case 1:
        return 'Division';
      case 2:
        return 'Department';
      case 3:
        return 'Team';
      case 4:
        return 'Unit';
      default:
        return 'Level $level';
    }
  }
}
