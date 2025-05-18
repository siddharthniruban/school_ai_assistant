import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_ai_assistant/providers/app_state.dart';
import 'package:school_ai_assistant/screens/syllabus_screen.dart';
import 'package:school_ai_assistant/screens/question_generator_screen.dart';
import 'package:school_ai_assistant/screens/upload_screen.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRole = Provider.of<AppState>(context).userRole;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, $userRole',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'What would you like to do today?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildDashboardCard(
                context,
                'View Syllabus',
                Icons.menu_book,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SyllabusScreen()),
                  );
                },
              ),
              _buildDashboardCard(
                context,
                'Generate Questions',
                Icons.question_answer,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuestionGeneratorScreen()),
                  );
                },
              ),
              if (userRole == 'Admin' || userRole == 'Teacher')
                _buildDashboardCard(
                  context,
                  'Upload Materials',
                  Icons.upload_file,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadScreen()),
                    );
                  },
                ),
              _buildDashboardCard(
                context,
                'Question Bank',
                Icons.library_books,
                Colors.purple,
                () {
                  // This would navigate to a question bank in a real app
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Question Bank - Coming Soon!')),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          // Dummy recent activity list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final activities = [
                {
                  'title': 'Science Class 8 Question Paper',
                  'subtitle': 'Generated on May 15, 2025',
                  'icon': Icons.assignment,
                },
                {
                  'title': 'Mathematics Syllabus Updated',
                  'subtitle': 'Updated on May 10, 2025',
                  'icon': Icons.update,
                },
                {
                  'title': 'New Study Material Uploaded',
                  'subtitle': 'Uploaded on May 5, 2025',
                  'icon': Icons.upload_file,
                },
              ];
              
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Icon(
                      activities[index]['icon'] as IconData,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(activities[index]['title'] as String),
                  subtitle: Text(activities[index]['subtitle'] as String),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    // This would navigate to the specific activity in a real app
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
