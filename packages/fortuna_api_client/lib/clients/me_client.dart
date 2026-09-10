// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/erase_user_command.dart';
import '../models/erase_user_command_output_data_output.dart';
import '../models/grant_processing_consent_command.dart';
import '../models/grant_processing_consent_command_output_data_output.dart';
import '../models/personal_data_export_query_output_data_output.dart';
import '../models/processing_consent_query_output_data_output.dart';
import '../models/request_personal_data_export_command_output_data_output.dart';
import '../models/user_profile_output_data_output.dart';
import '../models/withdraw_processing_consent_command_output_data_output.dart';

part 'me_client.g.dart';

@RestApi()
abstract class MeClient {
  factory MeClient(Dio dio, {String? baseUrl}) = _MeClient;

  @GET('/api/me')
  Future<UserProfileOutputDataOutput> getApiMe();

  @GET('/api/me/consents')
  Future<ProcessingConsentQueryOutputDataOutput> getApiMeConsents();

  @POST('/api/me/consents')
  Future<GrantProcessingConsentCommandOutputDataOutput> postApiMeConsents({
    @Body() GrantProcessingConsentCommand? body,
  });

  @DELETE('/api/me/consents/{purpose}')
  Future<WithdrawProcessingConsentCommandOutputDataOutput>
  deleteApiMeConsentsPurpose({@Path('purpose') required String purpose});

  @POST('/api/me/data-export')
  Future<RequestPersonalDataExportCommandOutputDataOutput>
  postApiMeDataExport();

  @GET('/api/me/data-export/{jobId}')
  Future<PersonalDataExportQueryOutputDataOutput> getApiMeDataExportJobId({
    @Path('jobId') required String jobId,
  });

  @POST('/api/me/erasure')
  Future<EraseUserCommandOutputDataOutput> postApiMeErasure({
    @Body() EraseUserCommand? body,
  });
}
