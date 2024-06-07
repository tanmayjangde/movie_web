import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '© 2024 MovieWeb. All rights reserved.',
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook, color: Colors.grey[400]),
                onPressed: () {
                  // Add your Facebook link here
                },
              ),
              IconButton(
                icon: Icon(Icons.link, color: Colors.grey[400]),
                onPressed: () {
                  // Add your Twitter link here
                },
                tooltip: 'Twitter',
              ),
              IconButton(
                icon: Icon(Icons.image, color: Colors.grey[400]),
                onPressed: () {
                  // Add your Instagram link here
                },
                tooltip: 'Instagram',
              ),
              IconButton(
                icon: Icon(Icons.video_library, color: Colors.grey[400]),
                onPressed: () {
                  // Add your YouTube link here
                },
                tooltip: 'YouTube',
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Wrap(
            spacing: 16.0,
            children: [
              TextButton(
                onPressed: () {
                  // Navigate to About Us page
                },
                child: Text(
                  'About Us',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Privacy Policy page
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Terms of Service page
                },
                child: Text(
                  'Terms of Service',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              // Add more footer links as needed
            ],
          ),
        ],
      ),
    );
  }
}
