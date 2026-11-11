import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/core/utils/responsive.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/cubits/country/country_cubit.dart';
import 'package:news_paper_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/responsive/responsive_content.dart';
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
    final size = Responsive.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      drawer: size.isCompact ? const AppDrawer() : null,
      appBar:
          size.isCompact
              ? AppBar(
                backgroundColor: theme.colorScheme.surface,
                surfaceTintColor: theme.colorScheme.surface,
                elevation: 0,
                centerTitle: true,
                leading: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: theme.colorScheme.onSurface,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    );
                  },
                ),
                title: Text(
                  'Al Akhbar'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.notificationPageRoute),
                  ),
                ],
              )
              : null,
      body: SafeArea(
        child: Center(
          child: ResponsiveContent(
            maxWidth: LayoutSizes.maxListWidth,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                Text(
                  'Settings'.tr(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
                            activeThumbColor: theme.colorScheme.onPrimary,
                            activeTrackColor: theme.colorScheme.secondary,
                            onChanged:
                                (value) => context
                                    .read<ThemeCubit>()
                                    .toggleTheme(value),
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
                            () => setState(
                              () => _notifications = !_notifications,
                            ),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                _notifications
                                    ? theme.colorScheme.secondary
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  _notifications
                                      ? theme.colorScheme.secondary
                                      : theme.colorScheme.outline,
                              width: 1.5,
                            ),
                          ),
                          child:
                              _notifications
                                  ? Icon(
                                    Icons.check,
                                    size: 16,
                                    color: theme.colorScheme.onSecondary,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    BlocBuilder<CountryCubit, CountryState>(
                      builder: (context, state) {
                        return SettingsTile(
                          icon: Icons.public,
                          title: 'Region'.tr(),
                          trailing: _ValueWithChevron(value: state.countryName),
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              onSelect: (Country country) {
                                context.read<CountryCubit>().selectCountry(
                                  countryCode: country.countryCode,
                                  countryName: country.name,
                                );
                              },
                            );
                          },
                          isLast: true,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'About'.tr(),
                    style: theme.textTheme.labelLarge?.copyWith(
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
                        color: theme.colorScheme.outline,
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
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.start,
                              )
                              : Text(
                                '1.0.4 (Build 42)',
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.end,
                              ),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Material(
                  color: theme.colorScheme.errorContainer,
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
                            color: theme.colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sign out'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
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
                  sheetContext.locale.languageCode == 'en'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () async {
                final nav = Navigator.of(sheetContext);
                await context.setLocale(const Locale('en'));
                if (nav.mounted) nav.pop();
              },
            ),
            ListTile(
              title: const Text('العربية'),
              trailing:
                  sheetContext.locale.languageCode == 'ar'
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
              onTap: () async {
                final nav = Navigator.of(sheetContext);
                await context.setLocale(const Locale('ar'));
                if (nav.mounted) nav.pop();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
