import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userdatastorage/models/user_data.dart';
import 'package:userdatastorage/services/bloc/internet_bloc/internet_access_bloc.dart';
import 'package:userdatastorage/services/bloc/user_data_bloc/user_data_bloc.dart';

class AddUserData extends StatefulWidget {
  const AddUserData({super.key});

  @override
  State<AddUserData> createState() => _AddUserDataState();
}

class _AddUserDataState extends State<AddUserData> {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _imageController = TextEditingController();

  final _userDataFormKey = GlobalKey<FormState>();

  String? _nameValidator(String? value) {
    if (value == null ||
        !RegExp(r"^[A-Za-z][A-Za-z0-9_]{4,25}$").hasMatch(value)) {
      return 'Very short name';
    }
    return null;
  }

  String? _phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    } else if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
      return 'Wrong phone number';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Wrong email';
    }
    return null;
  }

  String? _dateOfBirthValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  String? _imageValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  late UserData newUserData;
  late File selectedFile;
  late String _base64Image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add user data'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UserDataBloc, UserDataState>(
            listener: (context, state) {},
          ),
          BlocListener<InternetAccessBloc, InternetAccessState>(
            listener: (context, state) {},
          ),
        ],
        child: Form(
          key: _userDataFormKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: TextFormField(
                      controller: _nameController,
                      validator: _nameValidator,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: TextFormField(
                      controller: _phoneNumberController,
                      validator: _phoneNumberValidator,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: TextFormField(
                      controller: _emailIdController,
                      validator: _emailValidator,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.today),
                    title: TextFormField(
                      controller: _dateOfBirthController,
                      validator: _dateOfBirthValidator,
                      decoration: const InputDecoration(
                        hintText: 'DOB',
                      ),
                      keyboardType: TextInputType.datetime,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980, 1),
                          lastDate: DateTime.now(),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            final dateOfBirth =
                                pickedDate.toString().split(" ");
                            _dateOfBirthController.text = dateOfBirth[0];
                          }
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.image),
                    title: TextFormField(
                      controller: _imageController,
                      validator: _imageValidator,
                      decoration: const InputDecoration(
                        hintText: 'Image',
                      ),
                      onTap: () async {
                        FilePickerResult? pickedFile =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                        );

                        if (pickedFile != null) {
                          final file = pickedFile.files.first;
                          _base64Image = base64Encode(
                              File(file.path.toString()).readAsBytesSync());
                          _imageController.text = pickedFile.files.single.name;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_userDataFormKey.currentState!.validate()) {
                          newUserData = UserData(
                            userName: _nameController.text,
                            phoneNumber: _phoneNumberController.text,
                            dateOfBirth: _dateOfBirthController.text,
                            emailId: _emailIdController.text,
                            image: _base64Image,
                          );
                          final internetState =
                              context.read<InternetAccessBloc>().state;
                          if (internetState is InternetAccessSuccessState) {
                            context.read<UserDataBloc>().add(
                                AddUserDataEventOnline(userData: newUserData));
                            Navigator.of(context).pop();
                          } else {
                            context.read<UserDataBloc>().add(
                                AddUserDataEventOffline(userData: newUserData));
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
