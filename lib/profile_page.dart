//profile_page.dart
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Container(
          color: Colors.grey[900],
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const ListTile(
                trailing: Icon(Icons.menu),
              ),
              _buildAvatarSelection(context),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Name",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: Colors.white),
                  )
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("@username", style: TextStyle(color: Colors.white),)],
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bio",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildCard(
                      context,
                      icon: Icons.privacy_tip_sharp,
                      title: 'Privacy',
                    ),
                    const SizedBox(height: 10),
                    _buildCard(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                    ),
                    const SizedBox(height: 10),
                    _buildCard(
                      context,
                      icon: Icons.privacy_tip_sharp,
                      title: 'Settings',
                    ),
                    const SizedBox(height: 10),
                    _buildCard(
                      context,
                      icon: Icons.add_reaction_sharp,
                      title: 'Invite a Friend',
                    ),
                    const SizedBox(height: 10),
                    _buildCard(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSelection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            // Handle avatar selection or upload
          },
          child: CircleAvatar(
            maxRadius: 65,
            backgroundImage: AssetImage("assets/placeholder_avatar.png"),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required IconData icon, required String title}) {
    return Card(
      margin: const EdgeInsets.only(left: 35, right: 35, bottom: 10),
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.white),
      ),
    );
  }
}
