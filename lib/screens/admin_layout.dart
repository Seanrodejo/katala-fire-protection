import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'admin_products.dart';
import 'admin_services.dart';
import 'admin_portfolio.dart';
import 'admin_requests.dart';
import 'admin_appointments.dart';
import 'admin_customers.dart';
import 'admin_accounts.dart'; // BAGONG IMPORT
import 'admin_settings.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard_outlined, 'title': 'Dashboard'},
    {'icon': Icons.inventory_2_outlined, 'title': 'Products'},
    {'icon': Icons.design_services_outlined, 'title': 'Services'},
    {'icon': Icons.cases_outlined, 'title': 'Portfolio'},
    {'icon': Icons.description_outlined, 'title': 'Requests'},
    {'icon': Icons.calendar_today_outlined, 'title': 'Appointments'},
    {'icon': Icons.people_outline, 'title': 'Customers'},
    {
      'icon': Icons.manage_accounts_outlined,
      'title': 'Accounts',
    }, // BAGONG MENU ITEM
    {'icon': Icons.settings_outlined, 'title': 'Settings'},
  ];

  @override
  Widget build(BuildContext context) {
    // LOGIC PARA SA RESPONSIVENESS
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // KAPAG MOBILE: Ipakita ang AppBar na may Hamburger Menu
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: const Color(0xFF2C3E50),
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                'Katala Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),

      // KAPAG MOBILE: Ipakita ang Sidebar sa loob ng Drawer
      drawer: isDesktop
          ? null
          : Drawer(child: _buildSidebar(context, isDesktop)),

      body: Row(
        children: [
          // KAPAG DESKTOP: Naka-fix ang Sidebar sa kaliwa
          if (isDesktop) _buildSidebar(context, isDesktop),

          Expanded(
            child: Column(
              children: [
                // TOP BAR (Para lang sa Desktop view)
                if (isDesktop) _buildTopAppBar(),

                // ACTUAL SCREEN CONTENT
                Expanded(child: _buildAdminBodyContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, bool isDesktop) {
    return Container(
      width: 260,
      color: const Color(0xFF2C3E50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield,
                    color: Color(0xFFB71C1C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Katala Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Safety Management',
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    // Isara agad ang drawer sa mobile kapag may pinindot
                    if (!isDesktop) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFB71C1C)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _menuItems[index]['icon'],
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _menuItems[index]['title'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Admin Portal',
            style: TextStyle(
              color: Color(0xFFB71C1C),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: const [
              Icon(Icons.notifications_outlined, color: Colors.grey),
              SizedBox(width: 24),
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=100&auto=format&fit=crop',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboard();
      case 1:
        return const AdminProducts();
      case 2:
        return const AdminServices();
      case 3:
        return const AdminPortfolio();
      case 4:
        return const AdminRequests();
      case 5:
        return const AdminAppointments();
      case 6:
        return const AdminCustomers();
      case 7:
        return const AdminAccounts(); // YUNG BAGONG ACCOUNTS PAGE MO
      case 8:
        return const AdminSettings();
      default:
        return const AdminDashboard();
    }
  }
}
