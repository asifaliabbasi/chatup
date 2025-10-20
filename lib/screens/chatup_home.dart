import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'status_screen.dart';
import 'calls_screen.dart';
import 'select_contact_screen.dart';
import 'settings_screen.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart'; // AuthProvider ko import karein
import '../theme.dart';

class WhatsAppHome extends StatefulWidget {
  const WhatsAppHome({super.key});

  @override
  State<WhatsAppHome> createState() => _WhatsAppHomeState();
}

// WidgetsBindingObserver ko add karein taake app ka lifecycle (online/offline) detect kar sakein
class _WhatsAppHomeState extends State<WhatsAppHome>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  bool _isSearching = false;
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // App lifecycle changes ko sunne ke liye observer add karein
    WidgetsBinding.instance.addObserver(this);
    // App start hotay hi user ko online set karein
    _updateUserStatus(true);
  }

  // App ki state change hone par yeh function call hoga
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App dobara screen par aayi hai (online)
      _updateUserStatus(true);
    } else {
      // App background mein chali gayi ya band ho gayi (offline)
      _updateUserStatus(false);
    }
  }

  void _updateUserStatus(bool isOnline) {
    // AuthProvider ke zariye user ka status update karein
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      authProvider.updateUserOnlineStatus(isOnline);
    }
  }


  void _startSearch() => setState(() => _isSearching = true);

  void _stopSearch() => setState(() {
    _isSearching = false;
    _searchText = "";
  });

  void _onBottomNavTapped(int index) => _tabController.animateTo(index);

  @override
  void dispose() {
    _tabController.dispose();
    // Observer ko remove karna zaroori hai
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    // AuthProvider ko access karein taake user data aur sign out function use kar sakein
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        title: _isSearching
            ? TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search chats...',
            hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
            border: InputBorder.none,
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          onChanged: (value) => setState(() => _searchText = value),
        )
            : Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 65,
              height: 65,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'ChatUp',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: _isSearching ? _stopSearch : _startSearch,
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryGreen,
          labelColor: isDarkMode ? Colors.white : Colors.black,
          unselectedLabelColor: isDarkMode ? Colors.white54 : Colors.black54,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
            Tab(text: 'Calls'),
          ],
        ),
      ),

      drawer: Drawer(
        child: Container(
          color: isDarkMode ? Colors.black : Colors.white70,
          child: ListView(
            children: [
              // User ki profile information dikhane ke liye DrawerHeader
              DrawerHeader(
                decoration: BoxDecoration(color: isDarkMode ? Colors.black : Colors.white70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    authProvider.userProfile?.profileImageUrl.isNotEmpty == true
                        ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(authProvider.userProfile!.profileImageUrl),
                    )
                        : const CircleAvatar( // Default picture
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    // User ka Naam
                    Text(
                      authProvider.userProfile?.name ?? 'Loading...', // User ka naam ya loading text
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    // User ka Phone number
                    Text(
                      authProvider.userProfile?.phone ?? '', // User ka phone number
                      style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
                title: Text("Settings",
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SettingsScreen()));
                },
              ),
              const Divider(),
              // Sign Out ka button
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Sign Out",
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  // App band karne se pehle user ko offline set karein
                  _updateUserStatus(false);
                  // AuthProvider se signOut function call karein
                  authProvider.signOut();
                  // Drawer ko band karein
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          ChatScreen(searchText: _searchText),
          const StatusScreen(),
          const CallsScreen(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
        backgroundColor: AppTheme.primaryGreen,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const SelectContactScreen()),
          );
          setState(() {});
        },
        child: const Icon(Icons.message, color: Colors.white),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: isDarkMode ? Colors.white : Colors.black,
        currentIndex: _tabController.index,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),
    );
  }
}
