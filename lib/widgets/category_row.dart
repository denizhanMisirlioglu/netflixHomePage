import 'package:flutter/material.dart';
import 'package:netflix_ui/utils/colors.dart';

class CategoryRow extends StatelessWidget {
  final String category;
  final List<String> posters;

  const CategoryRow({
    Key? key,
    required this.category,
    required this.posters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (category == 'My List') // Sadece "My List" için gösterilecek
                GestureDetector(
                  onTap: () {
                    // "See All >" tıklandığında çalışacak işlev
                    print("See All tapped");
                  },
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 2), // Metin ile ikon arasındaki boşluk
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: posters.length,
            itemBuilder: (context, index) {
              final posterUrl = posters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    posterUrl,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
