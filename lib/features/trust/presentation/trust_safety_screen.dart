import 'package:flutter/material.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';

class TrustSafetyScreen extends StatelessWidget {
  const TrustSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust, Consent & Ethical AI'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.emeraldContainer,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.emerald.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: AppColors.emeraldDark, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Zero-Tolerance Deepfake Policy',
                        style: TextStyle(
                          color: AppColors.onEmeraldContainer,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${AppConfig.appName} is engineered strictly for educational empowerment under India\'s DPDP Act guidelines.',
                        style: TextStyle(
                          color: AppColors.onEmeraldContainer.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Ethical AI Guardrails Enforced in UI:',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildGuardrailTile(
            context,
            icon: Icons.mic_external_on_rounded,
            title: '1. Mandatory Read-Aloud Consent Verification',
            description:
                'No custom educator avatar can be synthesized without a live recording of a specific legal read-aloud sentence verifying identity and voluntary authorization.',
          ),
          const SizedBox(height: 10),
          _buildGuardrailTile(
            context,
            icon: Icons.badge_rounded,
            title: '2. Persistent AI-Generated Watermarking',
            description:
                'Every single explainer video carries an indelible "AI Synthesized" badge and watermark overlay across the player canvas to eliminate misinformation.',
          ),
          const SizedBox(height: 10),
          _buildGuardrailTile(
            context,
            icon: Icons.block_flipped,
            title: '3. Instant Likeness Revocation',
            description:
                'Teachers maintain sovereign ownership of their digital likeness and can permanently revoke or lock their avatar with a single tap from their dashboard.',
          ),
          const SizedBox(height: 10),
          _buildGuardrailTile(
            context,
            icon: Icons.flag_rounded,
            title: '4. Student Community Flagging & Misuse Reporting',
            description:
                'Every video player screen provides a direct "Report Misuse" action for immediate review by academic moderating committees.',
          ),

          const SizedBox(height: 24),

          // Legal Compliance Badge
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Regulatory Alignment:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                SizedBox(height: 6),
                Text(
                  '• India Digital Personal Data Protection (DPDP) Act\n'
                  '• Ministry of Education NEP 2020 Regional Pedagogy Framework\n'
                  '• UNESCO Recommendations on the Ethics of Artificial Intelligence',
                  style: TextStyle(fontSize: 12, height: 1.5, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildGuardrailTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
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
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 11, color: Colors.grey[700], height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
