import 'package:flutter/material.dart';

class CompanyProfile extends StatelessWidget {
  final VoidCallback
  onRequestQuote; // Tatanggapin natin ang command mula sa main layout

  const CompanyProfile({super.key, required this.onRequestQuote});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          _buildOriginSection(),
          _buildMissionVision(),
          _buildCoreValues(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Safeguarding Lives and Assets',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Katala Fire Protection Product Trading is a premier provider of life-safety equipment and highly engineered fire suppression solutions, dedicated to uncompromising reliability.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Origin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFFB71C1C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Founded on the principle of absolute structural integrity and uncompromising safety, Katala emerged as a critical response to the growing demand for dependable, industrial-grade fire protection systems in modern facilities.\n\nWe don\'t just sell equipment; we engineer peace of mind through rigorous testing, certified deployment, and steadfast maintenance protocols.',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVision() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.track_changes_outlined,
            title: 'Mission',
            description:
                'To deliver highly engineered, rigorously tested fire protection solutions that unequivocally safeguard human life, protect critical infrastructure, and ensure uninterrupted operational continuity for our clients.',
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            icon: Icons.visibility_outlined,
            title: 'Vision',
            description:
                'To be the industry standard-bearer for technical excellence and reliability in fire safety engineering across the region, recognized for our unwavering commitment to quality and precision.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFB71C1C), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreValues() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Core Values',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The principles that govern our engineering and service operations.',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildValueCard(
                  Icons.health_and_safety,
                  'Safety',
                  'Absolute priority in all environments.',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueCard(
                  Icons.verified,
                  'Reliability',
                  'Consistent performance under pressure.',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueCard(
                  Icons.military_tech,
                  'Quality',
                  'Excellence in materials and execution.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildValueCard(
                  Icons.engineering,
                  'Professionalism',
                  'Expertise driven technical conduct.',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildValueCard(
                  Icons.support_agent,
                  'Customer Care',
                  'Responsive, dedicated support.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFB71C1C), size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 9, color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF5F5F5),
      child: Column(
        children: [
          const Text(
            'Katala Fire Protection',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFFB71C1C),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Safeguarding Lives and Assets',
            style: TextStyle(fontSize: 10, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onRequestQuote, // DITO NATIN NILAGAY YUNG FUNCTION!
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB71C1C)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'REQUEST SERVICE',
                style: TextStyle(
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2024 Katala Fire Protection Product Trading. All rights reserved.',
            style: TextStyle(fontSize: 10, color: Color(0xFF999999)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                '•',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                'Terms of Service',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                '•',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                'ISO Certification',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                '•',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
              Text(
                'Business Registration',
                style: TextStyle(fontSize: 9, color: Color(0xFF666666)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
