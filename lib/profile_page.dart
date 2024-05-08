//profile_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "Your Name";
  String _username = "@email";
  String _bio = "Your Bio";
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editProfile(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildAvatarSelection(context),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _name,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: Colors.white),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _username.substring(1),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Bio',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  _bio,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              _buildButton(
                icon: Icons.privacy_tip_sharp,
                title: 'Privacy',
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.help_outline,
                title: 'Help & Support',
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.privacy_tip_sharp,
                title: 'Settings',
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.add_reaction_sharp,
                title: 'Invite a Friend',
              ),
              const SizedBox(height: 10),
              _buildButton(
                icon: Icons.logout,
                title: 'Logout',
              ),
              const SizedBox(height: 20),
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
            _showImagePicker(context);
          },
          child: CircleAvatar(
            maxRadius: 65,
            backgroundImage: _image != null ? FileImage(_image!) : AssetImage("assets/placeholder_avatar.png") as ImageProvider<Object>?,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({required IconData icon, required String title}) {
    return ElevatedButton(
      onPressed: () {
        if (title == 'Invite a Friend') {
          _composeAndSendInvite();
        } else {
          _showNotImplementedMessage(context);
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
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

  void _editProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: _name,
          username: _username.substring(1), // Exclude '@' from being passed to the edit page
          bio: _bio,
        ),
      ),
    );

    if (result != null && result is Map<String, String>) {
      setState(() {
        _name = result['name'] ?? _name;
        _username = '@${result['username'] ?? _username.substring(1)}'; // Add '@' back to the username
        _bio = result['bio'] ?? _bio;
      });
    }
  }

  void _showNotImplementedMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Not Implemented'),
          content: Text('This feature is not yet implemented.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _composeAndSendInvite() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _emailController = TextEditingController();

        return AlertDialog(
          title: Text('Compose Invite'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Recipient Email',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _sendAppInvite(_emailController.text);
                  Navigator.pop(context);
                },
                child: Text('Send Invite'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendAppInvite(String recipientEmail) async {
    final smtpServer = gmail('Alanrock35@gmail.com', 'drpb wazm lzkj vdzx');

    final message = Message()
      ..from = Address('Alanrock35@gmail.com', 'Alan')
      ..recipients.add(recipientEmail)
      ..subject = 'Join me on GymTrack!'
      ..text = 'Hey there!\n\nI am using GymTrack to track my workouts, and it\'s been fantastic! You should join me. Download GymTrack from the app store now!\n\nCheers,\n${_name}';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      // Additional code for feedback to the user
    } catch (e) {
      print('Error occurred while sending email: $e');
      // Additional code for error handling
    }
  }

  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a photo'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String username;
  final String bio;

  const EditProfilePage({Key? key, required this.name, required this.username, required this.bio}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _usernameController = TextEditingController(text: widget.username);
    _bioController = TextEditingController(text: widget.bio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            SizedBox(height: 20),
            Text('Email'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '@',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Bio'),
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: 'Enter your bio',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveProfile();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    Navigator.pop(
      context,
      {
        'name': _nameController.text,
        'username': _usernameController.text,
        'bio': _bioController.text,
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
