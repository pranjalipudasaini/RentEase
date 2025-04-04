import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_application_1/pages/tenant/requests/planned_tenant_requests_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class MaintenanceRequest {
  final String title;
  final String description;
  final String priority;
  final File? imageFile;
  final Uint8List? imageBytes;

  MaintenanceRequest(
    this.title,
    this.description,
    this.priority,
    this.imageFile,
    this.imageBytes,
  );
}

class MaintenanceRequestPage extends StatefulWidget {
  @override
  _MaintenanceRequestPageState createState() => _MaintenanceRequestPageState();
}

class _MaintenanceRequestPageState extends State<MaintenanceRequestPage> {
  final List<MaintenanceRequest> _requests = [];
  final MaintenanceRequestPageController controller =
      Get.put(MaintenanceRequestPageController());

  void _openRequestForm() async {
    final result = await showModalBottomSheet<MaintenanceRequest>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: MaintenanceRequestForm(onSubmit: (request) {
          Navigator.pop(context, request);
        }),
      ),
    );

    if (result != null) {
      setState(() {
        _requests.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Maintenance Requests')),
      body: _requests.isEmpty
          ? Center(child: Text('No maintenance requests yet.'))
          : ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _requests.length,
              itemBuilder: (ctx, index) {
                final req = _requests[index];
                Widget imageWidget =
                    Icon(Icons.build_circle_outlined, size: 40);
                if (!kIsWeb && req.imageFile != null) {
                  imageWidget = Image.file(
                    req.imageFile!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                } else if (kIsWeb && req.imageBytes != null) {
                  imageWidget = Image.memory(
                    req.imageBytes!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: imageWidget,
                    title: Text(req.title),
                    subtitle:
                        Text('${req.description}\nPriority: ${req.priority}'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openRequestForm,
        child: Icon(Icons.add),
      ),
    );
  }
}

class MaintenanceRequestForm extends StatefulWidget {
  final Function(MaintenanceRequest) onSubmit;

  MaintenanceRequestForm({required this.onSubmit});

  @override
  _MaintenanceRequestFormState createState() => _MaintenanceRequestFormState();
}

class _MaintenanceRequestFormState extends State<MaintenanceRequestForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _priority = 'Low';
  File? _imageFile;
  Uint8List? _imageBytes;

  final List<String> _priorityOptions = ['Low', 'Medium', 'High'];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null; // Just in case
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Print to check the data before sending it to the backend
      print('Title: $_title');
      print('Description: $_description');
      print('Priority: $_priority');

      final controller = Get.find<MaintenanceRequestPageController>();

      await controller.submitRequest(
          _title, _description, _priority, _imageFile, _imageBytes);

      widget.onSubmit(
        MaintenanceRequest(
            _title, _description, _priority, _imageFile, _imageBytes),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a title'
                  : null,
              onSaved: (value) => _title = value!,
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Description of the issue'),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a description'
                  : null,
              onSaved: (value) => _description = value!,
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _priority,
              items: _priorityOptions
                  .map((level) =>
                      DropdownMenuItem(value: level, child: Text(level)))
                  .toList(),
              onChanged: (value) => setState(() => _priority = value!),
              decoration: InputDecoration(labelText: 'Priority'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _imageFile != null && !kIsWeb
                    ? Image.file(_imageFile!,
                        height: 100, width: 100, fit: BoxFit.cover)
                    : _imageBytes != null && kIsWeb
                        ? Image.memory(_imageBytes!,
                            height: 100, width: 100, fit: BoxFit.cover)
                        : Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: Icon(Icons.image),
                          ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.upload),
                  label: Text('Upload Image'),
                  onPressed: _pickImage,
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit Request'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
