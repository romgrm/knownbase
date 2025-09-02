import 'package:flutter/material.dart';
import '../../../shared/app_bar/app_bar.dart';

class ProjectSelectionScreen extends StatelessWidget {
  const ProjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const KnownBaseAppBar(
        projectName: 'Select Project',
        userName: 'John Doe',
        userEmail: 'john@company.com',
      ),
      body: const Center(
        child: Text('Project Selection Screen - Coming Soon'),
      ),
    );
  }
}