import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/settings_widgets/settings_card.dart';
import 'package:news_paper_app/presentation/widgets/settings_widgets/settings_tile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    context.locale;
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Text(
          'Al Akhbar'.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed:
                () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.notificationPageRoute),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 8),
            Text(
              'Settings'.tr(),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode'.tr(),
                  trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, state) {
                      final isDarkMode = state == ThemeMode.dark;
                      return Switch(
                        value: isDarkMode,
                        activeColor: Theme.of(context).colorScheme.onPrimary,
                        activeTrackColor:
                            Theme.of(context).colorScheme.secondary,
                        onChanged:
                            (value) =>
                                context.read<ThemeCubit>().toggleTheme(value),
                      );
                    },
                  ),
                ),
                SettingsTile(
                  icon: Icons.language,
                  title: 'Language'.tr(),
                  trailing: _ValueWithChevron(
                    value:
                        context.locale.languageCode == 'ar'
                            ? "العربية"
                            : 'English',
                  ),
                  onTap: () => _showLanguagePicker(context),
                ),
                SettingsTile(
                  icon: Icons.notifications_none,
                  title: 'Notifications'.tr(),
                  trailing: GestureDetector(
                    onTap:
                        () => setState(() => _notifications = !_notifications),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color:
                            _notifications
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              _notifications
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.outline,
                          width: 1.5,
                        ),
                      ),
                      child:
                          _notifications
                              ? Icon(
                                Icons.check,
                                size: 16,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                              : null,
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.public,
                  title: 'Region'.tr(),
                  trailing: _ValueWithChevron(value: 'USA'.tr()),
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'About'.tr(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SettingsCard(
              children: [
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy'.tr(),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.privacyPolicyPageRoute);
                  },
                ),
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'Version'.tr(),
                  trailing:
                      context.locale.languageCode == 'ar'
                          ? Text(
                            '(بناء ٤٢) ١.٠.٤',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.start,
                          )
                          : Text(
                            '1.0.4 (Build 42)',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.end,
                          ),
                  isLast: true,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Material(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () async {
                  await context.read<AuthCubit>().logout();
                  if (!context.mounted) return;
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.loginPageRoute);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 18,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sign out'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ValueWithChevron extends StatelessWidget {
  final String value;

  const _ValueWithChevron({required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
      ],
    );
  }
}

void _showLanguagePicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              title: const Text('English'),
              trailing:
                  context.locale.languageCode == 'en'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () async {
                await context.setLocale(const Locale('en'));
                debugPrint('Locale now: ${sheetContext.locale}');
                Navigator.pop(sheetContext);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              trailing:
                  context.locale.languageCode == 'ar'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () async {
                await context.setLocale(const Locale('ar'));
                debugPrint('Locale now: ${context.locale}');
                Navigator.pop(sheetContext);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
