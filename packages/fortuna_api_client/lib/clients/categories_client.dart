// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/category_lifecycle_command_output_data_output.dart';
import '../models/category_output_data_output.dart';
import '../models/category_tree_output_data_output.dart';
import '../models/create_category_command.dart';
import '../models/create_category_command_output_data_output.dart';
import '../models/reassign_category_transactions_command.dart';
import '../models/reassign_category_transactions_command_output_data_output.dart';
import '../models/update_category_command.dart';
import '../models/update_category_command_output_data_output.dart';

part 'categories_client.g.dart';

@RestApi()
abstract class CategoriesClient {
  factory CategoriesClient(Dio dio, {String? baseUrl}) = _CategoriesClient;

  @GET('/api/categories')
  Future<CategoryTreeOutputDataOutput> getApiCategories({
    @Query('includeDeleted') bool? includeDeleted = false,
    @Query('includeUsageCounts') bool? includeUsageCounts = false,
  });

  @POST('/api/categories')
  Future<CreateCategoryCommandOutputDataOutput> postApiCategories({
    @Body() CreateCategoryCommand? body,
  });

  @DELETE('/api/categories/{id}')
  Future<CategoryLifecycleCommandOutputDataOutput> deleteApiCategoriesId({
    @Path('id') required String id,
  });

  @GET('/api/categories/{id}')
  Future<CategoryOutputDataOutput> getApiCategoriesId({
    @Path('id') required String id,
    @Query('includeDeleted') bool? includeDeleted = false,
    @Query('includeUsageCounts') bool? includeUsageCounts = false,
  });

  @PUT('/api/categories/{id}')
  Future<UpdateCategoryCommandOutputDataOutput> putApiCategoriesId({
    @Path('id') required String id,
    @Body() UpdateCategoryCommand? body,
  });

  @DELETE('/api/categories/{id}/hard')
  Future<CategoryLifecycleCommandOutputDataOutput> deleteApiCategoriesIdHard({
    @Path('id') required String id,
  });

  @POST('/api/categories/{id}/reassign')
  Future<ReassignCategoryTransactionsCommandOutputDataOutput>
  postApiCategoriesIdReassign({
    @Path('id') required String id,
    @Body() ReassignCategoryTransactionsCommand? body,
  });

  @POST('/api/categories/{id}/restore')
  Future<CategoryLifecycleCommandOutputDataOutput> postApiCategoriesIdRestore({
    @Path('id') required String id,
  });
}
