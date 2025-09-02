import 'package:flutter/material.dart';
import '../../core/constants/k_sizes.dart';
import '../../core/constants/k_fonts.dart';

//TODO: - Implement business logic 
// TODO: - Check responsiveness design 
class KnownBaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KnownBaseAppBar({
    super.key,
    this.projectName = 'Mobile App v2.0',
    this.userName = 'John Doe',
    this.userEmail = 'john@company.com',
    this.onProjectInfoTap,
    this.onSettingsTap,
    this.onUserMenuTap,
  });

  final String projectName;
  final String userName;
  final String userEmail;
  final VoidCallback? onProjectInfoTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onUserMenuTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KSize.md,
          vertical: KSize.xxs,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const KnownBaseLogo(),
                  const SizedBox(width: KSize.md),
                  Flexible(
                    child: ProjectInfo(
                      projectName: projectName,
                      onTap: onProjectInfoTap,
                    ),
                  ),
                ],
              ),
            ),
            RightActions(
              userName: userName,
              userEmail: userEmail,
              onSettingsTap: onSettingsTap,
              onUserMenuTap: onUserMenuTap,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class KnownBaseLogo extends StatelessWidget {
  const KnownBaseLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: KSize.iconSizeLarge,
          height: KSize.iconSizeLarge,
          margin: const EdgeInsets.only(right: KSize.xxs),
          decoration: BoxDecoration(
            color: const Color(0xFFA199FA),
            borderRadius: BorderRadius.circular(KSize.radiusDefault),
          ),
          child: const Icon(
            Icons.article_outlined,
            color: Colors.white,
            size: KSize.iconSizeDefault,
          ),
        ),
        Text(
          'KnownBase',
          style: KFonts.titleMedium.copyWith(
            fontWeight: KFonts.semiBold,
            color: const Color(0xFF101828),
          ),
        ),
      ],
    );
  }
}

class ProjectInfo extends StatelessWidget {
  const ProjectInfo({
    super.key,
    required this.projectName,
    this.onTap,
  });

  final String projectName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget info = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Project:',
          style: KFonts.bodySmall.copyWith(
            fontSize: 12.3,
            color: const Color(0xFF6A7282),
          ),
        ),
        const SizedBox(width: KSize.xxs - KSize.xxxs),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: KSize.xxs,
            vertical: KSize.xxxs - 1,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFA199FA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(KSize.radiusSmall + KSize.xxxs),
            border: Border.all(
              color: const Color(0xFFA199FA).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            projectName,
            overflow: TextOverflow.ellipsis,
            style: KFonts.labelSmall.copyWith(
              fontWeight: KFonts.medium,
              color: const Color(0xFFA199FA),
            ),
          ),
        ),
      ],
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KSize.radiusSmall + KSize.xxxs),
        child: info,
      );
    }
    return info;
  }
}

class RightActions extends StatelessWidget {
  const RightActions({
    super.key,
    required this.userName,
    required this.userEmail,
    this.onSettingsTap,
    this.onUserMenuTap,
  });

  final String userName;
  final String userEmail;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onUserMenuTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsButton(onTap: onSettingsTap),
        const SizedBox(width: KSize.xxs),
        UserMenu(
          userName: userName,
          userEmail: userEmail,
          onTap: onUserMenuTap,
        ),
      ],
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.75),
      child: const Padding(
        padding: EdgeInsets.all(KSize.xxs - 2),
        child: Icon(
          Icons.settings_outlined,
          size: KSize.iconSizeDefault - KSize.xxs,
          color: Color(0xFF6A7282),
        ),
      ),
    );
  }
}

class UserMenu extends StatelessWidget {
  const UserMenu({
    super.key,
    required this.userName,
    required this.userEmail,
    this.onTap,
  });

  final String userName;
  final String userEmail;
  final VoidCallback? onTap;

  String _getUserInitials() {
    final names = userName.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty && names[0].length >= 2) {
      return names[0].substring(0, 2).toUpperCase();
    }
    return 'JD';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.75),
      child: Container(
        height: KSize.buttonHeightSmall,
        padding: const EdgeInsets.symmetric(horizontal: KSize.xxs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(KSize.radiusSmall + KSize.xxxs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(initials: _getUserInitials()),
            const SizedBox(width: KSize.xxs),
            Flexible(
              child: UserInfo(
                userName: userName,
                userEmail: userEmail,
              ),
            ),
            const SizedBox(width: KSize.xxs),
            const Icon(
              Icons.keyboard_arrow_down,
              size: KSize.iconSizeDefault - KSize.xxs,
              color: Color(0xFF99A1AF),
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: KSize.xl,
      height: KSize.xl,
      decoration: const BoxDecoration(
        color: Color(0xFFA199FA),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: KFonts.labelMedium.copyWith(
            fontSize: 12.3,
            fontWeight: KFonts.medium,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            userName,
            overflow: TextOverflow.ellipsis,
            style: KFonts.labelMedium.copyWith(
              fontWeight: KFonts.medium,
              color: const Color(0xFF101828),
            ),
          ),
        ),
        Flexible(
          child: Text(
            userEmail,
            overflow: TextOverflow.ellipsis,
            style: KFonts.labelSmall.copyWith(
              fontWeight: KFonts.medium,
              color: const Color(0xFF6A7282),
            ),
          ),
        ),
      ],
    );
  }
}
