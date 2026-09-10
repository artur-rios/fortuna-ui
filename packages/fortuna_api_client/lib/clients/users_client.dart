// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/erase_user_command.dart';
import '../models/erase_user_command_output_data_output.dart';

part 'users_client.g.dart';

@RestApi()
abstract class UsersClient {
  factory UsersClient(Dio dio, {String? baseUrl}) = _UsersClient;

  @DELETE('/api/users/{id}')
  Future<EraseUserCommandOutputDataOutput> deleteApiUsersId({
    @Path('id') required String id,
    @Body() EraseUserCommand? body,
  });
}
