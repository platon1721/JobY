import 'package:flutter/material.dart';
import 'package:joby/features/departments/domain/entities/department_entity.dart';

class DepartmentBreadcrumb extends StatelessWidget {
  final List<DepartmentEntity> path;
  final Function(DepartmentEntity)? onDepartmentTap;

  const DepartmentBreadcrumb({
    super.key,
    required this.path,
    this.onDepartmentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < path.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            _BreadcrumbItem(
              department: path[i],
              isLast: i == path.length - 1,
              onTap: onDepartmentTap != null
                  ? () => onDepartmentTap!(path[i])
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _BreadcrumbItem extends StatelessWidget {
  final DepartmentEntity department;
  final bool isLast;
  final VoidCallback? onTap;

  const _BreadcrumbItem({
    required this.department,
    required this.isLast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isLast
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForLevel(department.hierarchyLevel),
              size: 14,
              color: isLast
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              department.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                color: isLast
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
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
      default:
        return Icons.circle;
    }
  }
}
