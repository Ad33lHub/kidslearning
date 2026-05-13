import 'package:flutter/material.dart';
import 'package:kids/core/theme/app_colors.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _policySection(
                  '🛡️ Our Commitment',
                  'Your privacy and your child\'s safety are our top priorities. This policy explains how we handle information in the Kids Learning App.',
                ),
                _policySection(
                  '👶 Children\'s Privacy',
                  'We do not collect any personally identifiable information from children. All learning progress and quiz scores are stored locally on your device or linked to the parent\'s account.',
                ),
                _policySection(
                  '📊 Data Collection',
                  'We only collect minimal data required for the app to function:\n'
                  '• Parent email for account synchronization.\n'
                  '• Child\'s first name and selected avatar.\n'
                  '• Learning progress (completed activities, scores).',
                ),
                _policySection(
                  '🔒 Data Security',
                  'All data is encrypted and stored securely. We do not sell or share any user data with third-party advertisers or data brokers.',
                ),
                _policySection(
                  '⚙️ Parental Controls',
                  'Parents have full control over the data. You can delete child profiles and reset learning history at any time through the "Children" management tab.',
                ),
                _policySection(
                  '📧 Contact Us',
                  'If you have any questions about this privacy policy, please contact us at support@kidslearningapp.com',
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Last Updated: May 2026',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _policySection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
