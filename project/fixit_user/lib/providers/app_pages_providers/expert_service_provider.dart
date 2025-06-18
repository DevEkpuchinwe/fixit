import '../../config.dart';

class ExpertServiceProvider with ChangeNotifier {
  final FocusNode searchFocus = FocusNode();
  List<ProviderModel> searchList = [];
  AnimationController? animationController;
  TextEditingController txtFeaturedSearch = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void showLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    _isLoading = false;
    notifyListeners();
  }

  onReady(context, TickerProvider sync) async {
    animationController = AnimationController(
        vsync: sync, duration: const Duration(milliseconds: 1200));
    _runAnimation();
    notifyListeners();
  }

  Future<List<ProviderModel>> fetchData(context) async {
    final dash = Provider.of<DashboardProvider>(context, listen: false);
    return dash.highestRateList;
  }

  void _runAnimation() async {
    for (int i = 0; i < 300; i++) {
      await animationController!.forward();
      await animationController!.reverse();
    }
  }

  //featured package list
  getFeaturedPackage() async {
    showLoading();
    String apiLink = "";
    if (txtFeaturedSearch.text.isNotEmpty) {
      apiLink = "${api.highestRating}?search=${txtFeaturedSearch.text}";
    } else {
      apiLink = api.highestRating;
    }
    try {
      showLoading();
      await apiServices
          .getApi(apiLink, [], isData: true, isMessage: true)
          .then((value) {
        if (value.isSuccess!) {
          hideLoading();
          List service = value.data;
          searchList = [];
          for (var data in service.reversed.toList()) {
            if (!searchList.contains(ProviderModel.fromJson(data))) {
              searchList.add(ProviderModel.fromJson(data));
            }
            notifyListeners();
          }
          notifyListeners();
        }
      });
    } catch (e) {
      hideLoading();
      notifyListeners();
    }
  }

  onBack() {
    txtFeaturedSearch.text = "";
    searchList = [];
    notifyListeners();
    getFeaturedPackage();
  }
}
