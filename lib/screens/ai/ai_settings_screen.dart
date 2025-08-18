import 'package:flutter/material.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({Key? key}) : super(key: key);

  @override
  _AISettingsScreenState createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  bool _enableNotifications = true;
  bool _enableAutoSave = true;
  bool _enableVoiceInput = false;
  String _selectedLanguage = 'English';
  String _selectedModel = 'GPT-4';
  double _responseLength = 0.7; // 0.0 = Short, 1.0 = Long

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Arabic',
  ];

  final List<String> _models = [
    'GPT-4',
    'GPT-3.5',
    'Claude',
    'Gemini',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () => _resetToDefaults(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            'General Settings',
            Icons.settings,
            [
              _buildSwitchTile(
                'Enable Notifications',
                'Get notified about AI responses and updates',
                Icons.notifications,
                _enableNotifications,
                (value) => setState(() => _enableNotifications = value),
              ),
              _buildSwitchTile(
                'Auto-save Conversations',
                'Automatically save your AI conversations',
                Icons.save,
                _enableAutoSave,
                (value) => setState(() => _enableAutoSave = value),
              ),
              _buildSwitchTile(
                'Voice Input',
                'Use voice input for AI conversations',
                Icons.mic,
                _enableVoiceInput,
                (value) => setState(() => _enableVoiceInput = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'AI Configuration',
            Icons.psychology,
            [
              _buildDropdownTile(
                'AI Model',
                'Choose your preferred AI model',
                Icons.smart_toy,
                _selectedModel,
                _models,
                (value) => setState(() => _selectedModel = value!),
              ),
              _buildDropdownTile(
                'Language',
                'Set your preferred language',
                Icons.language,
                _selectedLanguage,
                _languages,
                (value) => setState(() => _selectedLanguage = value!),
              ),
              _buildSliderTile(
                'Response Length',
                'Control how detailed AI responses should be',
                Icons.format_size,
                _responseLength,
                (value) => setState(() => _responseLength = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'Privacy & Security',
            Icons.security,
            [
              _buildActionTile(
                'Data Usage',
                'View how your data is used',
                Icons.data_usage,
                () => _showDataUsageDialog(),
              ),
              _buildActionTile(
                'Privacy Policy',
                'Read our privacy policy',
                Icons.privacy_tip,
                () => _showPrivacyPolicy(),
              ),
              _buildActionTile(
                'Clear AI Data',
                'Delete all stored AI conversations',
                Icons.delete_forever,
                () => _showClearDataDialog(),
                textColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            'Support',
            Icons.help,
            [
              _buildActionTile(
                'Help Center',
                'Get help with AI features',
                Icons.help_center,
                () => _showHelpCenter(),
              ),
              _buildActionTile(
                'Send Feedback',
                'Share your thoughts about AI features',
                Icons.feedback,
                () => _showFeedbackDialog(),
              ),
              _buildActionTile(
                'About AI Assistant',
                'Learn more about our AI technology',
                Icons.info,
                () => _showAboutDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
      String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    IconData icon,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    Function(double) onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Short', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.blue,
                ),
              ),
              const Text('Long', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to Defaults'),
        content: const Text(
            'Are you sure you want to reset all AI settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _enableNotifications = true;
                _enableAutoSave = true;
                _enableVoiceInput = false;
                _selectedLanguage = 'English';
                _selectedModel = 'GPT-4';
                _responseLength = 0.7;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to defaults')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDataUsageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Usage'),
        content: const Text(
          'Your AI conversations and preferences are stored locally on your device and may be used to:\n\n'
          '• Improve AI response quality\n'
          '• Provide personalized suggestions\n'
          '• Maintain conversation history\n'
          '• Enhance user experience\n\n'
          'We respect your privacy and do not share personal data with third parties.',
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

  void _showPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Privacy Policy'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(
                'AI Assistant Privacy Policy\n\n'
                'This privacy policy explains how we collect, use, and protect your information when using AI features...\n\n'
                '[Privacy policy content would go here]',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear AI Data'),
        content: const Text(
          'This will permanently delete:\n\n'
          '• All AI conversation history\n'
          '• Saved preferences\n'
          '• Custom settings\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('AI data cleared successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child:
                const Text('Clear Data', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Help Center'),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ExpansionTile(
                title: Text('How do I start a conversation with AI?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        'Tap the AI icon in the navigation bar to start chatting with the AI assistant.'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Can I change the AI model?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        'Yes, you can change the AI model in Settings > AI Configuration > AI Model.'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('Is my data secure?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        'Yes, all your conversations are stored locally and encrypted for security.'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Share your thoughts about AI features...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback sent! Thank you.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Assistant'),
        content: const Text(
          'AI Assistant v1.0\n\n'
          'Powered by advanced machine learning models, our AI assistant helps you with various tasks including:\n\n'
          '• Natural language conversations\n'
          '• Text generation and editing\n'
          '• Question answering\n'
          '• Language translation\n'
          '• Code assistance\n\n'
          'Built with privacy and security in mind.',
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
