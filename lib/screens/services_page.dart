import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServicesPage extends StatefulWidget {
  final VoidCallback onStartInquiry; // DINAGDAG NATIN ITO PARA MA-LINK SA FORM

  const ServicesPage({super.key, required this.onStartInquiry});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final _supabase = Supabase.instance.client;
  String _selectedTab = 'Installation';
  final List<String> _tabs = [
    'Installation',
    'Inspection',
    'Testing',
    'Repair',
    'Preventive Maintenance',
  ];

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    final response = await _supabase
        .from('services')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  void _showServiceDetails(
    BuildContext context,
    String title,
    String description,
    String category,
    String imageUrl,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              const Icon(Icons.design_services, color: Color(0xFFB71C1C)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Text(
                  'Category: $category',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
            // DINAGDAG DIN NATIN ANG INQUIRY BUTTON SA LOOB NG DIALOG
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog first
                widget.onStartInquiry(); // Open inquiry form
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Start Inquiry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          _buildTabs(),
          _buildServicesList(),
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
            'Professional Fire Protection Services',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Comprehensive life-safety solutions engineered for maximum reliability and BFP compliance. Select a service to start your project inquiry.',
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

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: _tabs.map((tab) {
          bool isActive = _selectedTab == tab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = tab),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive
                        ? const Color(0xFFB71C1C)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive
                      ? const Color(0xFFB71C1C)
                      : const Color(0xFF666666),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFB71C1C)),
              ),
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'No services found.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          var services = snapshot.data!
              .where((s) => s['category'] == _selectedTab)
              .toList();

          if (services.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  'No services currently listed under this category.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return Column(
            children: services.map((service) {
              final title = service['service_name'] ?? 'Unknown Service';
              final desc = service['description'] ?? 'No description provided.';
              final cat = service['category'] ?? 'General';
              final imageUrl = service['image_url'] ?? '';

              IconData serviceIcon = Icons.build_circle_outlined;
              if (title.toLowerCase().contains('sprinkler')) {
                serviceIcon = Icons.shower_outlined;
              }
              if (title.toLowerCase().contains('alarm')) {
                serviceIcon = Icons.sensors;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF0F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            serviceIcon,
                            color: const Color(0xFFB71C1C),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                desc,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF666666),
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // IN-UPDATE NATIN ANG BUTTONS DITO PARA DALAWA NA
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () => _showServiceDetails(
                              context,
                              title,
                              desc,
                              cat,
                              imageUrl,
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF666666),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: widget
                                .onStartInquiry, // ETO YUNG MAGBUBUKAS NG FORM
                            icon: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Start Inquiry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB71C1C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.shield, color: Color(0xFFB71C1C), size: 36),
          const SizedBox(height: 16),
          const Text(
            'Katala Fire Protection',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Safeguarding Lives and Assets',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFF333333)),
          const SizedBox(height: 16),
          const Text(
            '© 2026 Katala Fire Protection Product Trading.\nAll rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 10, height: 1.5),
          ),
        ],
      ),
    );
  }
}
