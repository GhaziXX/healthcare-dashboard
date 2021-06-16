import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as dh;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    Key key,
    @required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool _isAttachmentUploading = false;

  void _handleAtachmentPress() {
    showAdaptiveActionSheet<void>(
      context: context,
      actions: [
        BottomSheetAction(
            title: const Text('Open file picker'),
            onPressed: () {
              Navigator.pop(context);
              _showFilePicker();
            },
            leading: Icon(Icons.file_upload)),
        BottomSheetAction(
            title: const Text('Open image picker'),
            onPressed: () {
              Navigator.pop(context);
              _showImagePicker();
            },
            leading: Icon(Icons.image)),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        final client = http.Client();
        final request = await client.get(Uri.parse(message.uri));
        final bytes = request.bodyBytes;
        final documentsDir = (await getApplicationDocumentsDirectory()).path;
        localPath = '$documentsDir/${message.fileName}';

        if (!File(localPath).existsSync()) {
          final file = File(localPath);
          await file.writeAsBytes(bytes);
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.roomId);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.roomId,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  void _showFilePicker() async {
    if (kIsWeb) {
      dh.InputElement uploadInput = dh.FileUploadInputElement();
      uploadInput.click();
      uploadInput.onChange.listen((event) {
        final file = uploadInput.files.first;
        if (file != null) {
          _setAttachmentUploading(true);
          final reader = dh.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) async {
            final fileName = file.relativePath.split('/').last;
            final path = file.relativePath;
            final blob = DateTime.now();
            try {
              final reference = FirebaseStorage.instance.ref(fileName);
              await reference.child("$blob").putBlob(file);
              final uri = await reference.child("$blob").getDownloadURL();
              final message = types.PartialFile(
                fileName: fileName ?? '',
                mimeType: lookupMimeType(path ?? ''),
                size: file.size ?? 0,
                uri: uri,
              );

              FirebaseChatCore.instance.sendMessage(
                message,
                widget.roomId,
              );
              _setAttachmentUploading(false);
            } on FirebaseException catch (e) {
              _setAttachmentUploading(false);
              print("error $e");
            }
          });
        }
      });
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null) {
        _setAttachmentUploading(true);
        final fileName = result.files.single.name;
        final filePath = result.files.single.path;
        final file = File(filePath ?? '');

        try {
          final reference = FirebaseStorage.instance.ref(fileName);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();

          final message = types.PartialFile(
            fileName: fileName ?? '',
            mimeType: lookupMimeType(filePath ?? ''),
            size: result.files.single.size ?? 0,
            uri: uri,
          );

          FirebaseChatCore.instance.sendMessage(
            message,
            widget.roomId,
          );
          _setAttachmentUploading(false);
        } on FirebaseException catch (e) {
          _setAttachmentUploading(false);
          print(e);
        }
      } else {
        // User canceled the picker
      }
    }
  }

  void _showImagePicker() async {
    if (kIsWeb) {
      dh.InputElement uploadInput = dh.FileUploadInputElement()
        ..accept = "image/*";
      uploadInput.click();
      uploadInput.onChange.listen((event) {
        final file = uploadInput.files.first;
        if (file != null) {
          _setAttachmentUploading(true);
          final reader = dh.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) async {
            final imageName = file.relativePath.split('/').last;
            final size = file.size;
            final blob = DateTime.now();
            try {
              final reference = FirebaseStorage.instance.ref(imageName);
              await reference.child("$blob").putBlob(file);
              final uri = await reference.child("$blob").getDownloadURL();
              final message = types.PartialImage(
                imageName: imageName,
                size: size,
                uri: uri,
              );

              FirebaseChatCore.instance.sendMessage(
                message,
                widget.roomId,
              );
              _setAttachmentUploading(false);
            } on FirebaseException catch (e) {
              print("error $e");
            }
          });
        }
      });
    } else {
      final result = await ImagePicker().getImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );

      if (result != null) {
        _setAttachmentUploading(true);
        final file = File(result.path);
        final size = file.lengthSync();
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);
        final imageName = result.path.split('/').last;

        try {
          final reference = FirebaseStorage.instance.ref(imageName);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();

          final message = types.PartialImage(
            height: image.height.toDouble(),
            imageName: imageName,
            size: size,
            uri: uri,
            width: image.width.toDouble(),
          );

          FirebaseChatCore.instance.sendMessage(
            message,
            widget.roomId,
          );
          _setAttachmentUploading(false);
        } on FirebaseException catch (e) {
          _setAttachmentUploading(false);
          print(e);
        }
      } else {
        // User canceled the picker
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Message>>(
      stream: FirebaseChatCore.instance.messages(widget.roomId),
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("snapshot is ${snapshot.error}");
        }
        return Chat(
          isAttachmentUploading: _isAttachmentUploading,
          messages: snapshot.data ?? [],
          onAttachmentPressed: _handleAtachmentPress,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: types.User(
            id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
          ),
          theme: DarkChatTheme(
              backgroundColor: secondaryColor, inputBackgroundColor: bgColor),
        );
      },
    );
  }
}
