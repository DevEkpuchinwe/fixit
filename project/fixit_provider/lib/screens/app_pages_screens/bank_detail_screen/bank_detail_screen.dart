import '../../../config.dart';

class BankDetailScreen extends StatelessWidget {
  const BankDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BankDetailProvider>(builder: (context1, value, child) {
      return StatefulWrapper(
          onInit: () =>
              Future.delayed(DurationsDelay.ms150).then((_) => value.getArg()),
          child: Scaffold(
              appBar: AppBarCommon(title: translations!.bankDetails),
              body: SingleChildScrollView(
                  child: Column(children: [
                const Stack(
                    children: [FieldsBackground(), BankDetailBodyWidget()]),
                ButtonCommon(
                        title: translations!.update,
                        onTap: () => value.updateBankDetail(context))
                    .paddingOnly(bottom: Insets.i10, top: Insets.i40)
              ]).paddingAll(Insets.i20))));
    });
  }
}
