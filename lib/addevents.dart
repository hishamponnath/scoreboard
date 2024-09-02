import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  List<String> _imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Events",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No images found.'));
          }

          final imageDocs = snapshot.data!.docs;
          _imageUrls =
              imageDocs.map((doc) => doc['imageUrl'] as String).toList();

          return ListView.builder(
            itemCount: _imageUrls.length,
            itemBuilder: (context, index) {
              final imageDoc = imageDocs[index];
              final imageUrl = _imageUrls[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<Size>(
                  future: _getImageSize(imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return Container(
                        color: Colors.grey[300],
                        height: 300,
                        child: const Center(child: Text('Error loading image')),
                      );
                    }

                    final size = snapshot.data!;
                    final double aspectRatio = size.width / size.height;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: aspectRatio,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _replaceImage(imageDoc.id, imageUrl),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'Edit Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    _deleteImage(imageDoc.id, imageUrl),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Delete Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.blue[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final Image image = Image.network(imageUrl);
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      String fileName =
          'event_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(fileName).putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('events').add({
          'imageUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          _imageUrls.add(downloadUrl);
        });
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _replaceImage(String docId, String oldImageUrl) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      String fileName =
          'event_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        UploadTask uploadTask =
            FirebaseStorage.instance.ref().child(fileName).putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String newDownloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('events')
            .doc(docId)
            .update({'imageUrl': newDownloadUrl});

        await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();

        setState(() {
          _imageUrls[_imageUrls.indexOf(oldImageUrl)] = newDownloadUrl;
        });
      } catch (e) {
        print("Error replacing image: $e");
      }
    }
  }

  Future<void> _deleteImage(String docId, String imageUrl) async {
    try {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      await FirebaseFirestore.instance.collection('events').doc(docId).delete();

      setState(() {
        _imageUrls.remove(imageUrl);
      });
    } catch (e) {
      print("Error deleting image: $e");
    }
  }
}
