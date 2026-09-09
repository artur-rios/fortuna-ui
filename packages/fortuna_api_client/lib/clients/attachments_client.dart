// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/attachment_lifecycle_command_output_data_output.dart';

part 'attachments_client.g.dart';

@RestApi()
abstract class AttachmentsClient {
  factory AttachmentsClient(Dio dio, {String? baseUrl}) = _AttachmentsClient;

  @DELETE('/api/attachments/{id}')
  Future<AttachmentLifecycleCommandOutputDataOutput> deleteApiAttachmentsId({
    @Path('id') required String id,
  });

  @GET('/api/attachments/{id}')
  Future<void> getApiAttachmentsId({@Path('id') required String id});

  @DELETE('/api/attachments/{id}/hard')
  Future<AttachmentLifecycleCommandOutputDataOutput>
  deleteApiAttachmentsIdHard({@Path('id') required String id});
}
