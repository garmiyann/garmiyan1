import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({Key? key}) : super(key: key);

  @override
  _AIAssistantScreenState createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final List<AITool> _aiTools = [
    AITool(
      title: 'Text Generator',
      description: 'Generate creative text, stories, and content',
      icon: Icons.text_fields,
      color: Colors.blue,
      category: 'Content Creation',
    ),
    AITool(
      title: 'Image Analyzer',
      description: 'Analyze and describe images with AI',
      icon: Icons.image_search,
      color: Colors.green,
      category: 'Image Processing',
    ),
    AITool(
      title: 'Language Translator',
      description: 'Translate text between multiple languages',
      icon: Icons.translate,
      color: Colors.orange,
      category: 'Language',
    ),
    AITool(
      title: 'Code Assistant',
      description: 'Get help with programming and code review',
      icon: Icons.code,
      color: Colors.purple,
      category: 'Development',
    ),
    AITool(
      title: 'Smart Summarizer',
      description: 'Summarize long texts and documents',
      icon: Icons.summarize,
      color: Colors.teal,
      category: 'Productivity',
    ),
    AITool(
      title: 'Q&A Assistant',
      description: 'Ask questions and get intelligent answers',
      icon: Icons.quiz,
      color: Colors.red,
      category: 'Knowledge',
    ),
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Content Creation',
    'Image Processing',
    'Language',
    'Development',
    'Productivity',
    'Knowledge',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTools = _selectedCategory == 'All'
        ? _aiTools
        : _aiTools.where((tool) => tool.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Assistant',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 20),
                Text(
                  'AI Tools (${filteredTools.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ...filteredTools.map((tool) => _buildToolCard(tool)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to AI Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Explore powerful AI tools to boost your productivity',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(AITool tool) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: tool.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tool.icon,
              color: tool.color,
              size: 24,
            ),
          ),
          title: Text(
            tool.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                tool.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tool.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tool.category,
                  style: TextStyle(
                    color: tool.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _openTool(tool),
        ),
      ),
    );
  }

  void _openTool(AITool tool) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${tool.title}...'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to specific tool screen
    // Navigator.push(context, MaterialPageRoute(builder: (_) => ToolScreen(tool)));
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Assistant Help'),
        content: const Text(
          'AI Assistant provides various tools to help with different tasks:\n\n'
          '• Use category filters to find specific tools\n'
          '• Tap on any tool to access its features\n'
          '• Each tool is designed for specific use cases\n'
          '• All AI features are powered by advanced algorithms\n'
          '• More tools are being added regularly',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class AITool {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;

  AITool({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
  });
}
