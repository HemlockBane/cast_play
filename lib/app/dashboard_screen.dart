import 'package:flutter/material.dart';
import 'package:podplay_flutter/app/features/search/ui/view/podcast_search_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _selectedIndex = ValueNotifier(0);
  final pages = [const PodcastSearchView(), Container()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (ctx, value, _) => pages[value],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onBottomItemTapped,
      ),
    );
  }

  void _onBottomItemTapped(int value) {
    _selectedIndex.value = value;
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final ValueNotifier<int> selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (ctx, value, _) {
          return BottomNavigationBar(
            currentIndex: value,
            selectedItemColor: Colors.amber[800],
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                label: 'Discover',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.headphones_sharp),
                label: 'Library',
              ),
            ],
          );
        },
    );
  }
}
