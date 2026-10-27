import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';

class ImpactScreen extends StatelessWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Innovation Challenge Impact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.saffron,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Government Innovation Challenge • EdTech Track',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bridging Bharat\'s Educational Divide with Generative AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How ${AppConfig.appName} empowers 250M+ Indian students to learn complex STEM concepts in their own mother tongue from trusted teachers.',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Problem vs Solution Infographics
          const Text(
            'The Core Challenge in Indian Education:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),

          _buildInfographicCard(
            context,
            icon: Icons.language_rounded,
            title: 'Language Barrier in Textbooks',
            description:
                'Over 75% of Indian students in tier-2/3 towns and villages attend regional language schools, yet high-quality science notes and video lectures remain dominated by English and Hindi.',
            color: AppColors.coral,
          ),
          const SizedBox(height: 10),
          _buildInfographicCard(
            context,
            icon: Icons.people_outline_rounded,
            title: 'Severe Teacher Shortage',
            description:
                'Average student-to-teacher ratio in rural government schools exceeds 60:1. Dedicated teachers cannot provide personalized 1-on-1 explanations for every student\'s doubts.',
            color: AppColors.saffronDark,
          ),

          const SizedBox(height: 20),

          const Text(
            'The VidyaGuru Solution:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),

          _buildInfographicCard(
            context,
            icon: Icons.auto_awesome_rounded,
            title: 'On-Demand 3-Minute Video Explainers',
            description:
                'Any PDF, textbook photo, or handwritten note is converted into a structured micro-lesson with key exam formulas and animated diagrams.',
            color: AppColors.primary,
          ),
          const SizedBox(height: 10),
          _buildInfographicCard(
            context,
            icon: Icons.record_voice_over_rounded,
            title: 'Familiar Teacher Face & Timbre',
            description:
                'Psychological studies show students retain 4x more when taught by a familiar, trustworthy face rather than a robotic voice or generic avatar.',
            color: AppColors.emerald,
          ),

          const SizedBox(height: 24),

          // Impact Numbers Grid (Infographics)
          const Text(
            'Targeted National Impact by 2028:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildMetricCard('250M+', 'Rural Students Reachable', Icons.public_rounded, AppColors.primary),
              _buildMetricCard('10 Languages', 'Indic Mother Tongues Supported', Icons.translate_rounded, AppColors.saffronDark),
              _buildMetricCard('85%', 'Teacher Repetitive Time Saved', Icons.alarm_on_rounded, AppColors.emerald),
              _buildMetricCard('4.2x', 'Higher Exam Concept Retention', Icons.trending_up_rounded, const Color(0xFF8B5CF6)),
            ],
          ),

          const SizedBox(height: 24),

          // Innovation Challenge Pitch Statement
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.saffronContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.saffron.withOpacity(0.4)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.military_tech_rounded, color: AppColors.saffronDark),
                    SizedBox(width: 8),
                    Text(
                      'Mission Statement for the Jury',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.onSaffronContainer),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'VidyaGuru makes top-tier pedagogical explanations democratic and accessible to every child in India, regardless of geography, school funding, or mother tongue, while rigorously upholding ethical consent standards for educators.',
                  style: TextStyle(fontSize: 12, height: 1.45, color: AppColors.onSaffronContainer),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfographicCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String metric, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            metric,
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
