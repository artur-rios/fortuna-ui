// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/authenticate_local_account_command.dart';
import '../models/authenticate_local_account_command_output_data_output.dart';
import '../models/create_local_account_command.dart';
import '../models/create_local_account_command_output_data_output.dart';
import '../models/object_data_output.dart';
import '../models/recover_local_account_command.dart';
import '../models/recover_local_account_command_output_data_output.dart';
import '../models/regenerate_local_account_recovery_codes_command.dart';
import '../models/regenerate_local_account_recovery_codes_command_output_data_output.dart';

part 'local_accounts_client.g.dart';

@RestApi()
abstract class LocalAccountsClient {
  factory LocalAccountsClient(Dio dio, {String? baseUrl}) =
      _LocalAccountsClient;

  @POST('/api/local-accounts')
  Future<CreateLocalAccountCommandOutputDataOutput> postApiLocalAccounts({
    @Body() CreateLocalAccountCommand? body,
  });

  @POST('/api/local-accounts/authenticate')
  Future<AuthenticateLocalAccountCommandOutputDataOutput>
  postApiLocalAccountsAuthenticate({
    @Body() AuthenticateLocalAccountCommand? body,
  });

  @POST('/api/local-accounts/password-reset')
  Future<ObjectDataOutput> postApiLocalAccountsPasswordReset();

  @POST('/api/local-accounts/recover')
  Future<RecoverLocalAccountCommandOutputDataOutput>
  postApiLocalAccountsRecover({@Body() RecoverLocalAccountCommand? body});

  @POST('/api/local-accounts/recovery-codes/regenerate')
  Future<RegenerateLocalAccountRecoveryCodesCommandOutputDataOutput>
  postApiLocalAccountsRecoveryCodesRegenerate({
    @Body() RegenerateLocalAccountRecoveryCodesCommand? body,
  });
}
