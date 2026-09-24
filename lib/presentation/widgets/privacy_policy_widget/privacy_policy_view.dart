import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text("Privacy Policy".tr(), style: theme.textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Privacy Policy".tr(), style: theme.textTheme.headlineMedium),

            const SizedBox(height: 8),

            Text(
              "Last updated: September 2026".tr(),
              style: theme.textTheme.bodySmall,
            ),

            const SizedBox(height: 32),

            _PrivacySection(
              title: "Introduction".tr(),
              content:
                  "This Privacy Policy explains how the News Paper App handles information when you use the application."
                      .tr(),
            ),

            _PrivacySection(
              title: "Information We Collect".tr(),
              content:
                  "The News Paper App does not require you to create an account and does not collect personal information such as your name, email address, phone number, or home address."
                      .tr(),
            ),

            _PrivacySection(
              title: "Searches".tr(),
              content:
                  "Search terms you enter in the app may be stored locally on your device so the app can display your recent searches. These searches are stored locally and are not sent to our servers for storage."
                      .tr(),
            ),

            _PrivacySection(
              title: "Saved".tr(),
              content:
                  "Articles you save are stored locally on your device. Saved articles are not uploaded to our servers."
                      .tr(),
            ),

            _PrivacySection(
              title: "News Content".tr(),
              content:
                  "The application retrieves news articles from third-party news services. Article content, images, titles, descriptions, and links belong to their respective publishers."
                      .tr(),
            ),

            _PrivacySection(
              title: "Third-Party Services".tr(),
              content:
                  "The application may communicate with third-party services to retrieve news content. These services may have their own privacy policies and terms of use."
                      .tr(),
            ),

            _PrivacySection(
              title: "Internet Access".tr(),
              content:
                  "The application requires an internet connection to retrieve news articles and images from external services."
                      .tr(),
            ),

            _PrivacySection(
              title: "Data Storage".tr(),
              content:
                  "Some application data, such as cached articles, recent searches, and favorite articles, may be stored locally on your device."
                      .tr(),
            ),

            _PrivacySection(
              title: "Data Security".tr(),
              content:
                  "We take reasonable steps to keep locally stored application data within the application environment. However, no method of electronic storage can guarantee complete security."
                      .tr(),
            ),

            _PrivacySection(
              title: "Children’s Privacy".tr(),
              content:
                  "The application does not knowingly collect personal information from children."
                      .tr(),
            ),

            _PrivacySection(
              title: "Changes to This Privacy Policy".tr(),
              content:
                  "This Privacy Policy may be updated when the application changes or when new features are added. Any changes will be reflected on this page."
                      .tr(),
            ),

            _PrivacySection(
              title: "Contact".tr(),
              content:
                  "If you have questions about this Privacy Policy, you can contact the application developer."
                      .tr(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String content;

  const _PrivacySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),

          const SizedBox(height: 10),

          Text(content, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
