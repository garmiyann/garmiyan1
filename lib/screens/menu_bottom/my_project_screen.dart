import 'package:flutter/material.dart';

class MyProjectScreen extends StatefulWidget {
  const MyProjectScreen({Key? key}) : super(key: key);

  @override
  _MyProjectScreenState createState() => _MyProjectScreenState();
}

class _MyProjectScreenState extends State<MyProjectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _draftProjects = [
    {
      'title': 'Summer Vacation Vlog',
      'type': 'Video',
      'lastModified': '2 hours ago',
      'thumbnail': 'https://picsum.photos/200/300?random=1',
      'duration': '2:45',
      'status': 'Draft',
    },
    {
      'title': 'Cooking Tutorial',
      'type': 'Video',
      'lastModified': '1 day ago',
      'thumbnail': 'https://picsum.photos/200/300?random=2',
      'duration': '5:30',
      'status': 'In Progress',
    },
    {
      'title': 'Dance Challenge',
      'type': 'Video',
      'lastModified': '3 days ago',
      'thumbnail': 'https://picsum.photos/200/300?random=3',
      'duration': '0:15',
      'status': 'Draft',
    },
  ];

  final List<Map<String, dynamic>> _publishedProjects = [
    {
      'title': 'Morning Routine',
      'type': 'Video',
      'publishedDate': '1 week ago',
      'thumbnail': 'https://picsum.photos/200/300?random=4',
      'views': '12.5K',
      'likes': '1.2K',
      'status': 'Published',
    },
    {
      'title': 'Study Tips',
      'type': 'Video',
      'publishedDate': '2 weeks ago',
      'thumbnail': 'https://picsum.photos/200/300?random=5',
      'views': '8.7K',
      'likes': '856',
      'status': 'Published',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Projects',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createNewProject(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchProjects(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Drafts'),
            Tab(text: 'Published'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Drafts tab
          _buildProjectList(_draftProjects, isDraft: true),
          // Published tab
          _buildProjectList(_publishedProjects, isDraft: false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewProject(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProjectList(List<Map<String, dynamic>> projects,
      {required bool isDraft}) {
    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDraft ? Icons.drafts : Icons.publish,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isDraft ? 'No drafts yet' : 'No published projects',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDraft
                  ? 'Start creating your first project'
                  : 'Publish your first project to see it here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _createNewProject(),
              icon: const Icon(Icons.add),
              label: const Text('Create New Project'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return _buildProjectCard(project, isDraft: isDraft);
      },
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project,
      {required bool isDraft}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => _openProject(project),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(project['thumbnail'] as String),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    if (isDraft && project.containsKey('duration'))
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            project['duration'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Project info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(project['status'] as String)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            project['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color:
                                  _getStatusColor(project['status'] as String),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _getTypeIcon(project['type'] as String),
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          project['type'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isDraft)
                      Text(
                        'Last modified: ${project['lastModified']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      )
                    else ...[
                      Text(
                        'Published: ${project['publishedDate']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.visibility,
                              size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            project['views'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.favorite,
                              size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            project['likes'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // More options
              IconButton(
                onPressed: () => _showProjectOptions(project, isDraft: isDraft),
                icon: const Icon(Icons.more_vert),
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Draft':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Published':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Video':
        return Icons.videocam;
      case 'Photo':
        return Icons.photo;
      case 'Audio':
        return Icons.audiotrack;
      default:
        return Icons.file_present;
    }
  }

  void _createNewProject() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create New Project',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.red),
              title: const Text('Video Project'),
              subtitle: const Text('Create a new video'),
              onTap: () {
                Navigator.pop(context);
                _createVideoProject();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo, color: Colors.blue),
              title: const Text('Photo Project'),
              subtitle: const Text('Create a photo carousel'),
              onTap: () {
                Navigator.pop(context);
                _createPhotoProject();
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack, color: Colors.green),
              title: const Text('Audio Project'),
              subtitle: const Text('Create an audio post'),
              onTap: () {
                Navigator.pop(context);
                _createAudioProject();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createVideoProject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video project creation coming soon!')),
    );
  }

  void _createPhotoProject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo project creation coming soon!')),
    );
  }

  void _createAudioProject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio project creation coming soon!')),
    );
  }

  void _searchProjects() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project search coming soon!')),
    );
  }

  void _openProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${project['title']}...')),
    );
  }

  void _showProjectOptions(Map<String, dynamic> project,
      {required bool isDraft}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project['title'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (isDraft) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _openProject(project);
                },
              ),
              ListTile(
                leading: const Icon(Icons.publish),
                title: const Text('Publish'),
                onTap: () {
                  Navigator.pop(context);
                  _publishProject(project);
                },
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('View Analytics'),
                onTap: () {
                  Navigator.pop(context);
                  _viewAnalytics(project);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  _shareProject(project);
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteProject(project);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _publishProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Publishing ${project['title']}...')),
    );
  }

  void _viewAnalytics(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing analytics for ${project['title']}')),
    );
  }

  void _shareProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing ${project['title']}...')),
    );
  }

  void _deleteProject(Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${project['title']} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
