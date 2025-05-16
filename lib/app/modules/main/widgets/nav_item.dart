import 'package:flutter/material.dart';
import 'package:task_manager_app/app/core/extension_size.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF52B2AD) : const Color(0xFF4f787f);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: color.withOpacity(0.2),
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.heightPct(0.035), color: color),
          Text(label, style: TextStyle(color: color, fontSize: context.heightPct(0.020))),
        ],
      ),
    );
  }
}
