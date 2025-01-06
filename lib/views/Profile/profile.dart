import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();

  User? _user;
  String? _username = '';
  String _email = '';
  File? _image;
  String? _base64Image;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
      _uploadBase64Image();
    }
  }

  Future<void> _uploadBase64Image() async {
    if (_base64Image == null || _user == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'photoBase64': _base64Image,
      });
    } catch (e) {
      print('Failed to upload image: $e');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _isLoading = true;
      });
      await _firestore.collection('users').doc(_user!.uid).update({
        'username': _username,
      });
      await _user!.verifyBeforeUpdateEmail(_email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Prodile is updated")),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    _username = authViewModel.username;
    _email = authViewModel.email;
    if (_username != "") {
      setState(() {
        _isLoading = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Profile"),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      icon: Icon(Icons.person))
                ],
              )
            ],
          )),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _base64Image != null
                          ? MemoryImage(base64Decode(_base64Image!))
                          : AssetImage('images/default_profile.jpg')
                              as ImageProvider,
                    ),
                  ),
                  TextFormField(
                    initialValue: _username,
                    decoration: InputDecoration(labelText: 'Username'),
                    onChanged: (value) => _username = value,
                  ),
                  TextFormField(
                    initialValue: _email,
                    decoration: InputDecoration(labelText: 'Email'),
                    readOnly: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
