// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/tenant/requests/planned_tenant_requests.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class MaintenanceRequestViewPage extends StatefulWidget {
//   @override
//   _MaintenanceRequestViewPageState createState() =>
//       _MaintenanceRequestViewPageState();
// }

// class _MaintenanceRequestViewPageState
//     extends State<MaintenanceRequestViewPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _description = '';
//   String _priority = 'Low';
//   File? _image;

//   final List<String> _priorityOptions = ['Low', 'Medium', 'High'];

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       final newRequest = MaintenanceRequest(_description, _priority, _image);
//       Navigator.of(context).pop(newRequest);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Text('New Maintenance Request',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             TextFormField(
//               decoration: InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//               validator: (value) =>
//                   value == null || value.isEmpty ? 'Enter a description' : null,
//               onSaved: (value) => _description = value!,
//             ),
//             SizedBox(height: 10),
//             DropdownButtonFormField<String>(
//               value: _priority,
//               items: _priorityOptions
//                   .map((level) => DropdownMenuItem(
//                         value: level,
//                         child: Text(level),
//                       ))
//                   .toList(),
//               onChanged: (value) => setState(() => _priority = value!),
//               decoration: InputDecoration(labelText: 'Priority'),
//             ),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 _image != null
//                     ? Image.file(_image!,
//                         height: 80, width: 80, fit: BoxFit.cover)
//                     : Container(
//                         height: 80,
//                         width: 80,
//                         color: Colors.grey[300],
//                         child: Icon(Icons.image)),
//                 SizedBox(width: 10),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.upload),
//                   label: Text('Upload Image'),
//                   onPressed: _pickImage,
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _submitForm,
//               icon: Icon(Icons.send),
//               label: Text('Submit'),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
