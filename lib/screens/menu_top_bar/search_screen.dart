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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
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
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : (isDark ? Colors.grey[800] : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String query) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        Icons.history,
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      title: Text(
        query,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.close,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
      title: Text(
        hashtag,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        count,
        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      ),
      onTap: () {
        // Search for trending topic
      },
    );
  }

  Widget _buildSuggestedPerson(String name, String username, bool isFollowing) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          name[0],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        username,
        style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
      ),
      trailing: OutlinedButton(
        onPressed: () {
          // Handle follow/unfollow
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isFollowing
              ? (isDark ? Colors.grey[400] : Colors.grey[600])
              : Theme.of(context).primaryColor,
          side: BorderSide(
            color: isFollowing
                ? (isDark ? Colors.grey[400]! : Colors.grey[600]!)
                : Theme.of(context).primaryColor,
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
