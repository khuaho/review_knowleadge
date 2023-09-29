import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:review_knowleadge/global/data/models/user/user.dart';

import '../../../global/widgets/image_input.dart';

class UpsertUserPage extends StatefulWidget {
  const UpsertUserPage({super.key});

  @override
  State<UpsertUserPage> createState() => _UpsertUserPageState();
}

class _UpsertUserPageState extends State<UpsertUserPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void fakeDataHandler() {
    _formKey.currentState?.fields['name']?.didChange(faker.person.name());
    _formKey.currentState?.fields['profession']?.didChange(faker.job.title());
  }

  Future<void> upsertData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      final url = Uri.https(
        'flutterapp-370bf-default-rtdb.firebaseio.com',
        'users.json',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': data['name'],
          'age': int.parse(data['age']),
          'profession': data['profession'],
        }),
      );

      final Map<String, dynamic> resData = json.decode(response.body);

      // print(response.body);
      // print(response.statusCode);

      if (mounted) {
        Navigator.of(context).pop(
          User(
            id: resData['name'],
            name: data['name'],
            age: int.parse(data['age']),
            profession: data['profession'],
          ),
        );
      }
    }
  }

  void resetData() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    // User data = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upsert user page'),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                // initialValue: ,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  // label: Text('Name'),
                  hintText: 'Enter name',
                  suffixIcon: SizedBox.square(dimension: 40),
                ),
                valueTransformer: (String? value) => value!.trim(),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'Name is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'age',
                // initialValue:,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  // label: Text('Age'),
                  hintText: 'Enter age',
                  suffixIcon: SizedBox.square(dimension: 40),
                ),
                valueTransformer: (String? value) => value!.trim(),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'Age is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'profession',
                // initialValue: ,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  // label: Text('Profession'),
                  hintText: 'Enter profession',
                  suffixIcon: SizedBox.square(dimension: 40),
                ),
                valueTransformer: (String? value) => value!.trim(),
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: 'Profession is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FormBuilderField(
                name: 'avatar',
                // initialValue: ,
                builder: (field) {
                  return ImageInput(
                    onChanged: (value) {
                      field.didChange(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: resetData,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: fakeDataHandler,
                    child: const Text('Generate data'),
                  ),
                  ElevatedButton(
                    onPressed: upsertData,
                    child: const Text('Create data'),
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
