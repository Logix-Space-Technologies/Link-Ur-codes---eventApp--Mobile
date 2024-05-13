import 'package:event_app_mobile/pages/admin/privateEventPage.dart';
import 'package:event_app_mobile/pages/admin/publicEventPage.dart';
import 'package:flutter/material.dart';

class AdminEventPage extends StatefulWidget {
  const AdminEventPage({super.key});

  @override
  State<AdminEventPage> createState() => _AdminEventPageState();
}

class _AdminEventPageState extends State<AdminEventPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "Public Events"),
            Tab(text: "Private Events"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PublicEventPage(),  // Directly linking to the PublicEventPage
          PrivateEventPage()  // Placeholder for actual private events page
        ],
      ),
    );
  }
}
