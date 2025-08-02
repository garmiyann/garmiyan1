import 'package:flutter/material.dart';

class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({Key? key}) : super(key: key);

  @override
  _LifestyleScreenState createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Lifestyle',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$value coming soon!')),
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Create Post', child: Text('Create Post')),
              const PopupMenuItem(value: 'Settings', child: Text('Settings')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Health'),
            Tab(text: 'Fashion'),
            Tab(text: 'Food'),
            Tab(text: 'Travel'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildForYouTab(),
          _buildCategoryTab('Health', Icons.favorite, Colors.red),
          _buildCategoryTab('Fashion', Icons.style, Colors.purple),
          _buildCategoryTab('Food', Icons.restaurant, Colors.orange),
          _buildCategoryTab('Travel', Icons.flight, Colors.blue),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildForYouTab() {
    final posts = [
      {
        'title': '10 Morning Habits for a Productive Day',
        'author': 'WellnessGuru',
        'image': 'https://via.placeholder.com/400x250/42a5f5/ffffff?text=Morning+Habits',
        'category': 'Health',
        'likes': '1.2K',
        'comments': '89',
      },
      {
        'title': 'Summer Fashion Trends 2024',
        'author': 'StyleIcon',
        'image': 'https://via.placeholder.com/400x250/e91e63/ffffff?text=Fashion+Trends',
        'category': 'Fashion',
        'likes': '2.8K',
        'comments': '156',
      },
      {
        'title': 'Easy 15-Minute Healthy Recipes',
        'author': 'QuickChef',
        'image': 'https://via.placeholder.com/400x250/ff9800/ffffff?text=Healthy+Recipes',
        'category': 'Food',
        'likes': '3.1K',
        'comments': '203',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildCategoryTab(String category, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discover amazing $category content',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No $category posts yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to share something amazing!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(Map<String, String> post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              post['image']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post['category']!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Text(
                        post['author']![0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      post['author']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.favorite_outline, size: 16, color: Colors.red),
                        const SizedBox(width: 4),
                        Text(post['likes']!, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 16),
                        const Icon(Icons.comment_outlined, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(post['comments']!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Lifestyle Post'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Post title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Share your lifestyle tip...',
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
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post creation feature coming soon!'),
                ),
              );
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
