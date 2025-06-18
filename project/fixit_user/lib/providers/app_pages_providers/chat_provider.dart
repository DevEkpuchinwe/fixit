import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../firebase/firebase_api.dart';
import '../../models/call_model.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../screens/app_pages_screens/profile_detail_screen/layouts/selection_option_layout.dart';

enum MessageType { text, image }

class ChatProvider with ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode chatFocus = FocusNode();
  List<ChatModel> chatList = [];
  String? chatId, image, name, role, token, code, phone, bookingId;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allMessages = [];
  List<DateTimeChip> localMessage = [];
  int? userId;
  StreamSubscription? messageSub;
  XFile? imageFile;
  BookingModel? booking;

  onReady(context) async {
    try {
      showLoading(context);
      notifyListeners();
      chatId = "0";
      messageSub = null;
      allMessages = [];
      localMessage = [];

      dynamic data = ModalRoute.of(context)!.settings.arguments ?? "";
      if (data != "") {
        userId = int.parse(data['userId'].toString());
        name = data['name'];
        image = data['image'];
        role = data['role'];
        token = data['token'];
        phone = data['phone'].toString();
        code = data['code']?.toString();
        bookingId = data['bookingId'].toString();
      }
      chatId = bookingId;
      await Future.wait([getBookingDetailBy(context), getChatData(context)]);
      notifyListeners();
      log("BOOKINGID :$chatId");
    } catch (e) {
      log("EEEE onREADY CHAT : $e");
    }
  }

  //booking detail by id
  Future getBookingDetailBy(context) async {
    try {
      await apiServices
          .getApi("${api.booking}/$bookingId", [], isToken: true, isData: true)
          .then((value) {
        debugPrint("BOOKING DATA : ${value.data}");
        hideLoading(context);
        if (value.isSuccess!) {
          booking = BookingModel.fromJson(value.data);
          notifyListeners();
        }
        int index = booking!.servicemen!.indexWhere(
            (element) => element.id.toString() == userId.toString());
        if (index >= 0) {
          phone = booking!.servicemen![index].phone.toString();
          token = booking!.servicemen![index].fcmToken;
          code = booking!.servicemen![index].code;
        }
        notifyListeners();
      });
      log("STATYS L $booking");
    } catch (e) {
      hideLoading(context);
      notifyListeners();
    }
  }

  onBack(context, isBack) {
    onBackConfirmation(context);
  }

  onBackConfirmation(context) async {
    if (booking!.service!.type == "remotely") {
      showDialog(
          context: context,
          builder: (context1) => AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: Insets.i20),
              contentPadding: EdgeInsets.zero,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius.all(SmoothRadius(
                      cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
              backgroundColor: appColor(context).whiteBg,
              content: Stack(alignment: Alignment.topRight, children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const VSpace(Sizes.s15),
                  Text(language(context, translations!.alertChatBackDesc),
                      textAlign: TextAlign.center,
                      style: appCss.dmDenseRegular14
                          .textColor(appColor(context).darkText)
                          .textHeight(1.4)),
                  const VSpace(Sizes.s20),
                  BottomSheetButtonCommon(
                      clearTap: () => route.pop(context),
                      applyTap: () => updateStatus(context, booking!.id),
                      textTwo: translations!.goBack,
                      textOne: translations!.cancel)
                ]).padding(
                  horizontal: Insets.i20,
                  top: Insets.i60,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                            language(context, translations!.alertChatBack),
                            overflow: TextOverflow.ellipsis,
                            style: appCss.dmDenseMedium18
                                .textColor(appColor(context).darkText)),
                      ),
                      Icon(CupertinoIcons.multiply,
                              size: Sizes.s20,
                              color: appColor(context).darkText)
                          .inkWell(onTap: () => route.pop(context))
                    ]).paddingAll(Insets.i20)
              ])));
    } else {
      log("CHECKKKC");
      route.pop(context);
    }
  }

  //update status
  updateStatus(context, bookingId, {isCancel = false, sync}) async {
    log("NOCHANGE");
    try {
      route.pop(context);
      showLoading(context);

      notifyListeners();
      dynamic data;
      data = {"booking_status": translations!.completed};
      log("ON L$data");
      await apiServices
          .putApi("${api.booking}/$bookingId", data,
              isToken: true, isData: true)
          .then((value) {
        hideLoading(context);
        notifyListeners();

        if (value.isSuccess!) {
          debugPrint("STATYS YYYY:  ${value.data}");
          final dash = Provider.of<DashboardProvider>(context, listen: false);
          dash.selectIndex = 1;
          dash.getBookingHistory(context);
          route.pushNamed(context, routeName.completedServiceScreen,
              arg: {"booking": booking}).then((e) {
            dash.notifyListeners();
            route
                .pushReplacementNamed(context, routeName.dashboard)
                .then((e) {});
          });
          allMessages = [];
          localMessage = [];
          messageSub = null;
          booking = null;
          chatId = null;
          image = null;
          name = null;
          role = null;
          token = null;
          code = null;
          phone = null;
          notifyListeners();
        } else {
          log("SSS :${value.data} // ${value.message}");
        }
      });
      hideLoading(context);
      notifyListeners();
    } catch (e) {
      log("SSS :$e");
      hideLoading(context);
      notifyListeners();
    }
  }

  showLayout(
    context,
  ) async {
    showDialog(
        context: context,
        builder: (context1) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppRadius.r12))),
              content: Consumer<LanguageProvider>(
                builder:(context, value, child)  {
                  return Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language(context, translations!.selectOne),
                              style: appCss.dmDenseBold18
                                  .textColor(appColor(context).darkText)),
                          const Icon(CupertinoIcons.multiply)
                              .inkWell(onTap: () => route.pop(context))
                        ]),
                    const VSpace(Sizes.s20),
                    ...appArray.selectList
                        .asMap()
                        .entries
                        .map((e) => SelectOptionLayout(
                            data: e.value,
                            index: e.key,
                            list: appArray.selectList,
                            onTap: () {
                              if (e.key == 0) {
                                getImage(context, ImageSource.gallery);
                              } else {
                                getImage(context, ImageSource.camera);
                              }
                            }))
                  ]);
                }
              ));
        });
  }

  // GET IMAGE FROM GALLERY
  Future getImage(context, source) async {
    final ImagePicker picker = ImagePicker();
    imageFile = (await picker.pickImage(source: source));
    notifyListeners();
    if (imageFile != null) {
      uploadFile(context);
      route.pop(context);
    }
  }

// UPLOAD SELECTED IMAGE TO FIREBASE
  Future uploadFile(context) async {
    showLoading(context);
    notifyListeners();
    FocusScope.of(context).requestFocus(FocusNode());
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    var file = File(imageFile!.path);
    UploadTask uploadTask = reference.putFile(file);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((downloadUrl) {
        String imageUrl = downloadUrl;
        imageFile = null;

        notifyListeners();
        setMessage(imageUrl, MessageType.image, context);
      }, onError: (err) {
        hideLoading(context);
        notifyListeners();
      });
    });
  }

  Future<void> makePhoneCall(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//get camera permission
  static Future<PermissionStatus> getCameraPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    log("cameraPermission : $cameraPermission");
    if (cameraPermission != PermissionStatus.granted &&
        cameraPermission != PermissionStatus.denied) {
      return Permission.camera as FutureOr<PermissionStatus>? ??
          PermissionStatus.granted;
    } else {
      return cameraPermission;
    }
  }

  // get microphone permission
  static Future<PermissionStatus> getMicrophonePermission() async {
    if (await Permission.microphone.request().isGranted) {
      return PermissionStatus.granted;
    } else {
      return PermissionStatus.denied;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<bool> getCameraMicrophonePermissions() async {
    PermissionStatus cameraPermissionStatus = await getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  onCallTap(context, index) async {
    log("CODE :$index");
    route.pop(context);
    if (index == 0) {
      getCameraMicrophonePermissions().then((value) {
        if (value == true) {
          audioVideoCallTap(context, false);
        }
      });
    } else {
      getCameraMicrophonePermissions().then((value) {
        if (value == true) {
          audioVideoCallTap(context, true);
        }
      });
    }
    notifyListeners();
  }

  //audio and video call tap
  audioVideoCallTap(context, isVideoCall) async {
    await audioAndVideoCallApi(context, isVideoCall);
  }

  audioAndVideoCallApi(context, isVideoCall) async {
    Map<String, dynamic>? response = await getAgoraTokenAndChannelName();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    if (response != null) {
      String channelId = response["channelName"];
      String token = response["agoraToken"];
      Call call = Call(
          timestamp: timestamp,
          callerId: userModel!.id!.toString(),
          callerName: userModel!.name,
          callerPic: userModel!.media != null && userModel!.media!.isNotEmpty
              ? userModel!.media![0].originalUrl ?? ""
              : "",
          receiverId: userId.toString(),
          receiverName: name,
          receiverPic: image,
          channelId: channelId,
          isVideoCall: isVideoCall,
          agoraToken: token);

      await FirebaseFirestore.instance
          .collection(collectionName.calls)
          .doc(call.callerId)
          .collection(collectionName.calling)
          .add({
        "timestamp": timestamp,
        "callerId": call.callerId,
        "callerName": call.callerName,
        "callerPic": call.callerPic,
        "receiverId": call.receiverId,
        "receiverName": call.receiverName,
        "receiverPic": call.receiverPic,
        "hasDialled": true,
        "channelId": response['channelName'],
        "isVideoCall": isVideoCall,
        "agoraToken": token,
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection(collectionName.calls)
            .doc(call.receiverId)
            .collection(collectionName.calling)
            .add({
          "timestamp": timestamp,
          "callerId": call.callerId,
          "callerName": call.callerName,
          "callerPic": call.callerPic,
          "receiverId": call.receiverId,
          "receiverName": call.receiverName,
          "receiverPic": call.receiverPic,
          "hasDialled": false,
          "channelId": response['channelName'],
          "isVideoCall": isVideoCall,
          "agoraToken": token,
        }).then((value) async {
          call.hasDialled = true;
          if (isVideoCall == false) {
            FirebaseApi().sendNotification(
                title: "Incoming Audio Call...",
                msg: "${call.callerName} audio call",
                token: token,
                name: call.callerName,
                image: image,
                dataTitle: call.callerName);
            var data = {
              "channelName": call.channelId,
              "call": call,
              "token": response["agoraToken"]
            };
            log("Audio Call ::$data");
            route.pushNamed(context, routeName.audioCall, arg: data);
          } else {
            FirebaseApi().sendNotification(
                title: "Incoming Video Call...",
                msg: "${call.callerName} video call",
                token: token,
                name: call.callerName,
                image: image,
                dataTitle: call.callerName);

            var data = {
              "channelName": call.channelId,
              "call": call,
              "token": response["agoraToken"]
            };

            route.pushNamed(context, routeName.videoCall, arg: data);
          }
        });
      });
    } else {
      log("messagefhasuifhudfhsu");
      Fluttertoast.showToast(msg: "Failed to call");
    }
  }

  getAgoraTokenAndChannelName() async {
    try {
      HttpsCallable httpsCallable =
          FirebaseFunctions.instance.httpsCallable("generateToken");
      if (appSettingModel!.agora != null) {
        dynamic result = await httpsCallable.call(
          {
            "appId": appSettingModel!.agora!.appId,
            "appCertificate": appSettingModel!.agora!.certificate
          },
        );

        if (result.data != null) {
          Map<String, dynamic> response = {
            "agoraToken": result.data['data']["token"],
            "channelName": result.data['data']["channelName"],
          };

          return response;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      log("ERROR WHILE FETCH CREDENTIALS : $e");
    }
  }

  //get chat data
  /*getChatData(context) async {

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.chats).where("bookingId",isEqualTo: bookingId)
        .get().then((value){
      log("userModel!.id.toString() :${value.docs.length}");
      if(value.docs.isNotEmpty){
        messageSub = FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.messages).doc(chatId).collection(collectionName.chat)
            .snapshots()
            .listen((event) async {
          allMessages = event.docs;
          notifyListeners();

          FirebaseApi().getLocalMessage(context);

          notifyListeners();
          seenMessage();
        });
      }else{
        messageSub =null;
        allMessages = [];
        localMessage = [];
      }
      notifyListeners();
    });

    notifyListeners();
    if (chatId != "0") {
      log("userModel!.id.toString() ss:${userModel!.id.toString()}");

      await FirebaseFirestore.instance
          .collection(collectionName.users)
          .get()
          .then((value) {
        log("value.docs :${value.docs}");
        if (value.docs.isNotEmpty) {
          int index = value.docs
              .indexWhere((element) => element.id == userModel!.id.toString());
          log("message ::$index");
          if (index >= 0) {
            chatId = value.docs[index].data()['chatId'];
          }
        }
        notifyListeners();
        log("CHATID : $chatId");
      });
    }
  }*/

  Future getChatData(context) async {
    log("chatIdsd :$chatId ///$userId // ${userModel!.id}");
    if (chatId != "0") {
      messageSub = FirebaseFirestore.instance
          .collection(collectionName.users)
          .doc(userModel!.id.toString())
          .collection(collectionName.chatWith)
          .doc(userId.toString())
          .collection(collectionName.booking)
          .doc(chatId.toString())
          .collection(collectionName.chat)
          .snapshots()
          .listen((event) async {
        allMessages = event.docs;
        notifyListeners();

        FirebaseApi().getLocalMessage(context);
        log("allMessages :$allMessages");
        notifyListeners();
        seenMessage();
      });
      hideLoading(context);
      notifyListeners();
    } else {
      chatId = "0";
      messageSub = null;
      allMessages = [];
      localMessage = [];
      hideLoading(context);
      notifyListeners();
    }

    notifyListeners();
  }

  //seen all message
  seenMessage() async {
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.chatWith)
        .doc(userId.toString())
        .collection(collectionName.booking)
        .doc(chatId.toString())
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      log("RECEIVER : ${value.docs.length}");
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.chats)
            .doc(userId.toString())
            .collection(collectionName.booking)
            .doc(chatId.toString())
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });

    log("userModel!.id.toString() :${userModel!.id.toString()}");
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userModel!.id.toString())
        .collection(collectionName.chats)
        .where("bookingId", isEqualTo: chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userModel!.id.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });

    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.chatWith)
        .doc(userModel!.id.toString())
        .collection(collectionName.booking)
        .doc(chatId.toString())
        .collection(collectionName.chat)
        .where("receiverId", isEqualTo: userModel!.id.toString())
        .get()
        .then((value) {
      log("RECEIVER : ${value.docs.length}");
      value.docs.asMap().entries.forEach((element) async {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.chatWith)
            .doc(userModel!.id.toString())
            .collection(collectionName.booking)
            .doc(chatId.toString())
            .collection(collectionName.chat)
            .doc(element.value.id)
            .update({"isSeen": true});
      });
    });
    await FirebaseFirestore.instance
        .collection(collectionName.users)
        .doc(userId.toString())
        .collection(collectionName.chats)
        .where("bookingId", isEqualTo: chatId)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName.users)
            .doc(userId.toString())
            .collection(collectionName.chats)
            .doc(value.docs[0].id)
            .update({"isSeen": true});
      }
    });
  }

  Widget timeLayout(context) {
    return Column(
        children: localMessage.reversed.toList().asMap().entries.map((a) {
      List<MessageModel> newMessageList = a.value.message!.toList();

      return Column(children: [
        Text(
                a.value.time!.contains("-other")
                    ? a.value.time!.split("-other")[0]
                    : a.value.time!,
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).lightText))
            .marginSymmetric(vertical: Insets.i5),
        ...newMessageList.reversed.toList().asMap().entries.map((e) {
          return buildItem(
              e.key,
              e.value,
              e.value.docId,
              a.value.time!.contains("-other")
                  ? a.value.time!.split("-other")[0]
                  : a.value.time!);
        })
      ]);
    }).toList());
  }

// BUILD ITEM MESSAGE BOX FOR RECEIVER AND SENDER BOX DESIGN
  Widget buildItem(int index, MessageModel document, documentId, title) {
    if (document.senderId.toString() == userModel!.id.toString()) {
      /*   return SenderMessage(
          document: document,
          index: index,
          docId: document.docId,
          title: title);*/
      return ChatLayout(document: document, isSentByMe: true);
    } else {
      // RECEIVER MESSAGE
      return ChatLayout(document: document, isSentByMe: false);
    }
  }

  // SEND MESSAGE CLICK
  void setMessage(String content, MessageType type, context) async {
    // isLoading = true;
    if (content.trim() != '') {
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      MessageModel messageModel = MessageModel(
        chatId: chatId,
        content: content,
        docId: time,
        messageType: "sender",
        receiverId: userId!.toString(),
        senderId: userModel!.id!.toString(),
        timestamp: time,
        type: type.name,
        receiverImage: image,
        bookingId: chatId.toString(),
        receiverName: name,
        senderImage: userModel!.media != null && userModel!.media!.isNotEmpty
            ? userModel!.media![0].originalUrl!
            : null,
        senderName: userModel!.name,
        role: "user",
      );
      controller.text = "";
      bool isEmpty =
          localMessage.where((element) => element.time == "Today").isEmpty;
      if (isEmpty) {
        List<MessageModel>? message = [];
        if (message.isNotEmpty) {
          message.add(messageModel);
          message[0].docId = time;
        } else {
          message = [messageModel];
          message[0].docId = time;
        }
        DateTimeChip dateTimeChip =
            DateTimeChip(time: getDate(time), message: message);
        localMessage.add(dateTimeChip);
      } else {
        int index =
            localMessage.indexWhere((element) => element.time == "Today");

        if (!localMessage[index].message!.contains(messageModel)) {
          localMessage[index].message!.add(messageModel);
        }
      }
      notifyListeners();
      log("chatId :$chatId");
      log("chatId :$token");
      log("chatId :${userModel!.fcmToken}");

      await FirebaseApi()
          .saveMessage(
              role: "user",
              receiverName: name,
              type: type,
              dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
              encrypted: content,
              isSeen: false,
              newChatId: chatId,
              collectionId: userId.toString(),
              pId: userId,
              bookingId: chatId,
              receiverImage: image,
              senderId: userModel!.id)
          .then((value) async {
        await FirebaseApi()
            .saveMessage(
                role: "user",
                receiverName: name,
                type: type,
                collectionId: userModel!.id.toString(),
                bookingId: chatId,
                dateTime: DateTime.now().millisecondsSinceEpoch.toString(),
                encrypted: content,
                isSeen: false,
                newChatId: chatId,
                pId: userId,
                receiverImage: image,
                senderId: userId.toString())
            .then((snap) async {
          await FirebaseApi().saveMessageInUserCollection(
              senderId: userModel!.id,
              rToken: token,
              sToken: userModel!.fcmToken,
              receiverImage: image,
              newChatId: chatId,
              type: type,
              receiverName: name,
              bookingId: chatId,
              content: content,
              receiverId: userId,
              id: userModel!.id,
              role: "user");
          await FirebaseApi().saveMessageInUserCollection(
            senderId: userModel!.id,
            receiverImage: image,
            newChatId: chatId,
            rToken: token,
            sToken: userModel!.fcmToken,
            type: type,
            bookingId: chatId,
            receiverName: name,
            content: content,
            receiverId: userId,
            id: userId,
            role: "user",
          );
        });
      }).then((value) async {
        notifyListeners();
        getChatData(context);
        log("userModel!.name${userModel!.id}");
        if (token != "" && token != null) {
          FirebaseApi().sendNotification(
              title: "${userModel!.name} send you message",
              msg: content,
              chatId: chatId,
              token: token,
              pId: userModel!.id,
              image: image ?? "",
              name: userModel!.name,
              phone: phone,
              code: code,
              bookingId: chatId);
        }
      });
    }
    final chat = Provider.of<ChatHistoryProvider>(context, listen: false);
    chat.onReady(context);
  }

  onClearChat(context, sync) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(sync, context, eImageAssets.clearChat,
        translations!.clearChat, translations!.areYouClearChat, () async {
      route.pop(context);
      await FirebaseApi().clearChat(context);
      value.onResetPass(
          context,
          language(context, translations!.hurrayChatDelete),
          language(context, translations!.okay),
          () => Navigator.pop(context));
    });
    value.notifyListeners();
  }
}
