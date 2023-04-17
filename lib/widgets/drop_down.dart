import 'package:chat_jpt/constants/constants.dart';
import 'package:chat_jpt/models/models.dart';
import 'package:chat_jpt/providers/models_provider.dart';
import 'package:chat_jpt/services/api_service.dart';
import 'package:chat_jpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModel ;

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context,listen: false);
    currentModel = modelProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelProvider.getAllModels(),
      builder: (context, snapshot) {
        final model = snapshot.data;
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(
              label: snapshot.error.toString(),
            ),
          );
        }
        return model == null || model.isEmpty
            ? const SizedBox.shrink()
            : FittedBox(
              child: DropdownButton(
                dropdownColor: scaffoldBackgroundColor,
                  items: List.generate(
                    model.length,
                    (index) => DropdownMenuItem(
                      value: model[index].id,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget(
                          label: model[index].id,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  value: currentModel,
                  onChanged: (value) {
                    setState(() {
                      currentModel = value.toString();
                    });
                    modelProvider.setCurrentModel(value.toString());
                  },
                ),
            );
      },
    );
  }
}

// DropdownButton(dropdownColor: scaffoldBackgroundColor,
// iconEnabledColor: Colors.white,
// items: getModelsItem,
// value: currentModel,
// onChanged: (value) {
// setState(() {
// currentModel = value.toString();
// });
// },
// );
