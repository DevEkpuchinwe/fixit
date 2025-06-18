import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:fixit_provider/config.dart';
import 'package:intl/intl.dart';

class PackageListProvider with ChangeNotifier {
  //package active status
  onToggle(index, val, context, id) {
    servicePackageList[index].status = val == true ? 1 : 0;
    updateActiveStatusServicePackage(context, id, val, index);
    notifyListeners();
  }

  //package delete confirmation
  onPackageDelete(context, sync, id) {
    final value = Provider.of<DeleteDialogProvider>(context, listen: false);

    value.onDeleteDialog(
        sync,
        context,
        eImageAssets.packageDelete,
        translations!.deletePackages,
        translations!.areYouSureDeletePackage, () {
      route.pop(context);
      deletePackage(context, id);
    });
    value.notifyListeners();
  }

  //delete package
  deletePackage(context, id) async {
    showLoading(context);
    notifyListeners();
    try {
      log("id:::$id");
      await apiServices
          .deleteApi("${api.servicePackage}/$id", {}, isToken: true)
          .then((value) {
        notifyListeners();
        if (value.isSuccess!) {
          hideLoading(context);
          final common =
              Provider.of<UserDataApiProvider>(context, listen: false);
          common.getServicePackageList();
          notifyListeners();
          final delete =
              Provider.of<DeleteDialogProvider>(context, listen: false);
          delete.onResetPass(
              context,
              language(context, translations!.hurrayPackageDelete),
              language(context, translations!.okay), () {
            route.pop(context);
            notifyListeners();
          });

          notifyListeners();
        } else {
          hideLoading(context);
          snackBarMessengers(context,
              color: appColor(context).appTheme.red, message: value.message);
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE deleteServiceman : $e");
    }
  }

  //update active status of service package
  updateActiveStatusServicePackage(context, id, val, index) async {
    showLoading(context);

    servicePackageList[index].status = val == true ? 1 : 0;
    notifyListeners();
    editServicePackageApi(context, servicePackageList[index], val);
  }

//edit service package api
  editServicePackageApi(
      context, ServicePackageModel? servicePackageModel, val) async {
    showLoading(context);
    notifyListeners();

    try {
      var body = {
        "title": servicePackageModel!.title,
        "hexa_code": servicePackageModel.hexaCode!.contains("#")
            ? servicePackageModel!.hexaCode
            : "#${servicePackageModel.hexaCode}",
        "provider_id": userModel!.id,
        "price": servicePackageModel.price,
        "discount": servicePackageModel.discount,
        "description": servicePackageModel.description,
        "disclaimer": servicePackageModel.disclaimer,
        "started_at": DateFormat("dd-MMM-yyyy").format(DateTime.parse(
            servicePackageModel
                .startedAt!)) /* servicePackageModel.startedAt */,
        "ended_at": DateFormat("dd-MMM-yyyy").format(DateTime.parse(
            servicePackageModel.endedAt!)) /* servicePackageModel.endedAt */,
        "is_featured": "1",
        "status": val == true ? "1" : 0,
        "_method": "PUT",
        for (var i = 0; i < servicePackageModel.services!.length; i++)
          "service_id[$i]": servicePackageModel.services![i].id,
      };
      dio.FormData formData = dio.FormData.fromMap(body);

      await apiServices
          .postApi("${api.servicePackage}/${servicePackageModel.id}", formData,
              isToken: true)
          .then((value) async {
        hideLoading(context);
        notifyListeners();
        if (value.isSuccess!) {
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();
          snackBarMessengers(context,
              message: value.message,
              color: appColor(context).appTheme.primary);

          notifyListeners();
        } else {
          hideLoading(context);
          notifyListeners();
          final userApi =
              Provider.of<UserDataApiProvider>(context, listen: false);
          await userApi.getServicePackageList();
        }
      });
    } catch (e) {
      hideLoading(context);
      notifyListeners();
      log("EEEE updatestatus : $e");
    }
  }
}
