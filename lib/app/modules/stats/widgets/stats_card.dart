import 'package:flutter/material.dart';
import 'package:task_manager_app/app/core/extension_size.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.widthPct(0.235),
      height: 50,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          width: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style:  TextStyle(fontSize: context.heightPct(0.015), fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: context.heightPct(0.015), color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}