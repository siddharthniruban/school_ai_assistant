import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_ai_assistant/providers/app_state.dart';
import 'package:school_ai_assistant/screens/question_generator_screen.dart';
import 'package:school_ai_assistant/screens/upload_screen.dart';

class SyllabusScreen extends StatefulWidget {
  @override
  _SyllabusScreenState createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  String _selectedClass = 'Class 6';
  String _selectedSubject = 'Science';
  
  // Sample data for demo purposes
  final Map<String, List<String>> _subjects = {
    'Class 6': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 7': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 8': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 9': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 10': ['Science', 'Mathematics', 'English', 'Social Studies'],
  };
  
  final Map<String, Map<String, List<String>>> _syllabusData = {
    'Class 6': {
      'Science': [
        'Chapter 1: Food',
        'Chapter 2: Materials',
        'Chapter 3: The World of Living',
        'Chapter 4: Moving Things',
        'Chapter 5: Plants',
      ],
      'Mathematics': [
        'Chapter 1: Knowing Our Numbers',
        'Chapter 2: Whole Numbers',
        'Chapter 3: Playing with Numbers',
        'Chapter 4: Basic Geometrical Ideas',
        'Chapter 5: Understanding Elementary Shapes',
      ],
    },
    'Class 7': {
      'Science': [
        'Chapter 1: Nutrition in Plants',
        'Chapter 2: Nutrition in Animals',
        'Chapter 3: Fibre to Fabric',
        'Chapter 4: Heat',
        'Chapter 5: Acids, Bases and Salts',
      ],
    },
  };
  
  @override
  Widget build(BuildContext context) {
    List<String> subjects = _subjects[_selectedClass] ?? [];
    if (subjects.isNotEmpty && !subjects.contains(_selectedSubject)) {
      _selectedSubject = subjects[0];
    }
    
    List<String> chapters = _syllabusData[_selectedClass]?[_selectedSubject] ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Syllabus'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Class',
                      border: OutlineInputBorder(),
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
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
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
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Chapters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: chapters.isEmpty
                ? Center(
                    child: Text(
                      'No chapters available for this selection',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: chapters.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ExpansionTile(
                          title: Text(chapters[index]),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Topics:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  // Sample topics - in a real app, these would come from the database
                                  Text('• Topic 1: Introduction'),
                                  Text('• Topic 2: Key Concepts'),
                                  Text('• Topic 3: Applications'),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton.icon(
                                        icon: Icon(Icons.question_answer),
                                        label: Text('Generate Questions'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => QuestionGeneratorScreen(
                                                initialClass: _selectedClass,
                                                initialSubject: _selectedSubject,
                                                initialChapter: chapters[index],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Provider.of<AppState>(context).userRole == 'Admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreen()),
                );
              },
              child: Icon(Icons.add),
              tooltip: 'Add Syllabus',
            )
          : null,
    );
  }
}
