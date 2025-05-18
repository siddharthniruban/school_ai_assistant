import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class QuestionGeneratorScreen extends StatefulWidget {
  final String? initialClass;
  final String? initialSubject;
  final String? initialChapter;
  
  const QuestionGeneratorScreen({
    Key? key,
    this.initialClass,
    this.initialSubject,
    this.initialChapter,
  }) : super(key: key);
  
  @override
  _QuestionGeneratorScreenState createState() => _QuestionGeneratorScreenState();
}

class _QuestionGeneratorScreenState extends State<QuestionGeneratorScreen> {
  String _selectedClass = 'Class 6';
  String _selectedSubject = 'Science';
  String _selectedChapter = 'Chapter 1: Food';
  int _questionCount = 10;
  List<String> _questionTypes = ['MCQ', 'Short Answer', 'Long Answer'];
  Map<String, bool> _selectedTypes = {
    'MCQ': true,
    'Short Answer': true,
    'Long Answer': true,
  };
  String _difficultyLevel = 'Medium';
  bool _isGenerating = false;
  List<Map<String, dynamic>>? _generatedQuestions;
  
  // Sample data
  final Map<String, List<String>> _subjects = {
    'Class 6': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 7': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 8': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 9': ['Science', 'Mathematics', 'English', 'Social Studies'],
    'Class 10': ['Science', 'Mathematics', 'English', 'Social Studies'],
  };
  
  final Map<String, Map<String, List<String>>> _chaptersData = {
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
  void initState() {
    super.initState();
    
    // Set initial values if provided
    if (widget.initialClass != null) {
      _selectedClass = widget.initialClass!;
    }
    
    if (widget.initialSubject != null) {
      _selectedSubject = widget.initialSubject!;
    }
    
    if (widget.initialChapter != null) {
      _selectedChapter = widget.initialChapter!;
    }
    
    // Ensure the selected chapter is valid for the selected class and subject
    List<String> chapters = _chaptersData[_selectedClass]?[_selectedSubject] ?? [];
    if (chapters.isNotEmpty && !chapters.contains(_selectedChapter)) {
      _selectedChapter = chapters[0];
    }
  }
  
  void _generateQuestions() {
    setState(() {
      _isGenerating = true;
    });
    
    // In a real app, this would call an AI service API
    // For demo purposes, we'll simulate the generation with a delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isGenerating = false;
        _generatedQuestions = _getMockQuestions();
      });
    });
  }
  
  List<Map<String, dynamic>> _getMockQuestions() {
    List<Map<String, dynamic>> questions = [];
    
    // Add MCQs
    if (_selectedTypes['MCQ'] == true) {
      questions.add({
        'type': 'MCQ',
        'question': 'Which of the following is a source of carbohydrates?',
        'options': ['Rice', 'Eggs', 'Fish', 'Milk'],
        'answer': 'Rice',
      });
      
      questions.add({
        'type': 'MCQ',
        'question': 'Which nutrient helps in building muscles?',
        'options': ['Proteins', 'Fats', 'Carbohydrates', 'Vitamins'],
        'answer': 'Proteins',
      });
    }
    
    // Add Short Answers
    if (_selectedTypes['Short Answer'] == true) {
      questions.add({
        'type': 'Short Answer',
        'question': 'Explain the importance of a balanced diet.',
        'answer': 'A balanced diet contains all nutrients in the right proportion that are necessary for proper growth and development.',
      });
      
      questions.add({
        'type': 'Short Answer',
        'question': 'Name two sources of vitamin C.',
        'answer': 'Citrus fruits like oranges and lemons, and green vegetables like bell peppers are rich sources of vitamin C.',
      });
    }
    
    // Add Long Answers
    if (_selectedTypes['Long Answer'] == true) {
      questions.add({
        'type': 'Long Answer',
        'question': 'Describe the process of digestion in humans.',
        'answer': 'Digestion in humans is a complex process that begins in the mouth and ends in the small intestine. It involves mechanical and chemical breakdown of food into simpler substances that can be absorbed by the body.',
      });
    }
    
    return questions;
  }
  
  Future<void> _generatePdf() async {
    if (_generatedQuestions == null || _generatedQuestions!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions to export')),
      );
      return;
    }
    
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Question Paper'),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Class: $_selectedClass'),
              pw.Text('Subject: $_selectedSubject'),
              pw.Text('Chapter: $_selectedChapter'),
              pw.SizedBox(height: 20),
              ...(_generatedQuestions ?? []).map((question) {
                final index = _generatedQuestions!.indexOf(question) + 1;
                if (question['type'] == 'MCQ') {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Q$index. ${question['question']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      ...((question['options'] as List<String>).map((option) {
                        return pw.Padding(
                          padding: pw.EdgeInsets.only(bottom: 3),
                          child: pw.Text('• $option'),
                        );
                      }).toList()),
                      pw.SizedBox(height: 10),
                    ],
                  );
                } else {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Q$index. ${question['question']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('(${question['type']})'),
                      pw.SizedBox(height: 15),
                    ],
                  );
                }
              }).toList(),
            ],
          );
        },
      ),
    );
    
    // Save the PDF
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/question_paper.pdf');
    await file.writeAsBytes(await pdf.save());
    
    // Open the PDF
    OpenFile.open(file.path);
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the available subjects and chapters based on selected class
    List<String> subjects = _subjects[_selectedClass] ?? [];
    if (subjects.isNotEmpty && !subjects.contains(_selectedSubject)) {
      _selectedSubject = subjects[0];
    }
    
    List<String> chapters = _chaptersData[_selectedClass]?[_selectedSubject] ?? [];
    if (chapters.isNotEmpty && !chapters.contains(_selectedChapter)) {
      _selectedChapter = chapters[0];
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Questions'),
      ),
      body: _generatedQuestions == null
          ? _buildQuestionGeneratorForm(subjects, chapters)
          : _buildGeneratedQuestionsList(),
    );
  }
  
  Widget _buildQuestionGeneratorForm(List<String> subjects, List<String> chapters) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select Parameters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
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
                  // Reset subject and chapter when class changes
                  if (_subjects[newValue]?.isNotEmpty ?? false) {
                    _selectedSubject = _subjects[newValue]![0];
                    
                    // Reset chapter as well
                    List<String> newChapters = _chaptersData[newValue]?[_selectedSubject] ?? [];
                    if (newChapters.isNotEmpty) {
                      _selectedChapter = newChapters[0];
                    }
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
                  
                  // Reset chapter when subject changes
                  List<String> newChapters = _chaptersData[_selectedClass]?[newValue] ?? [];
                  if (newChapters.isNotEmpty) {
                    _selectedChapter = newChapters[0];
                  }
                });
              }
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Chapter',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.menu_book),
            ),
            value: chapters.contains(_selectedChapter) ? _selectedChapter : (chapters.isNotEmpty ? chapters[0] : null),
            items: chapters.map((String chapter) {
              return DropdownMenuItem<String>(
                value: chapter,
                child: Text(chapter),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedChapter = newValue;
                });
              }
            },
          ),
          SizedBox(height: 24),
          Text(
            'Number of Questions: $_questionCount',
            style: TextStyle(fontSize: 16),
          ),
          Slider(
            value: _questionCount.toDouble(),
            min: 5,
            max: 30,
            divisions: 5,
            label: _questionCount.toString(),
            onChanged: (double value) {
              setState(() {
                _questionCount = value.toInt();
              });
            },
          ),
          SizedBox(height: 16),
          Text(
            'Question Types:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _questionTypes.map((type) {
              return FilterChip(
                label: Text(type),
                selected: _selectedTypes[type] ?? false,
                onSelected: (bool selected) {
                  setState(() {
                    _selectedTypes[type] = selected;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Difficulty Level',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.trending_up),
            ),
            value: _difficultyLevel,
            items: ['Easy', 'Medium', 'Hard'].map((String level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(level),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _difficultyLevel = newValue;
                });
              }
            },
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isGenerating ? null : _generateQuestions,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: _isGenerating
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Generate Questions',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildGeneratedQuestionsList() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generated Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$_selectedClass - $_selectedSubject - $_selectedChapter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _generateQuestions,
                tooltip: 'Regenerate',
              ),
              IconButton(
                icon: Icon(Icons.download),
                onPressed: _generatePdf,
                tooltip: 'Download PDF',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _generatedQuestions?.length ?? 0,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final question = _generatedQuestions![index];
              final questionNumber = index + 1;
              
              return Card(
                margin: EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    'Q$questionNumber. ${question['question']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(question['type']),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (question['type'] == 'MCQ') ...[
                            Text(
                              'Options:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...((question['options'] as List<String>).map((option) {
                              final isAnswer = option == question['answer'];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      isAnswer ? Icons.check_circle : Icons.circle_outlined,
                                      color: isAnswer ? Colors.green : null,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(option),
                                  ],
                                ),
                              );
                            }).toList()),
                          ] else ...[
                            Text(
                              'Expected Answer:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(question['answer']),
                          ],
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: Icon(Icons.edit),
                                label: Text('Edit'),
                                onPressed: () {
                                  // This would open an edit dialog in a real app
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Edit functionality coming soon')),
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _generatedQuestions = null;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Back to Generator'),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _generatePdf,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Export PDF'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
