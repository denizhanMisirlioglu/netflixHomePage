import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:netflix_ui/repository/tmdb_service.dart';
import 'package:netflix_ui/utils/colors.dart';
import 'package:netflix_ui/widgets/category_row.dart';
import 'package:netflix_ui/widgets/my_chip.dart';
import '../../data/content_data.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final TMDbService tmdbRepository = TMDbService();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  bool _showSecondAppBar = false;

  Map<String, List<String>> categoryPosters = {};

  @override
  void initState() {
    super.initState();
    fetchCategoryPosters();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _showSecondAppBar = true;
        });
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _showSecondAppBar = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchCategoryPosters() async {
    for (var category in categories) {
      List<String> posters = [];
      for (var item in category['items']) {
        String? posterUrl;
        if (item['type'] == 'movie') {
          posterUrl = await tmdbRepository.fetchPosterByTitle(item['title']);
        } else if (item['type'] == 'tv') {
          posterUrl = await tmdbRepository.fetchTvShowPoster(item['title']);
        }
        if (posterUrl != null) {
          posters.add(posterUrl);
        }
      }
      setState(() {
        categoryPosters[category['name']] = posters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.background.withOpacity(0.7),
                pinned: true,
                toolbarHeight: 70,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      height: 80,
                    ),
                    Row(
                      children: [
                        Icon(Icons.file_download_outlined, color: AppColors.primary, size: 22),
                        SizedBox(width: 12),
                        Icon(Icons.search_outlined, color: AppColors.primary, size: 22),
                      ],
                    ),
                  ],
                ),


              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final category = categories[index];
                    final posters = categoryPosters[category['name']] ?? [];
                    return CategoryRow(category: category['name'], posters: posters);
                  },
                  childCount: categories.length,
                ),
              ),
            ],
          ),
          // Sabit ikinci AppBar
          Positioned(
            top: 85, // İlk AppBar'ın hemen altında
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _showSecondAppBar ? 1.0 : 0.0,
              child: Container(
                height: 35,
                padding: EdgeInsets.only(left: 16.0), // Logo ile aynı hizaya getirme
                color: AppColors.background.withOpacity(0.2), // Daha hafif şeffaflık
                child: Align(
                  alignment: Alignment.centerLeft, // Sola hizalama
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyChip(label: "TV Shows"),
                      MyChip(label: "Movies"),
                      MyChip(label: "Categories", hasDropdown: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.bottomNavBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_outlined),
            label: 'New & Hot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'My Netflix',
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    );
  }


}
