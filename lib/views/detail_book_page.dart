import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({
    Key? key,
    required this.isbn,
  }) : super(key: key);
  final String isbn;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;
  fetchDetailBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
    }

    // print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: detailBook == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageViewScreen(imageUrl: detailBook!.image!),
                          ),
                        );
                      },
                      child: Image.network(
                        detailBook!.image!,
                        height: 100,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detailBook!.title!),
                          Text(detailBook!.subtitle!),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(detailBook!.price!),
                Text(detailBook!.isbn10!),
                Text(detailBook!.isbn13!),
                Text(detailBook!.pages!),
                Text(detailBook!.authors!),
                Text(detailBook!.publisher!),
                Text(detailBook!.desc!),
                Text(detailBook!.rating!),
              ],
            ),
    );
  }
}
