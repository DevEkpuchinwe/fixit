import '../../config.dart';
import '../../model/dash_board_model.dart' show LatestBlog;

class LatestBLogDetailsProvider with ChangeNotifier {
  BlogModel? data;
  LatestBlog? data1;

  onReady(context) {
    dynamic arg = ModalRoute.of(context)!.settings.arguments;
    data = arg;
    notifyListeners();
  }

  onHomeReady(context) {
    dynamic arg = ModalRoute.of(context)!.settings.arguments;
    data1 = arg;
    notifyListeners();
  }

  onBack(context) {
    data = null;
    route.pop(context);
    notifyListeners();
  }

  onHomeBack(context) {
    data1 = null;
    route.pop(context);
    notifyListeners();
  }
}
