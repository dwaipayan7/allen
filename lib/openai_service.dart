import 'dart:convert';

import 'package:allen/secrets.dart';
import 'package:http/http.dart' as http;

class OpenAIService{
  final List<Map<String, String>> message = [];

  Future<String> isArtPromptAPI(String prompt) async{
  try{
    final res = await http.post(Uri.
    parse('https://api.openai.com/v1/chat/completions'),
    headers:{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAIAPIKEY',
    },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'user',
            'content': 'Does this message want to generate an AI picture, image, art or anything similar? $prompt. Simply answer with yes or no',
          },
        ],
      }),
    );
    print(res.body);
    if(res.statusCode == 200){
      String content = jsonDecode(res.body)['choices'][0]['message']['content'];
      content = content.trim();

      switch(content){
        case 'Yes':
        case 'yes':
          case 'Yes.':
            case 'yes.':
            final res =  await dallEAPI(prompt);
            return res;
        default:
          final res =  await chatGPTAPI(prompt);
          return res;
      }

    }
    return 'An internal error occur!!';
  }catch(e){
    return e.toString();
  }
  }
  Future<String> chatGPTAPI(String prompt) async{

    message.add({
      'role':'user',
      'content':prompt,
    });

    try{
      final res = await http.post(Uri.
      parse('https://api.openai.com/v1/chat/completions'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKEY',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': 'Does this message want to generate an AI picture, image, art or anything similar? $prompt. Simply answer with yes or no',
            },
          ],
        }),
      );
      print(res.body);
      if(res.statusCode == 200){
        String content = jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch(content){
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res =  await dallEAPI(prompt);
            return res;
          default:
            final res =  await chatGPTAPI(prompt);
            return res;
        }

      }
      return 'An internal error occur!!';
    }catch(e){
      return e.toString();
    }
  }
  Future<String> dallEAPI(String prompt) async{
    return 'DALL-E';
  }
}