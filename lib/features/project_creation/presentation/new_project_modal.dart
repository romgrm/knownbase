import 'package:flutter/material.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../core/constants/k_fonts.dart';
import '../../../shared/cards/k_card.dart';
import '../../../shared/input_fields/input_field.dart';

class NewProjectModal extends StatefulWidget {
  const NewProjectModal({super.key});

  @override
  State<NewProjectModal> createState() => _NewProjectModalState();
}

class _NewProjectModalState extends State<NewProjectModal> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _slugController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _slugController.dispose();
    super.dispose();
  }

  void _handleCreateProject() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement project creation logic
      Navigator.of(context).pop({
        'name': _projectNameController.text,
        'slug': _slugController.text,
      });
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(KSize.md),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 460,
          maxHeight: 520,
        ),
        child: KCard(
          backgroundColor: Colors.white,
          borderRadius: KSize.radiusLarge,
          padding: const EdgeInsets.all(KSize.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: KSize.lg),
              _buildForm(),
              const SizedBox(height: KSize.lg),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Create New Project',
            style: KFonts.titleLarge.copyWith(
              color: Colors.black87,
              fontWeight: KFonts.semiBold,
            ),
          ),
        ),
        IconButton(
          onPressed: _handleCancel,
          icon: const Icon(
            Icons.close,
            color: Colors.black54,
            size: KSize.md,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputField(
            controller: _projectNameController,
            label: 'Project Name',
            hintText: 'Enter project name...',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Project name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: KSize.md),
          InputField(
            controller: _slugController,
            label: 'Project Slug (Optional)',
            hintText: 'project-slug',
            validator: (value) {
              if (value != null && value.trim().isNotEmpty) {
                final slugRegex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
                if (!slugRegex.hasMatch(value.trim())) {
                  return 'Slug must contain only lowercase letters, numbers, and hyphens';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }


  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _handleCancel,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: KSize.md,
              vertical: KSize.xs,
            ),
          ),
          child: Text(
            'Cancel',
            style: KFonts.buttonMedium.copyWith(
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(width: KSize.sm),
        ElevatedButton(
          onPressed: _handleCreateProject,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: KSize.md,
              vertical: KSize.xs,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KSize.radiusDefault),
            ),
            elevation: 0,
          ),
          child: Text(
            'Create Project',
            style: KFonts.buttonMedium.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}