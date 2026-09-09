// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_tag_command.dart';
import '../models/tag_command_output_data_output.dart';
import '../models/tag_list_output_data_output.dart';
import '../models/update_tag_command.dart';

part 'tags_client.g.dart';

@RestApi()
abstract class TagsClient {
  factory TagsClient(Dio dio, {String? baseUrl}) = _TagsClient;

  @GET('/api/tags')
  Future<TagListOutputDataOutput> getApiTags({
    @Query('includeDeleted') bool? includeDeleted = false,
  });

  @POST('/api/tags')
  Future<TagCommandOutputDataOutput> postApiTags({
    @Body() CreateTagCommand? body,
  });

  @DELETE('/api/tags/{id}')
  Future<TagCommandOutputDataOutput> deleteApiTagsId({
    @Path('id') required String id,
  });

  @PUT('/api/tags/{id}')
  Future<TagCommandOutputDataOutput> putApiTagsId({
    @Path('id') required String id,
    @Body() UpdateTagCommand? body,
  });
}
