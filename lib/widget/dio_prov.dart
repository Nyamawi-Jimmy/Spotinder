import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider{

  Future <dynamic> getAlbum(String token) async {
    try{
      var user=await Dio().get('https://api.spotify.com/v1/me/albums',
          options:Options(headers: {'Authorization': 'Bearer $token'}));
      if (user.statusCode==200 && user.data!=''){
        print(user.statusCode);
        return json.encode(user.data);
      }
    }catch(error){
      return error;
    }

  }



}
