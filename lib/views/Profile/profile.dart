import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Import this for FilteringTextInputFormatter
import 'package:http/http.dart' as http; // Import this for HTTP requests
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import this for dotenv

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
  String _firstName = '';
  String _lastName = '';
  String _phoneNumber = '';
  String _email = '';
  File? _image;
  String? _imageUrl = '';
  bool _isLoading = true;
  bool _isUploading = false; // Add this variable

  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _phoneController.addListener(() {
      final text = _phoneController.text;
      if (text.length > 8) {
        _phoneController.text = text.substring(0, 8);
        _phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: _phoneController.text.length),
        );
      }
    });
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _isUploading = true; // Set loading state to true
      });
      final userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        setState(() {
          _username = userData['username'];
          _firstName = userData['first_name'];
          _lastName = userData['last_name'];
          _phoneNumber = userData['phone_number'].toString();
          _email = _user!.email!;
          _imageUrl = userData['photo'];
          _phoneController.text = _phoneNumber;
          _isUploading = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageToCloudinary() async {
    if (_image == null) return;
    setState(() {
      _isUploading = true; // Set loading state to true
    });
    try {
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];
      final uploadPreset = dotenv.env['UPLOAD_PRESET'];
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset!
        ..fields['api_key'] = apiKey!
        ..fields['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString()
        ..fields['signature'] = _generateSignature(apiSecret!, uploadPreset)
        ..files.add(await http.MultipartFile.fromPath('file', _image!.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      setState(() {
        _imageUrl = jsonResponse['secure_url'];
        _isUploading = false; // Reset loading state
      });
    } catch (e) {
      print('Failed to upload image: $e');
      setState(() {
        _isUploading = false; // Reset loading state on error
      });
    }
  }

  String _generateSignature(String apiSecret, String uploadPreset) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final signatureString =
        'timestamp=$timestamp&upload_preset=$uploadPreset$apiSecret';
    return sha1.convert(utf8.encode(signatureString)).toString();
  }

  Future<void> _updateProfile() async {
    _user = _auth.currentUser;
    if (_user != null) {
      setState(() {
        _isLoading = true;
      });
      if (_image != null) {
        await _uploadImageToCloudinary();
      }
      await _firestore.collection('users').doc(_user!.uid).update({
        'username': _username,
        'first_name': _firstName,
        'last_name': _lastName,
        'phone_number': _phoneNumber,
        'photo': _imageUrl,
      });
      await _user!.verifyBeforeUpdateEmail(_email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Profile is updated"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 22.0),
      ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    if (_username != "") {
      setState(() {
        _isLoading = false;
      });
    }
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Wrap the content in a scrollable view
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 150,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : _imageUrl != null
                                    ? NetworkImage(_imageUrl!)
                                    : AssetImage('images/default_profile.jpg')
                                        as ImageProvider,
                          ),
                          if (_isUploading)
                            CircularProgressIndicator(), // Show loader if uploading
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _firstName,
                            decoration:
                                InputDecoration(labelText: 'First name'),
                            onChanged: (value) => _firstName = value,
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: TextFormField(
                            initialValue: _lastName,
                            decoration: InputDecoration(labelText: 'Last name'),
                            onChanged: (value) => _lastName = value,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: _username,
                      decoration: InputDecoration(labelText: 'Username'),
                      onChanged: (value) => _username = value,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone number'),
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            !RegExp(r'^[1-9][0-9]*$').hasMatch(value)) {
                          return;
                        }
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      readOnly: true,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
