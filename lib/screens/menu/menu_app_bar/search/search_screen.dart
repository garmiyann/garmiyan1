import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'People', 'Posts', 'Videos', 'Groups'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) {
              // Handle search query
            },
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Filters
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _filters.map((filter) {
                bool isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.grey[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Search Results
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSectionHeader('Recent Searches'),
        _buildRecentSearchItem('John Doe'),
        _buildRecentSearchItem('Flutter Tutorial'),
        _buildRecentSearchItem('Best Restaurants'),
        const SizedBox(height: 24),
        _buildSectionHeader('Trending'),
        _buildTrendingItem('#FlutterDev', '15.2K posts'),
        _buildTrendingItem('#TechNews', '8.7K posts'),
        _buildTrendingItem('#DesignTips', '5.1K posts'),
        const SizedBox(height: 24),
        _buildSectionHeader('Suggested People'),
        _buildSuggestedPerson('Alice Johnson', '@alice_j', true),
        _buildSuggestedPerson('Mike Chen', '@mike_c', false),
        _buildSuggestedPerson('Sarah Wilson', '@sarah_w', true),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String query) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(
        query,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, color: Colors.grey),
        onPressed: () {
          // Remove from recent searches
        },
      ),
      onTap: () {
        _searchController.text = query;
        // Perform search
      },
    );
  }

  Widget _buildTrendingItem(String hashtag, String count) {
    return ListTile(
      leading: const Icon(Icons.trending_up, color: Colors.deepPurple),
      title: Text(
        hashtag,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        count,
        style: TextStyle(color: Colors.grey[400]),
      ),
      onTap: () {
        // Search for trending topic
      },
    );
  }

  Widget _buildSuggestedPerson(String name, String username, bool isFollowing) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepPurple,
        child: Text(
          name[0],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        name,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        username,
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          // Handle follow/unfollow
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isFollowing ? Colors.grey : Colors.deepPurple,
          side: BorderSide(
            color: isFollowing ? Colors.grey : Colors.deepPurple,
          ),
        ),
        child: Text(isFollowing ? 'Following' : 'Follow'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
