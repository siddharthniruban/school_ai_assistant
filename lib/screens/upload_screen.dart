import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:school_ai_assistant/providers/app_state.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedClass = 'Class 6';
  String _selectedSubject = 'Science';
  final _chapterController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedFile;
  bool _isUploading = false;
  String? _uploadedFileUrl;
  
  // Sample data
  final Map<String, List<String>> _subjects = {
    'Class 6': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 7': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 8': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 9': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 10': ['Science', 'Mathematics', 'English', 'Social Studies'],
  };
  
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }
  
  Future<void> _uploadFile() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      setState(() {
        _isUploading = true;
      });
      
      try {
        // In a real app, this would upload to Firebase Storage
        // For demo purposes, we'll simulate the upload with a delay
        await Future.delayed(Duration(seconds: 2));
        
        setState(() {
          _isUploading = false;
          _uploadedFileUrl = 'https://example.com/sample_file.pdf'; // Mock URL
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Material uploaded successfully')),
        );
        
        // Clear form
        _chapterController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedFile = null;
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.toString()}')),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _chapterController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Check if user has permission to upload
    final userRole = Provider.of<AppState>(context).userRole;
    final hasUploadPermission = userRole == 'Admin' || userRole == 'Teacher';
    
    if (!hasUploadPermission) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Upload Materials'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'You don\'t have permission to upload materials',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
    
    List<String> subjects = _subjects[_selectedClass] ?? [];
    if (subjects.isNotEmpty && !subjects.contains(_selectedSubject)) {
      _selectedSubject = subjects[0];
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Materials'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add New Syllabus Material',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Class',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.class_),
                ),
                value: _selectedClass,
                items: _subjects.keys.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedClass = newValue;
                      if (_subjects[newValue]?.isNotEmpty ?? false) {
                        _selectedSubject = _subjects[newValue]![0];
                      }
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.subject),
                ),
                value: subjects.contains(_selectedSubject) ? _selectedSubject : (subjects.isNotEmpty ? subjects[0] : null),
                items: subjects.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSubject = newValue;
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _chapterController,
                decoration: InputDecoration(
                  labelText: 'Chapter Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book),
                  hintText: 'e.g., Chapter 1: Food',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a chapter name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Brief description of the material',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              OutlinedButton.icon(
                icon: Icon(Icons.upload_file),
                label: Text(_selectedFile == null ? 'Select File' : 'Change File'),
                onPressed: _pickFile,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_selectedFile != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedFile!.path.split('/').last,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${(_selectedFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedFile = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: (_selectedFile == null || _isUploading) ? null : _uploadFile,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: _isUploading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Upload Material',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              if (_uploadedFileUrl != null) ...[
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Successfully Uploaded',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('The material has been added to the syllabus and is now available for teachers and students.'),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          // In a real app, this would navigate to the file
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Viewing file...')),
                          );
                        },
                        child: Text('View Uploaded File'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
