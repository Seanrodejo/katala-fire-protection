import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAppointments extends StatefulWidget {
  const AdminAppointments({super.key});

  @override
  State<AdminAppointments> createState() => _AdminAppointmentsState();
}

class _AdminAppointmentsState extends State<AdminAppointments> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;
  int _selectedTab = 0;
  final List<String> _tabs = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        _appointments = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUpdateStatusDialog(String id, String currentStatus) {
    String newStatus = currentStatus;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Update Appointment Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: DropdownButtonFormField<String>(
            value:
                [
                  'Pending',
                  'Confirmed',
                  'Completed',
                  'Cancelled',
                ].contains(currentStatus)
                ? currentStatus
                : 'Pending',
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: ['Pending', 'Confirmed', 'Completed', 'Cancelled'].map((
              String val,
            ) {
              return DropdownMenuItem(value: val, child: Text(val));
            }).toList(),
            onChanged: (value) {
              if (value != null) newStatus = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _supabase
                      .from('appointments')
                      .update({'status': newStatus})
                      .eq('id', id);
                  if (mounted) {
                    Navigator.pop(context);
                    _fetchAppointments();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Status Updated!'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB71C1C),
              ),
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // RESPONSIVENESS LOGIC
    final isDesktop = MediaQuery.of(context).size.width > 800;

    List<Map<String, dynamic>> filteredAppointments = _appointments;
    if (_selectedTab != 0) {
      String filterStatus = _tabs[_selectedTab];
      filteredAppointments = _appointments
          .where((appt) => appt['status'] == filterStatus)
          .toList();
    }

    return Container(
      margin: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
      padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GINAWANG WRAP ANG HEADER PARA HINDI MA-CUT ANG BUTTON
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Appointments',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage engineering consultations and site inspections.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _fetchAppointments,
                icon: const Icon(
                  Icons.refresh,
                  color: Color(0xFFB71C1C),
                  size: 18,
                ),
                label: const Text(
                  'Refresh',
                  style: TextStyle(color: Color(0xFFB71C1C)),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFB71C1C)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // HORIZONTAL SCROLL PARA SA TABS SA MOBILE
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildTabs(),
          ),
          const SizedBox(height: 16),
          // RESPONSIVE TABLE
          Expanded(child: _buildTable(filteredAppointments)),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(_tabs.length, (index) {
        bool isSelected = _selectedTab == index;
        return InkWell(
          onTap: () => setState(() => _selectedTab = index),
          child: Container(
            margin: const EdgeInsets.only(right: 24),
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected
                      ? const Color(0xFFB71C1C)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              _tabs[index],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFB71C1C) : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> appointments) {
    // BINALOT ANG TABLE SA HORIZONTAL SCROLLVIEW
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 700, // MINIMUM WIDTH PARA HINDI MAG-SQUEEZE
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                ),
              ),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'CLIENT NAME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'APPOINTMENT DATE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'ACTIONS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB71C1C),
                      ),
                    )
                  : appointments.isEmpty
                  ? const Center(
                      child: Text(
                        'No appointments booked yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appt = appointments[index];
                        final status = appt['status'] ?? 'Pending';
                        Color statusColor = Colors.orange;
                        if (status == 'Confirmed') statusColor = Colors.blue;
                        if (status == 'Completed') statusColor = Colors.green;
                        if (status == 'Cancelled') statusColor = Colors.red;

                        String rawDate = appt['appointment_date'] ?? 'TBA';
                        String formattedDate = rawDate.length >= 10
                            ? rawDate.substring(0, 10)
                            : rawDate;

                        return _buildTableRow(
                          appt['id'].toString(),
                          appt['client_name'] ?? 'Unknown',
                          formattedDate,
                          status,
                          statusColor,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(
    String id,
    String name,
    String date,
    String status,
    Color dotColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => _showUpdateStatusDialog(id, status),
              child: const Text(
                'Update',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
