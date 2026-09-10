// GENERATED — DO NOT EDIT.
//
// Produced by `dart run tool/generate_bindings.dart` from the route comments in
// the Fortuna core's published C header. A route that is wrong here is a route
// that is wrong in the header: fix it at the source in fortuna-api and
// regenerate (BR-36, FR-DA-05).

import 'core_route.dart';

/// Every HTTP route the core serves offline, and the symbol that serves it.
///
/// Routes the core deliberately does not export — Heimdall's `/api/auth/**`,
/// Pluggy's connections, hosted consent, the HTTP host's own health checks —
/// are simply absent, which is what makes an offline call to one of them a
/// clean "not available offline" rather than a crash.
const coreRoutes = <CoreRoute>[
  CoreRoute(
    'DELETE',
    '/api/accounts/{id}',
    'fortuna_api_accounts_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/accounts/{id}/hard',
    'fortuna_api_accounts_by_id_hard_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/attachments/{id}',
    'fortuna_api_attachments_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/attachments/{id}/hard',
    'fortuna_api_attachments_by_id_hard_delete',
  ),
  CoreRoute('DELETE', '/api/budgets/{id}', 'fortuna_api_budgets_by_id_delete'),
  CoreRoute(
    'DELETE',
    '/api/categories/{id}',
    'fortuna_api_categories_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/categories/{id}/hard',
    'fortuna_api_categories_by_id_hard_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/counterparties/{id}',
    'fortuna_api_counterparties_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/credit-cards/{id}',
    'fortuna_api_credit_cards_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/credit-cards/{id}/hard',
    'fortuna_api_credit_cards_by_id_hard_delete',
  ),
  CoreRoute('DELETE', '/api/goals/{id}', 'fortuna_api_goals_by_id_delete'),
  CoreRoute(
    'DELETE',
    '/api/installment-plans/{id}',
    'fortuna_api_installment_plans_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/investments/{id}',
    'fortuna_api_investments_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/investments/{id}/hard',
    'fortuna_api_investments_by_id_hard_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/recurring-transactions/{id}',
    'fortuna_api_recurring_transactions_by_id_delete',
  ),
  CoreRoute('DELETE', '/api/tags/{id}', 'fortuna_api_tags_by_id_delete'),
  CoreRoute(
    'DELETE',
    '/api/transactions/{id}',
    'fortuna_api_transactions_by_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/transactions/{id}/hard',
    'fortuna_api_transactions_by_id_hard_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/transactions/{id}/tags/{tagId}',
    'fortuna_api_transactions_by_id_tags_by_tag_id_delete',
  ),
  CoreRoute(
    'DELETE',
    '/api/transfers/{id}',
    'fortuna_api_transfers_by_id_delete',
  ),
  CoreRoute('GET', '/api/accounts', 'fortuna_api_accounts_get'),
  CoreRoute('GET', '/api/accounts/{id}', 'fortuna_api_accounts_by_id_get'),
  CoreRoute(
    'GET',
    '/api/accounts/{id}/balance',
    'fortuna_api_accounts_by_id_balance_get',
  ),
  CoreRoute(
    'GET',
    '/api/attachments/{id}',
    'fortuna_api_attachments_by_id_get',
  ),
  CoreRoute('GET', '/api/audit-entries', 'fortuna_api_audit_entries_get'),
  CoreRoute('GET', '/api/budgets', 'fortuna_api_budgets_get'),
  CoreRoute('GET', '/api/budgets/{id}', 'fortuna_api_budgets_by_id_get'),
  CoreRoute(
    'GET',
    '/api/budgets/{id}/consumption',
    'fortuna_api_budgets_by_id_consumption_get',
  ),
  CoreRoute('GET', '/api/categories', 'fortuna_api_categories_get'),
  CoreRoute('GET', '/api/categories/{id}', 'fortuna_api_categories_by_id_get'),
  CoreRoute('GET', '/api/counterparties', 'fortuna_api_counterparties_get'),
  CoreRoute(
    'GET',
    '/api/counterparties/{id}/suggested-category',
    'fortuna_api_counterparties_by_id_suggested_category_get',
  ),
  CoreRoute('GET', '/api/credit-cards', 'fortuna_api_credit_cards_get'),
  CoreRoute(
    'GET',
    '/api/credit-cards/{id}',
    'fortuna_api_credit_cards_by_id_get',
  ),
  CoreRoute(
    'GET',
    '/api/credit-cards/{id}/statements',
    'fortuna_api_credit_cards_by_id_statements_get',
  ),
  CoreRoute('GET', '/api/currencies', 'fortuna_api_currencies_get'),
  CoreRoute(
    'GET',
    '/api/currencies/{code}',
    'fortuna_api_currencies_by_code_get',
  ),
  CoreRoute('GET', '/api/exports/{id}', 'fortuna_api_exports_by_id_get'),
  CoreRoute('GET', '/api/goals', 'fortuna_api_goals_get'),
  CoreRoute('GET', '/api/goals/{id}', 'fortuna_api_goals_by_id_get'),
  CoreRoute(
    'GET',
    '/api/goals/{id}/progress',
    'fortuna_api_goals_by_id_progress_get',
  ),
  CoreRoute('GET', '/api/import-jobs', 'fortuna_api_import_jobs_get'),
  CoreRoute(
    'GET',
    '/api/import-jobs/{id}',
    'fortuna_api_import_jobs_by_id_get',
  ),
  CoreRoute(
    'GET',
    '/api/import-jobs/{id}/records',
    'fortuna_api_import_jobs_by_id_records_get',
  ),
  CoreRoute(
    'GET',
    '/api/installment-plans/{id}',
    'fortuna_api_installment_plans_by_id_get',
  ),
  CoreRoute('GET', '/api/investments', 'fortuna_api_investments_get'),
  CoreRoute(
    'GET',
    '/api/investments/{id}',
    'fortuna_api_investments_by_id_get',
  ),
  CoreRoute(
    'GET',
    '/api/investments/{id}/valuations',
    'fortuna_api_investments_by_id_valuations_get',
  ),
  CoreRoute('GET', '/api/me', 'fortuna_api_me_get'),
  CoreRoute(
    'GET',
    '/api/me/data-export/{jobId}',
    'fortuna_api_me_data_export_by_job_id_get',
  ),
  CoreRoute(
    'GET',
    '/api/projections/cash-flow',
    'fortuna_api_projections_cash_flow_get',
  ),
  CoreRoute(
    'GET',
    '/api/projections/commitments',
    'fortuna_api_projections_commitments_get',
  ),
  CoreRoute(
    'GET',
    '/api/recurring-transactions/{id}',
    'fortuna_api_recurring_transactions_by_id_get',
  ),
  CoreRoute(
    'GET',
    '/api/reports/aggregate',
    'fortuna_api_reports_aggregate_get',
  ),
  CoreRoute(
    'GET',
    '/api/reports/drill-down',
    'fortuna_api_reports_drill_down_get',
  ),
  CoreRoute(
    'GET',
    '/api/reports/net-position',
    'fortuna_api_reports_net_position_get',
  ),
  CoreRoute('GET', '/api/statements/{id}', 'fortuna_api_statements_by_id_get'),
  CoreRoute('GET', '/api/tags', 'fortuna_api_tags_get'),
  CoreRoute('GET', '/api/transactions', 'fortuna_api_transactions_get'),
  CoreRoute(
    'GET',
    '/api/transactions/{id}',
    'fortuna_api_transactions_by_id_get',
  ),
  CoreRoute('GET', '/api/transfers/{id}', 'fortuna_api_transfers_by_id_get'),
  CoreRoute('POST', '/api/accounts', 'fortuna_api_accounts_post'),
  CoreRoute(
    'POST',
    '/api/accounts/{id}/restore',
    'fortuna_api_accounts_by_id_restore_post',
  ),
  CoreRoute('POST', '/api/budgets', 'fortuna_api_budgets_post'),
  CoreRoute('POST', '/api/categories', 'fortuna_api_categories_post'),
  CoreRoute(
    'POST',
    '/api/categories/{id}/reassign',
    'fortuna_api_categories_by_id_reassign_post',
  ),
  CoreRoute(
    'POST',
    '/api/categories/{id}/restore',
    'fortuna_api_categories_by_id_restore_post',
  ),
  CoreRoute('POST', '/api/counterparties', 'fortuna_api_counterparties_post'),
  CoreRoute(
    'POST',
    '/api/counterparties/{id}/merge',
    'fortuna_api_counterparties_by_id_merge_post',
  ),
  CoreRoute('POST', '/api/credit-cards', 'fortuna_api_credit_cards_post'),
  CoreRoute(
    'POST',
    '/api/credit-cards/{id}/restore',
    'fortuna_api_credit_cards_by_id_restore_post',
  ),
  CoreRoute('POST', '/api/exchange-rates', 'fortuna_api_exchange_rates_post'),
  CoreRoute(
    'POST',
    '/api/exchange-rates/convert',
    'fortuna_api_exchange_rates_convert_post',
  ),
  CoreRoute('POST', '/api/exports', 'fortuna_api_exports_post'),
  CoreRoute('POST', '/api/goals', 'fortuna_api_goals_post'),
  CoreRoute(
    'POST',
    '/api/import-jobs/{id}/retry',
    'fortuna_api_import_jobs_by_id_retry_post',
  ),
  CoreRoute('POST', '/api/imports/excel', 'fortuna_api_imports_excel_post'),
  CoreRoute('POST', '/api/imports/pdf', 'fortuna_api_imports_pdf_post'),
  CoreRoute(
    'POST',
    '/api/installment-plans',
    'fortuna_api_installment_plans_post',
  ),
  CoreRoute(
    'POST',
    '/api/installment-plans/{id}/restore',
    'fortuna_api_installment_plans_by_id_restore_post',
  ),
  CoreRoute('POST', '/api/investments', 'fortuna_api_investments_post'),
  CoreRoute(
    'POST',
    '/api/investments/{id}/movements',
    'fortuna_api_investments_by_id_movements_post',
  ),
  CoreRoute(
    'POST',
    '/api/investments/{id}/restore',
    'fortuna_api_investments_by_id_restore_post',
  ),
  CoreRoute(
    'POST',
    '/api/investments/{id}/valuations',
    'fortuna_api_investments_by_id_valuations_post',
  ),
  CoreRoute('POST', '/api/local-accounts', 'fortuna_api_local_accounts_post'),
  CoreRoute(
    'POST',
    '/api/local-accounts/authenticate',
    'fortuna_api_local_accounts_authenticate_post',
  ),
  CoreRoute(
    'POST',
    '/api/local-accounts/recover',
    'fortuna_api_local_accounts_recover_post',
  ),
  CoreRoute(
    'POST',
    '/api/local-accounts/recovery-codes/regenerate',
    'fortuna_api_local_accounts_recovery_codes_regenerate_post',
  ),
  CoreRoute('POST', '/api/me/data-export', 'fortuna_api_me_data_export_post'),
  CoreRoute('POST', '/api/me/erasure', 'fortuna_api_me_erasure_post'),
  CoreRoute(
    'POST',
    '/api/recurring-transactions',
    'fortuna_api_recurring_transactions_post',
  ),
  CoreRoute(
    'POST',
    '/api/recurring-transactions/materialize',
    'fortuna_api_recurring_transactions_materialize_post',
  ),
  CoreRoute('POST', '/api/reports/table', 'fortuna_api_reports_table_post'),
  CoreRoute(
    'POST',
    '/api/statements/{id}/close',
    'fortuna_api_statements_by_id_close_post',
  ),
  CoreRoute(
    'POST',
    '/api/statements/{id}/settle',
    'fortuna_api_statements_by_id_settle_post',
  ),
  CoreRoute('POST', '/api/tags', 'fortuna_api_tags_post'),
  CoreRoute('POST', '/api/transactions', 'fortuna_api_transactions_post'),
  CoreRoute(
    'POST',
    '/api/transactions/{id}/attachments',
    'fortuna_api_transactions_by_id_attachments_post',
  ),
  CoreRoute(
    'POST',
    '/api/transactions/{id}/reconcile',
    'fortuna_api_transactions_by_id_reconcile_post',
  ),
  CoreRoute(
    'POST',
    '/api/transactions/{id}/restore',
    'fortuna_api_transactions_by_id_restore_post',
  ),
  CoreRoute(
    'POST',
    '/api/transactions/{id}/tags/{tagId}',
    'fortuna_api_transactions_by_id_tags_by_tag_id_post',
  ),
  CoreRoute('POST', '/api/transfers', 'fortuna_api_transfers_post'),
  CoreRoute(
    'POST',
    '/api/transfers/{id}/restore',
    'fortuna_api_transfers_by_id_restore_post',
  ),
  CoreRoute('PUT', '/api/accounts/{id}', 'fortuna_api_accounts_by_id_put'),
  CoreRoute('PUT', '/api/budgets/{id}', 'fortuna_api_budgets_by_id_put'),
  CoreRoute('PUT', '/api/categories/{id}', 'fortuna_api_categories_by_id_put'),
  CoreRoute(
    'PUT',
    '/api/counterparties/{id}',
    'fortuna_api_counterparties_by_id_put',
  ),
  CoreRoute(
    'PUT',
    '/api/credit-cards/{id}',
    'fortuna_api_credit_cards_by_id_put',
  ),
  CoreRoute('PUT', '/api/goals/{id}', 'fortuna_api_goals_by_id_put'),
  CoreRoute(
    'PUT',
    '/api/investments/{id}',
    'fortuna_api_investments_by_id_put',
  ),
  CoreRoute(
    'PUT',
    '/api/recurring-transactions/{id}',
    'fortuna_api_recurring_transactions_by_id_put',
  ),
  CoreRoute('PUT', '/api/tags/{id}', 'fortuna_api_tags_by_id_put'),
  CoreRoute(
    'PUT',
    '/api/transactions/{id}',
    'fortuna_api_transactions_by_id_put',
  ),
];
