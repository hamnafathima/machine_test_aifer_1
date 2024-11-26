import 'package:flutter/material.dart';
import 'package:machine_test/models/photo_model.dart';
import 'package:machine_test/providers/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch photos as soon as the screen loads
    Provider.of<PhotoProvider>(context, listen: false).fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    final photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Photo Gallery",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
      body: _buildBody(photoProvider),
    );
  }

  Widget _buildBody(PhotoProvider photoProvider) {
    if (photoProvider.photos.isEmpty && photoProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (photoProvider.photos.isEmpty) {
      return Center(
        child: Text(
          "No photos available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
         
          if (scrollNotification is ScrollEndNotification &&
              scrollNotification.metrics.extentAfter == 0) {
            photoProvider.fetchPhotos();
          }
          return false;
        },
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: photoProvider.photos.length,
          itemBuilder: (ctx, index) {
            final photo = photoProvider.photos[index];
            return _buildPhotoCard(photo);
          },
        ),
      ),
    );
  }

  Widget _buildPhotoCard(Welcome photo) {
    return GestureDetector(
      onTap: () => _downloadPhoto(photo.urls.full),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              photo.urls.thumb,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                photo.user.name,
                style: TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadPhoto(String url) async {
  try {
    final dio = Dio();

    
    final directory = await getExternalStorageDirectory(); 
    final filePath =
        '${directory?.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Download image
    await dio.download(url, filePath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image saved to $filePath')),
    );
  } catch (e) {
    print("Download error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to download image: $e')),
    );
  }
}
}