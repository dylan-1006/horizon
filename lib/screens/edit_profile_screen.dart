import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/constants.dart';
import 'package:horizon/auth.dart';
import 'package:horizon/screens/error_screen.dart';
import 'package:horizon/screens/loading_screen.dart';
import 'package:horizon/screens/settings_profile_screen.dart';
import 'package:horizon/utils/database_utils.dart';
import 'package:horizon/utils/navigation_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = '';
  bool _isPasswordValid = true;
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;
  Map<String, dynamic> userData = {};
  late String userId;
  String _joinedDate = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchUserData() async {
    userId = await Auth().getUserId();
    userData = await DatabaseUtils.getUserData(userId);

    // Format the timestamp to a readable date
    if (userData['dateJoined'] != null) {
      DateTime joinDate = (userData['dateJoined'] as Timestamp).toDate();
      _joinedDate =
          '${joinDate.day} ${_getMonth(joinDate.month)} ${joinDate.year}';
    }
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword(String value) {
    setState(() {
      _isPasswordValid = value.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(onRefresh: () {});
          } else {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                shadowColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: Container(
                  child: const BackButton(
                    color: Colors.black,
                  ),
                ),
              ),
              body: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/settings_screen_background.png'),
                        fit: BoxFit.cover)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 85),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: userData['profileImgUrl'] != null
                                        ? NetworkImage(
                                            userData['profileImgUrl'])
                                        : const AssetImage(
                                                'assets/images/default_user_profile_picture.jpg')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Implement image picker
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Constants.primaryColor,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Email (non-editable)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FormBuilderTextField(
                                name: "email",
                                enabled: false,
                                initialValue: userData['email'] ?? '',
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      color: Constants.accentColor),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey[400]!, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Name Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FormBuilderTextField(
                                name: "name",
                                initialValue: userData['name'] ?? '',
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      color: Constants.accentColor),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Constants.primaryColor,
                                          width: 1.5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FormBuilderTextField(
                                name: "password",
                                obscureText: _isObscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null; // Password is optional
                                  }
                                  if (value.length < 8) {
                                    return "Password must be at least 8 characters long";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    child: Icon(
                                      _isObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20,
                                      color: Constants.accentColor,
                                    ),
                                  ),
                                  isDense: true,
                                  labelText: "New Password",
                                  labelStyle: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 15,
                                      color: Constants.accentColor),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Constants.primaryColor,
                                          width: 1.5)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 1)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.red, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Save Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () async {
                                if (_formKey.currentState!.saveAndValidate()) {
                                  try {
                                    final formData =
                                        _formKey.currentState!.value;

                                    // Update name if changed
                                    if (formData['name'] != userData['name']) {
                                      await Auth().updateName(
                                          newName: formData['name']);
                                    }

                                    // Update password only if not empty
                                    if (formData['password'] != null &&
                                        formData['password']
                                            .trim()
                                            .isNotEmpty) {
                                      await Auth().updatePassword(
                                          newPassword: formData['password']);
                                    }

                                    // Show success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Profile updated successfully'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );

                                    NavigationUtils.pushAndRemoveUntil(
                                        context, const SettingsProfileScreen());
                                  } catch (e) {
                                    // Show error message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Error updating profile: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),

                          // Joined date
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Joined: ',
                                style: TextStyle(
                                    fontSize: 12, color: Constants.accentColor),
                              ),
                              Text(
                                _joinedDate,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
