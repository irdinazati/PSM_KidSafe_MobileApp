import 'dart:io';
import '../constants/constants.dart';

class StorageService {

  // static Future<String> uploadParentProfilePicture(File imageFile) async {
  //   String uniquePhotoId = Uuid().v4();
  //   File image = await compressImage(uniquePhotoId, imageFile);
  //
  //   UploadTask uploadTask = storageRef
  //       .child('images/parentProfiles/parentProfile_$uniquePhotoId.jpg')
  //       .putFile(image);
  //   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  //   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  // static Future<File> compressImage(String photoId, File image) async {
  //   try {
  //     final tempDirectory = await getTemporaryDirectory();
  //     final path = tempDirectory.path;
  //     File compressedImage = (await FlutterImageCompress.compressAndGetFile(
  //       image.absolute.path,
  //       '$path/img_$photoId.jpg',
  //       quality: 70,
  //     )) as File;
  //     return compressedImage;
  //   } catch (e) {
  //     print('Compression error: $e');
  //     return image; // Return the original image or handle the error as needed
  //   }
  // }

}