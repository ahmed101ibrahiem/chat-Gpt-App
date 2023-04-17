
import 'package:chat_jpt/services/api_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/models.dart';

class ModelsProvider with ChangeNotifier{
  String _currentModel = 'text-davinci-003';

  String get getCurrentModel => _currentModel;

  void setCurrentModel(String newModel) {
    _currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }
  Future<List<ModelsModel>> getAllModels()async{
    modelsList = await ApiServices.getModels();
    return modelsList;
  }
}