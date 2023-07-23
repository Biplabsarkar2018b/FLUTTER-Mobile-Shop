import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobiles/screens/search_screen.dart';

import '../api/data_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchText = TextEditingController();
  late PageController _pageController;
  double _currentPage = 0;
  List<Map<String, dynamic>> data = [];
  ScrollController _scrollController = ScrollController();

  int _dataPage = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _pageController.page = 0;
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
    // Attach the scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        fetchNextPage(); // Fetch the next page when reaching the end
      }
    });
    // fetching initial data
    fetchData();
  }

  void fetchData() async {
    var uri = Uri.parse(
        'https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=1&limit=10');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);
      if (parsedData['listings'] != null) {
        setState(() {
          data = List<Map<String, dynamic>>.from(parsedData['listings']);
        });
      }
    }
  }

  void fetchNextPage() async {
    print('Next Page is being fetched');
    var uri = Uri.parse(
        'https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=$_dataPage&limit=10');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final parsedData = jsonDecode(response.body);
      if (parsedData['listings'] != null) {
        setState(() {
          data.addAll(List<Map<String, dynamic>>.from(parsedData['listings']));
          _dataPage++; // Increment the page number for the next fetch
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _searchText.dispose();
  }

  List<String> brands = [
    'https://1000logos.net/wp-content/uploads/2016/10/Apple-Logo.png',
    'https://static.vecteezy.com/system/resources/previews/014/018/566/original/samsung-logo-on-transparent-background-free-vector.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Xiaomi_logo.svg/1024px-Xiaomi_logo.svg.png',
    'https://m.economictimes.com/thumb/height-450,width-600,imgsize-29606,msid-75741298/vivo-agencies.jpg'
  ];

  List<dynamic> shopBy = [
    {
      'image':
          "https://c8.alamy.com/comp/G620H6/phone-cell-smart-mobile-3d-and-2d-G620H6.jpg",
      'text': "Bestselling Mobiles",
    },
    {
      'image':
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROwRj7YfvtoSFic_ODlmVZXjpk9m8mbhdl-w&usqp=CAU",
      'text': "Verified Devices Only",
    },
    {
      'image':
          "https://media.istockphoto.com/id/1206610306/vector/smartphone-line-drawing-illustration-single-simple-monochrome.jpg?s=612x612&w=0&k=20&c=L7WAF-3z3PtmdSpagzZ9qYbcJZbS3VpkcwqFmofYDj0=",
      'text': "Like New Condition",
    },
    {
      'image': "https://cdn-icons-png.flaticon.com/512/3882/3882857.png",
      'text': "Phones with Warranty",
    },
  ];

  void _onSuffixIconClicked() {
    final searchQuery = _searchText.text.trim();
    // print(_sea);
    // Navigate to the SearchScreen and pass the search query as a parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(searchQuery: searchQuery),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('oru'),
        leading: Icon(Icons.align_horizontal_left_outlined),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.pin_drop)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active))
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Search Box
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(color: Colors.blue),
              child: TextField(
                controller: _searchText,
                decoration: InputDecoration(
                    hintText: 'Search with make and model',
                    contentPadding: EdgeInsets.symmetric(vertical: 7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: _onSuffixIconClicked,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border(
                            top: BorderSide(color: Colors.white, width: 1),
                            right: BorderSide(color: Colors.white, width: 1),
                            bottom: BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, top: 8.0),
                child: Text(
                  'Buy Top Brands',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 23, color: Colors.grey),
                ),
              ),
            ),
            // Horizontal List
            SizedBox(
              height: 80, // Adjust the height as per your requirement
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      brands[index],
                      width: 100, // Adjust the width as per your requirement
                      height: 100, // Adjust the height as per your requirement
                      // fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            // PageView with dots indicator
            Container(
              height: 200,
              width: double.infinity,
              child: PageView.builder(
                controller:
                    _pageController, // Assign the PageController to the PageView
                itemCount: 4, // Number of photos
                itemBuilder: (context, index) {
                  return Image.network(
                    brands[index],
                    // fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Dots Indicator
            DotsIndicator(
              // position:,
              dotsCount: 4, // Number of photos
              position: _currentPage
                  .toInt(), // Starting position of the dots indicator
              decorator: const DotsDecorator(
                // Customize the dots appearance
                activeColor: Colors.blue,
                activeSize: Size(12, 12),
                spacing: EdgeInsets.all(4),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, top: 8.0),
                child: Text(
                  'Shop By',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 23, color: Colors.grey),
                ),
              ),
            ),
            // Horizontal List
            SizedBox(
              height: 150, // Adjust the height as per your requirement
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          shopBy[index]['image'],
                          width:
                              100, // Adjust the width as per your requirement
                          height:
                              100, // Adjust the height as per your requirement
                          // fit: BoxFit.cover,
                        ),
                        Text(shopBy[index]['text'])
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 8.0),
                  child: Text(
                    'Best Deals Near You',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 23, color: Colors.grey),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: const Row(
                    children: [
                      Text('sort'),
                      Icon(Icons.vertical_align_center_outlined)
                    ],
                  ),
                )
              ],
            ),
            ListView.builder(
              // controller: _scrollController,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: (data.length / 2).ceil() +
                  1, // Number of rows with 2 cards each
              itemBuilder: (context, rowIndex) {
                if (rowIndex < (data.length / 2).ceil()) {
                  final startIndex = rowIndex * 2;
                  final dataCard1 = data[startIndex];
                  final dataCard2 = (startIndex + 1) < data.length
                      ? data[startIndex + 1]
                      : null;

                  return Row(
                    children: [
                      Expanded(
                        child: dataCard1 != null
                            ? DataCard(
                                imageUrl: dataCard1['defaultImage']
                                    ['fullImage'],
                                marketingName: dataCard1['marketingName'],
                                deviceCondition: dataCard1['deviceCondition'],
                                deviceStorage: dataCard1['deviceStorage'],
                                listingDate: dataCard1['listingDate'],
                                listingLocation: dataCard1['listingLocation'],
                                listingNumPrice: dataCard1['listingNumPrice'],
                              )
                            : SizedBox(),
                      ),
                      SizedBox(width: 10), // Add spacing between cards
                      Expanded(
                        child: dataCard2 != null
                            ? DataCard(
                                imageUrl: dataCard2['defaultImage']
                                    ['fullImage'],
                                marketingName: dataCard2['marketingName'],
                                deviceCondition: dataCard2['deviceCondition'],
                                deviceStorage: dataCard2['deviceStorage'],
                                listingDate: dataCard2['listingDate'],
                                listingLocation: dataCard2['listingLocation'],
                                listingNumPrice: dataCard2['listingNumPrice'],
                              )
                            : SizedBox(),
                      ),
                    ],
                  );
                } else
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}
