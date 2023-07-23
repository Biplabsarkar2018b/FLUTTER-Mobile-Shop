import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String searchQuery;
  const SearchScreen({required this.searchQuery});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for ${widget.searchQuery}'),
      ),
      body: Center(
        child: Text('Search Results for: ${widget.searchQuery}'),
      ),
    );
  }
}
