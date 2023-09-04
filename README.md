
This package provides a widget to show images from an url and them get it from your local storage.
It uses image_cache package

## Features

ImageCache downloads the image and saves it into your local path, then shows it.

## Getting started

It's very simple to use, you only have to define the cache folder name where you want to save
the downloaded files.

## Usage

You have to create the widget with imageUrl, width & height:

```dart
ImageCache imgCache = ImageCache(imageUrl: "https://example.com/image.png",
                width: (BuildContext context){
                  return 150;
                },
                height: (BuildContext context){
                  return 150;
                }
            );
```

## How it works
The widget stores and retrieves files using the [file_cache_provider](https://pub.dev/packages/file_cache_provider).

## Additional information

