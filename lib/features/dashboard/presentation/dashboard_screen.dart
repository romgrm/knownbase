import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/k_fonts.dart';
import '../../../core/constants/k_sizes.dart';
import '../../../core/router/app_router.dart';
import '../../authentication/application/authentication_cubit.dart';
import '../../authentication/application/authentication_state.dart';

/// Dashboard screen displayed after successful authentication
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'KnownBase',
          style: KFonts.titleLarge.copyWith(
            color: Colors.black,
            fontWeight: KFonts.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Show sign out confirmation
              _showSignOutDialog(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            tooltip: 'Sign Out',
          ),
          const SizedBox(width: KSize.sm),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.grey[100]!,
              Colors.grey[200]!,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AuthenticationCubit, AuthenticationState>(
            listener: (context, state) {
              // Navigate to authentication when sign-out is successful
              if (state.isSignOutSuccess) {
                AppRouter.navigateToAuth(context);
              }
            },
            child: const DashboardView(),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: KFonts.titleMedium,
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: KFonts.bodyMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KSize.radiusMedium),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: KFonts.labelMedium.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthenticationCubit>().signOut();
              },
              child: Text(
                'Sign Out',
                style: KFonts.labelMedium.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(KSize.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(KSize.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(KSize.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(KSize.sm),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA199FA).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(KSize.radiusDefault),
                      ),
                      child: const Icon(
                        Icons.dashboard,
                        color: Color(0xFFA199FA),
                        size: KSize.iconSizeLarge,
                      ),
                    ),
                    const SizedBox(width: KSize.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to KnownBase!',
                            style: KFonts.titleMedium.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: KSize.xxxs),
                          Text(
                            'Your knowledge base dashboard',
                            style: KFonts.bodyMedium.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: KSize.lg),
          
          // Quick stats section
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Articles',
                  '12',
                  Icons.article,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: KSize.sm),
              Expanded(
                child: _buildStatCard(
                  'Categories',
                  '5',
                  Icons.category,
                  Colors.green,
                ),
              ),
              const SizedBox(width: KSize.sm),
              Expanded(
                child: _buildStatCard(
                  'Views',
                  '1.2K',
                  Icons.visibility,
                  Colors.orange,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: KSize.lg),
          
          // Recent activity section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(KSize.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(KSize.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: KFonts.titleMedium.copyWith(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: KSize.md),
                _buildActivityItem(
                  'Created new article',
                  '"Getting Started with Flutter"',
                  '2 hours ago',
                  Icons.add_circle,
                  Colors.green,
                ),
                _buildActivityItem(
                  'Updated article',
                  '"Authentication Best Practices"',
                  '1 day ago',
                  Icons.edit,
                  Colors.blue,
                ),
                _buildActivityItem(
                  'Added new category',
                  '"Mobile Development"',
                  '3 days ago',
                  Icons.folder_open,
                  Colors.orange,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: KSize.lg),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(KSize.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(KSize.radiusDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: KSize.iconSizeDefault,
          ),
          const SizedBox(height: KSize.xxs),
          Text(
            value,
            style: KFonts.headlineSmall.copyWith(
              color: Colors.black,
              fontWeight: KFonts.bold,
            ),
          ),
          Text(
            title,
            style: KFonts.bodySmall.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String action, String item, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KSize.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(KSize.xxs),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(KSize.radiusSmall),
            ),
            child: Icon(
              icon,
              color: color,
              size: KSize.sm,
            ),
          ),
          const SizedBox(width: KSize.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: action,
                    style: KFonts.bodyMedium.copyWith(color: Colors.black),
                    children: [
                      TextSpan(
                        text: ' $item',
                        style: KFonts.bodyMedium.copyWith(
                          color: const Color(0xFFA199FA),
                          fontWeight: KFonts.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: KFonts.bodySmall.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}