import 'package:flutter/material.dart';
import 'add_project_screen.dart';

class PlusButtonScreen extends StatefulWidget {
  const PlusButtonScreen({super.key});

  @override
  State<PlusButtonScreen> createState() => _PlusButtonScreenState();
}

class _PlusButtonScreenState extends State<PlusButtonScreen> {
  void _navigateToAddProject() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProjectScreen()),
    );
  }

  List<Map<String, dynamic>> get _actionItems => [
        {
          'title': 'Add Project',
          'icon': Icons.add_box,
          'color': Color(0xFF7D00B8),
          'onTap': _navigateToAddProject,
        },
        {
          'title': 'Create Post',
          'icon': Icons.post_add,
          'color': Color(0xFF00BCD4),
          'onTap': () => print('Create Post tapped'),
        },
        {
          'title': 'Upload Media',
          'icon': Icons.cloud_upload,
          'color': Color(0xFFFF9800),
          'onTap': () => print('Upload Media tapped'),
        },
        {
          'title': 'Start Live',
          'icon': Icons.videocam,
          'color': Color(0xFFE91E63),
          'onTap': () => print('Start Live tapped'),
        },
        {
          'title': 'Add Story',
          'icon': Icons.add_a_photo,
          'color': Color(0xFF4CAF50),
          'onTap': () => print('Add Story tapped'),
        },
        {
          'title': 'Create Event',
          'icon': Icons.event,
          'color': Color(0xFF9C27B0),
          'onTap': () => print('Create Event tapped'),
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Create New',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'What would you like to create?',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: _actionItems.length,
                itemBuilder: (context, index) {
                  final item = _actionItems[index];
                  return GestureDetector(
                    onTap: item['onTap'],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: item['color'].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: 40,
                            color: item['color'],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
