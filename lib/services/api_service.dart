import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_jpt/constants/api_constant.dart';
import 'package:chat_jpt/models/chat_model.dart';
import 'package:chat_jpt/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<List<ModelsModel>> getModels() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConstant.baseUrl}/models'), headers: {
        ApiConstant.contentType: ApiConstant.applicationJson,
        'Authorization': ApiConstant.apiKey
      });
      Map jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final result = List<ModelsModel>.from(
            (jsonResponse['data'] as List).map((e) => ModelsModel.fromJson(e)));
        return result;
      } else {
        throw HttpException(jsonResponse['error']["message"]);
      }
    } on HttpException catch (e) {
      debugPrint('error $e');
      rethrow;
    }
  }

  static Future<List<ChatModel>> sendMessageGpt(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response =
          await http.post(Uri.parse('${ApiConstant.apiKey}/chat/completions'),
              headers: {
                ApiConstant.contentType: ApiConstant.applicationJson,
                'Authorization': ApiConstant.apiKey
              },
              body: jsonEncode({
                "model": modelId,
                "messages": [
                  {
                    "role": "user",
                    "content": message,
                  }
                ]
              }));
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }


  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("${ApiConstant.baseUrl}/completions"),
        headers: {
          ApiConstant.contentType: ApiConstant.applicationJson,
          'Authorization': ApiConstant.apiKey
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => ChatModel(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }

    }
  }

