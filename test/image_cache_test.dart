
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cache/image_cache.dart' as image_cache;
import 'package:flutter/material.dart';
import 'base_app.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  const imageUrl = "https://example.com/some_image.jpg";

  testWidgets(
    'Load image url',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() =>
          tester.pumpWidget(
              baseApp(image_cache.ImageCache(
                imageUrl: imageUrl,
                width: (BuildContext context) {
                  return 50;
                },
                height: (BuildContext context) {
                  return 50;
                },
              )
              )
          ));
    },
  );

  testWidgets(
      'Load image url with custom loading image', (WidgetTester tester) async {
    mockNetworkImagesFor(() =>
        tester.pumpWidget(
          baseApp(image_cache.ImageCache(
            imageUrl: imageUrl,
            loadingImage: const AssetImage("assets/images/error.png"),
            width: (BuildContext context) {
              return 50;
            },
            height: (BuildContext context) {
              return 50;
            },
          )
          ),
        ));
  });


  testWidgets('Load image url in dark backgroud', (WidgetTester tester) async {
    mockNetworkImagesFor(() =>
        tester.pumpWidget(
          baseApp(image_cache.ImageCache(
            imageUrl: imageUrl,
            contextHasDarkBackground: true,
            width: (BuildContext context) {
              return 50;
            },
            height: (BuildContext context) {
              return 50;
            },
          )
          ),
        ));
  });

  testWidgets('Load image url using cache', (WidgetTester tester) async {
    mockNetworkImagesFor(() =>
        tester.pumpWidget(
          baseApp(image_cache.ImageCache(
            imageUrl: imageUrl,
            width: (BuildContext context) {
              return 50;
            },
            height: (BuildContext context) {
              return 50;
            },
          )
          ),
        ));
  });
}
