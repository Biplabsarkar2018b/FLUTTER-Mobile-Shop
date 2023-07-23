import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final String imageUrl;
  final String marketingName;
  final String deviceCondition;
  final String deviceStorage;
  final String listingLocation;
  final String listingDate;
  final int listingNumPrice;

  DataCard({
    required this.imageUrl,
    required this.marketingName,
    required this.deviceCondition,
    required this.deviceStorage,
    required this.listingNumPrice,
    required this.listingLocation,
    required this.listingDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 100, // Adjust the height of the image as per your requirement
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context,error,st){
                 return Image.asset(
                  'assets/images/second.jpg', // Provide the path of your static image asset
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              '₹ $listingNumPrice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Text(
              marketingName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Text(
              deviceStorage,
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Text(
              'Condition: $deviceCondition',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  listingLocation,
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  listingDate,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
