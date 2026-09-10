// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/confirm_two_factor_through_api_command.dart';
import '../models/confirm_two_factor_through_api_command_output_data_output.dart';
import '../models/disable_two_factor_through_api_command.dart';
import '../models/disable_two_factor_through_api_command_output_data_output.dart';
import '../models/enable_two_factor_through_api_command.dart';
import '../models/enable_two_factor_through_api_command_output_data_output.dart';
import '../models/get_two_factor_status_through_api_command_output_data_output.dart';
import '../models/google_sign_in_through_api_command.dart';
import '../models/google_sign_in_through_api_command_output_data_output.dart';
import '../models/google_sign_out_through_api_command_output_data_output.dart';
import '../models/login_through_api_command.dart';
import '../models/login_through_api_command_output_data_output.dart';
import '../models/regenerate_recovery_codes_through_api_command.dart';
import '../models/regenerate_recovery_codes_through_api_command_output_data_output.dart';
import '../models/request_password_recovery_through_api_command.dart';
import '../models/request_password_recovery_through_api_command_output_data_output.dart';
import '../models/resend_verification_through_api_command_output_data_output.dart';
import '../models/reset_password_through_api_command.dart';
import '../models/reset_password_through_api_command_output_data_output.dart';
import '../models/verify_email_through_api_command.dart';
import '../models/verify_email_through_api_command_output_data_output.dart';
import '../models/verify_two_factor_through_api_command.dart';
import '../models/verify_two_factor_through_api_command_output_data_output.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @GET('/api/auth/2fa')
  Future<GetTwoFactorStatusThroughApiCommandOutputDataOutput> getApiAuth2fa();

  @POST('/api/auth/2fa/confirm')
  Future<ConfirmTwoFactorThroughApiCommandOutputDataOutput>
  postApiAuth2faConfirm({@Body() ConfirmTwoFactorThroughApiCommand? body});

  @POST('/api/auth/2fa/disable')
  Future<DisableTwoFactorThroughApiCommandOutputDataOutput>
  postApiAuth2faDisable({@Body() DisableTwoFactorThroughApiCommand? body});

  @POST('/api/auth/2fa/enable')
  Future<EnableTwoFactorThroughApiCommandOutputDataOutput>
  postApiAuth2faEnable({@Body() EnableTwoFactorThroughApiCommand? body});

  @POST('/api/auth/2fa/recovery-codes/regenerate')
  Future<RegenerateRecoveryCodesThroughApiCommandOutputDataOutput>
  postApiAuth2faRecoveryCodesRegenerate({
    @Body() RegenerateRecoveryCodesThroughApiCommand? body,
  });

  @POST('/api/auth/2fa/verify')
  Future<VerifyTwoFactorThroughApiCommandOutputDataOutput>
  postApiAuth2faVerify({@Body() VerifyTwoFactorThroughApiCommand? body});

  @POST('/api/auth/google')
  Future<GoogleSignInThroughApiCommandOutputDataOutput> postApiAuthGoogle({
    @Body() GoogleSignInThroughApiCommand? body,
  });

  @POST('/api/auth/google/sign-out')
  Future<GoogleSignOutThroughApiCommandOutputDataOutput>
  postApiAuthGoogleSignOut();

  @POST('/api/auth/login')
  Future<LoginThroughApiCommandOutputDataOutput> postApiAuthLogin({
    @Body() LoginThroughApiCommand? body,
  });

  @POST('/api/auth/password-recovery')
  Future<RequestPasswordRecoveryThroughApiCommandOutputDataOutput>
  postApiAuthPasswordRecovery({
    @Body() RequestPasswordRecoveryThroughApiCommand? body,
  });

  @POST('/api/auth/password-reset')
  Future<ResetPasswordThroughApiCommandOutputDataOutput>
  postApiAuthPasswordReset({@Body() ResetPasswordThroughApiCommand? body});

  @POST('/api/auth/resend-verification')
  Future<ResendVerificationThroughApiCommandOutputDataOutput>
  postApiAuthResendVerification();

  @POST('/api/auth/verify-email')
  Future<VerifyEmailThroughApiCommandOutputDataOutput> postApiAuthVerifyEmail({
    @Body() VerifyEmailThroughApiCommand? body,
  });
}
