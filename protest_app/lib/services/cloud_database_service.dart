import 'package:firebase_storage/firebase_storage.dart';
import 'package:protest_app/common/app_session.dart';

import 'package:protest_app/common/media_file.dart';

///A class to read and write files from the google cloud firestore
class CloudDatabaseService {
  ///General storage reference
  final StorageReference storageReference = FirebaseStorage.instance.ref();

  ///store an image in the database, with a specified id
  Future<bool> storeImage(MediaFile imageMedia, AppSession session) async {
    //where we are storing the image file
    String imageID = imageMedia.mediaId;
    StorageReference storageReferenceImg =
        storageReference.child("user_image_data/$imageID");
    StorageUploadTask uploadTask;

    //set the time added
    imageMedia.creationTime = DateTime.now();
    //set the original device for the file
    imageMedia.originalDevice = session.deviceID;

    //upload the image
    try {
      uploadTask = storageReferenceImg.putFile(imageMedia.mediaFile);
      await uploadTask.onComplete;
    } catch (error) {
      print(error.toString());
      return false;
    }
    print("upload complete");

    //get the file URL to share the image and such
    dynamic fileUrl;
    try {
      fileUrl = await storageReferenceImg.getDownloadURL();
    } catch (error) {
      print(error.toString());
      return false;
    }
    print("file url: " + fileUrl.toString());

    //set the file url
    imageMedia.fileDownloadURL = fileUrl;

    return true;
  }
}
