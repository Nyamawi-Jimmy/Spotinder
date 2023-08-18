import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:flutter/gestures.dart';
import '../Screens/messenger.dart';
import '../widget/library.dart';

class StoryPageView extends StatefulWidget {
  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final _storyController = StoryController();
  double _initialDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _storyController.play();
  }

  void showLikeNotification() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void showDislikeNotification() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Disliked!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StoryItem> generateStoryItems() {
      List<StoryItem> storyItems = [];

      for (int i = 0; i < characters.length; i++) {
        Character character = characters[i];
        storyItems.add(
          StoryItem.pageProviderImage(
            AssetImage(character.avatar),
          ),
        );
      }

      return storyItems;
    }

    return GestureDetector(
      onVerticalDragStart: (details) {
        _initialDragOffset = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        double currentDragOffset = details.globalPosition.dy;
        double deltaY = currentDragOffset - _initialDragOffset;

        if (deltaY < -50) {
          showLikeNotification();
        } else if (deltaY > 50) {
          showDislikeNotification();
        }
      },
      onVerticalDragEnd: (details) {
        double currentDragOffset = details.velocity.pixelsPerSecond.dy;

        if (currentDragOffset < 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavouritePage(),
            ),
          );
        }
      },
      child: Material(
        child: Stack(
          children: [
            StoryView(
              storyItems: generateStoryItems(),
              controller: _storyController,
              inline: false,
              repeat: true,
            ),
          ],
        ),
      ),
    );
  }
}
