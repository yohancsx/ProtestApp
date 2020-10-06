import 'package:flutter/material.dart';
import 'package:protest_app/common/app_session.dart';
import 'package:protest_app/common/media_file.dart';
import 'package:protest_app/common/widgets/selectors/checkmark_selector.dart';

///a page that will allow the selection of media/images and submission of those
/// requires the session to select media from
class MediaPickerPage extends StatelessWidget {
  MediaPickerPage({@required this.session, @required this.onSubmitFiles});

  ///The application session
  final AppSession session;

  ///list of selected files to add to
  final List<MediaFile> selectedFiles = [];

  ///The function to call when all files are selected
  final Function(List<MediaFile>) onSubmitFiles;

  @override
  Widget build(BuildContext context) {
    //creates the list of media selectable widgets
    List<Widget> mediaSelectableWidgets = [];

    //create all the widgets and add them to the list
    session.mediaFiles.forEach((mediaFile) {
      mediaSelectableWidgets.add(
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Image.network(mediaFile.fileDownloadURL),
              CheckmarkSelector(
                onChanged: (value) {
                  if (value) {
                    selectedFiles.add(mediaFile);
                  } else {
                    selectedFiles.remove(mediaFile);
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
    //finally add the submit button
    mediaSelectableWidgets.add(
      Container(
        alignment: Alignment.center,
        child: Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: FlatButton.icon(
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
              onSubmitFiles(selectedFiles);
            },
            icon: Icon(
              Icons.upload_file,
              size: 100.0,
              color: Colors.white,
            ),
            label: Text(
              "Upload Cache",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.white, fontSize: 50.0),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 55.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: mediaSelectableWidgets,
        ),
      ),
    );
  }
}
