import 'dart:async';
import 'dart:io';

import 'package:file_cache_provider/file_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';

import '../image_cache.dart';


class ImageCache extends StatelessWidget{

  /// Image url
  final String imageUrl;

  /// Image width function
  final double? Function(BuildContext context) width;

  /// Image heigth funtion
  final double? Function(BuildContext context) height;

  // AssetImage to show when an error happens getting image url.
  final AssetImage errorLoadingImage;

  /// AssetImage to show while the widget loads the image from url
  final AssetImage ?loadingImage;

  /// To indicate if the widget should fit the image height
  final bool fitHeight;

  /// Indicate if the context of the widget is dark or not
  final bool contextHasDarkBackground;

  /// Builds the object.
  const ImageCache(
      {  super.key,
        required this.imageUrl,
        required this.width,
        required this.height,
        this.errorLoadingImage = const AssetImage('assets/images/error.png'),
        this.loadingImage,
        this.fitHeight=true,
        this.contextHasDarkBackground=false
      });


  @override
  Widget build(BuildContext context) {
     return FutureBuilder<ImageCacheInfo>(
        future: _getImageCacheInfo(imageUrl),
        builder: (BuildContext context, AsyncSnapshot<ImageCacheInfo> snapshot) {
          Widget result ;
          if (snapshot.hasData) {
            result = _buildImageFromImageCacheInfo( context, snapshot.data);
          } else if (snapshot.hasError) {
            result = _buildErrorLoadingImage(context);
          } else {
            result = _buildLoading(context);
          }
          return result;
        },
      );
  }

  Future<String> _getImagePath(String url) async{
    String appPath = (await getApplicationDocumentsDirectory()).path;
    FileCache fileCache =  FileCache(cacheFolder: "$appPath/imagecache");
    return fileCache.getImagePath(url);
  }

  Widget _buildErrorLoadingImage(BuildContext context) {
    return Container(
      width: width(context),
      height: height(context),
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: errorLoadingImage,
        ),
      ),
    );
  }


  Widget _buildLoading(BuildContext context) {
    if(loadingImage!=null){
      return Container(
        width: width(context),
        height: height(context),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: loadingImage??errorLoadingImage,
          ),
        ),
      );
    }

    return SizedBox(
      width: width(context),
      height: height(context),
      child:Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: Visibility(
              visible: true,
              child: Align(
                alignment: Alignment.center,
                child:
                LoadingAnimationWidget.hexagonDots(
                  color: contextHasDarkBackground ? Colors.white : Colors.black,
                  size: 32,
                ),
              )
          ),
        ),
      ),
    );
  }

  Future<ImageCacheInfo> _getImageCacheInfo(String url) async{
    Completer<ImageCacheInfo> completer = Completer();
    try{
      String imagePath = await _getImagePath(url);
      Image image = Image.file(File(imagePath));
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(ImageCacheInfo(size, imagePath));
          },
        ),
      );

    }on Exception catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Widget _buildImageFromImageCacheInfo(BuildContext context, ImageCacheInfo? data) {
    double imageWith = data?.size.width??0;
    double imageHeight = data?.size.height??0;
    String imagePath = data?.imagePath??"";

    if(imageHeight>0 && imagePath!=""){
      double parentWidth = width(context)??0;
      double widhtPercentage = 100*parentWidth/imageWith;
      double finalHeight = widhtPercentage*imageHeight/100;
      if(!fitHeight){
        finalHeight = widhtPercentage*imageHeight/100;
      }else{
        finalHeight = height(context)??0;
      }

      return Container(
        width: parentWidth,
        height: finalHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image:  Image.file(File(imagePath),
            ).image,
          ),
        ),
      );
    }else{
      return _buildErrorLoadingImage(context);
    }
  }

}

