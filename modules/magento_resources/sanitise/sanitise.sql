
-- cleaning config data:
delete from core_config_data where path in (
  'facebooklogin/general/app_id' , -- facebook app id
  'facebooklogin/general/app_secret', -- facebook app secret
  'google/analytics/account', -- google analytics property id
  'googletagmanager/general/account', -- google tag manager id
  'weltpixel_googletagmanager/api/account_id', -- google tag manager id
  'weltpixel_googletagmanager/api/container_id',
  'weltpixel_googletagmanager/general/gtm_code',
  'magemonkey/general/apikey', -- mailchimp api key
  'payment/spriicheckout/checkoutcom_privatekey_live', -- checkout.com private key
  'payment/spriicheckout/checkoutcom_publickey_live', -- checkout.com public key
  'payment/spriicheckout/authorization_header',
  'paypal/general/business_account', -- paypal account
  'smile_elasticsuite_core_base_settings/es_client/servers', -- elastic search host name
  'web/cookie/cookie_domain', -- cookie domain
  'web/cookie/cookie_path',
  'web/secure/base_link_url',
  'web/secure/base_media_url',
  'web/secure/base_static_url',
  'web/secure/base_url',
  'web/unsecure/base_link_url',
  'web/unsecure/base_media_url',
  'web/unsecure/base_static_url',
  'web/unsecure/base_url',
  'admin/security/password_lifetime', -- disable password lifetime
  'carriers/fetchr/dropship_username',
  'carriers/fetchr/dropship_password',
  'carriers/fetchr/awb_token',
  'carriers/fetchr/dropship_token',
  'carriers/fetchr/dropship_url',
  'carriers/fetchr/awb_url',
  'sprii_shipment_status/fetchr/token',
  'sprii_shipment_status/fetchr/endpoint',
  'potato_zendesk/account/zendesk_token',
  'potato_zendesk/general/token',
  'mailchimp/general/apikeylist',
  'mailchimp/general/apikey',
  'mailchimp/general/monkeystore',
  'magemonkey/general/apikey',
  'dropship/general/dropship_fetchr_email',
  'dropship/general/debug',
  'sprii_sms_setting/oxygen8_http_relay/username',
  'sprii_sms_setting/oxygen8_http_relay/password',
  'orocrm_integration/general/orocrm_server',
  'orocrm_integration/general/enabled_web_activity_tracking',
  'orocrm_integration/general/site_id'
);



-- because im lazy :D
SET FOREIGN_KEY_CHECKS=0;

-- product alerts
truncate table product_alert_price;
truncate table product_alert_stock;

-- amasty modules
truncate table amasty_amsmtp_debug;
truncate table amasty_amsmtp_log;
truncate table amasty_audit_active;
truncate table amasty_audit_log;
truncate table amasty_audit_log_details;
truncate table amasty_audit_login_attempts;
truncate table amasty_audit_visit;
truncate table amasty_audit_visit_details;
truncate table amasty_geoip_block;
truncate table amasty_geoip_location;
truncate table amasty_shiprules_attribute;
truncate table amasty_shiprules_rule;

truncate table `cache`;
truncate table cache_tag;
truncate table captcha_log;

truncate table cron_schedule;

truncate table customer_log;
truncate table customer_visitor;

truncate table flag;

truncate table import_history;
truncate table importexport_importdata;


-- clean tables from cache_warmer module
truncate table mst_cache_warmer_job;
truncate table mst_cache_warmer_log;
truncate table mst_cache_warmer_page;
truncate table mst_cache_warmer_report;
truncate table mst_cache_warmer_report_aggregated;

-- admin notification table
truncate table adminnotification_inbox;

-- logs
truncate table report_event;
truncate table search_query;
truncate table ui_bookmark;
truncate table oauth_token_request_log;

-- remove password request
truncate table password_reset_request_event;

-- clean quotes - don't clear them because then it's hard to debug issues with quotes :(
/*TRUNCATE TABLE quote;
TRUNCATE TABLE quote_address;
TRUNCATE TABLE quote_address_item;
TRUNCATE TABLE quote_id_mask;
TRUNCATE TABLE quote_item;
TRUNCATE TABLE quote_item_option;
TRUNCATE TABLE quote_payment;
TRUNCATE TABLE quote_shipping_rate;
*/


/* --do not clean indexes etc (because reindex takes too long...)
truncate table catalog_category_product_index;
truncate table catalog_category_product_index_tmp;
truncate table catalog_product_bundle_price_index;
truncate table catalog_product_bundle_stock_index;
truncate table catalog_product_index_eav;
truncate table catalog_product_index_eav_decimal;
truncate table catalog_product_index_eav_decimal_idx;
truncate table catalog_product_index_eav_decimal_tmp;
truncate table catalog_product_index_eav_idx;
truncate table catalog_product_index_eav_tmp;
truncate table catalog_product_index_price;
truncate table catalog_product_index_price_bundle_idx;
truncate table catalog_product_index_price_bundle_opt_idx;
truncate table catalog_product_index_price_bundle_opt_tmp;
truncate table catalog_product_index_price_bundle_sel_idx;
truncate table catalog_product_index_price_bundle_sel_tmp;
truncate table catalog_product_index_price_bundle_tmp;
truncate table catalog_product_index_price_cfg_opt_agr_idx;
truncate table catalog_product_index_price_cfg_opt_agr_tmp;
truncate table catalog_product_index_price_cfg_opt_idx;
truncate table catalog_product_index_price_cfg_opt_tmp;
truncate table catalog_product_index_price_downlod_idx;
truncate table catalog_product_index_price_downlod_tmp;
truncate table catalog_product_index_price_final_idx;
truncate table catalog_product_index_price_final_tmp;
truncate table catalog_product_index_price_idx;
truncate table catalog_product_index_price_opt_agr_idx;
truncate table catalog_product_index_price_opt_agr_tmp;
truncate table catalog_product_index_price_opt_idx;
truncate table catalog_product_index_price_opt_tmp;
truncate table catalog_product_index_price_tmp;
truncate table catalog_product_index_tier_price;
truncate table catalog_product_index_website;
truncate table cataloginventory_stock_status_idx;
truncate table cataloginventory_stock_status_tmp;
*/

-- remove reports
truncate table report_compared_product_index;
truncate table report_event;
truncate table report_viewed_product_aggregated_daily;
truncate table report_viewed_product_aggregated_monthly;
truncate table report_viewed_product_aggregated_yearly;
truncate table report_viewed_product_index;
truncate table reporting_counts;
truncate table reporting_module_status;
truncate table reporting_orders;
truncate table reporting_system_updates;
truncate table reporting_users;

-- remove sessions
truncate table `session`;

-- remove visa info
truncate table sprii_visa_payload;
truncate table sprii_checkout_cc;
truncate table sprii_checkout_customer;
truncate table sprii_visa_customer_promo;
truncate table sprii_loyalty;

-- remove sms info
truncate table sprii_sms;
truncate table sprii_sms_history;
truncate table sprii_sms_rules;


SET FOREIGN_KEY_CHECKS=1;

-- todo: create better email pattern (maybe on sprii-test.com domain?)
-- ideally would be add mail catcher to stack as well

SET @emaildomain  = '@sprii.com';

update customer_entity set email=concat('technical+customer-',entity_id, @emaildomain) where email not like "%@sprii.com%";
-- customer grid
update customer_grid_flat set email=concat('technical+customer-', entity_id, @emaildomain) where email not like "%@sprii.com%";

-- remove emails from quotes
update quote set customer_email =  (select email from customer_entity where customer_entity.entity_id=quote.customer_id) where customer_id > 0;
update quote set customer_email =  concat('technical+quote-', entity_id, @emaildomain) where customer_id is NULL;

-- remove emails from orders
update sales_order set customer_email = (select email from customer_entity where customer_entity.entity_id=sales_order.customer_id) where customer_id > 0;
update sales_order set customer_email = concat('technical+order-', entity_id, @emaildomain) where customer_id is NULL;

-- refresh order grid
update sales_order_grid set customer_email = (select email from customer_entity where customer_entity.entity_id=sales_order_grid.customer_id) where customer_id > 0;
update sales_order_grid set customer_email = concat('technical+order-', entity_id, @emaildomain) where customer_id is NULL;

-- update shipment grid
update sales_shipment_grid set customer_email = (select customer_email from sales_order where sales_order.entity_id=sales_shipment_grid.order_id);

-- update sales order addresses
update sales_order_address set email = (select email from customer_entity where customer_entity.entity_id=sales_order_address.customer_id) where customer_id > 0;
update sales_order_address set email = concat('technical+order-', parent_id, @emaildomain) where customer_id is NULL;

-- remove emails from product request
update miniexchange_productrequest_item set email= concat('technical+product-request-', request_id, @emaildomain) ;

-- update marketplace warehouses
update marketplace_warehouses set email = concat('technical+warehouse-', warehouse_id, @emaildomain);

-- update newsletter subscribers
update newsletter_subscriber set subscriber_email = (select email from customer_entity where customer_entity.entity_id=newsletter_subscriber.customer_id) where customer_id > 0;
update newsletter_subscriber set subscriber_email = concat('technical+newsletter-', subscriber_id, @emaildomain) where customer_id is NULL or customer_id = 0;


-- update all indexes state with status valid
update indexer_state set `status`='valid';

-- Update admin passwords
SET FOREIGN_KEY_CHECKS=0;
truncate table admin_user_session;
truncate table admin_passwords;
SET FOREIGN_KEY_CHECKS=1;
-- Disable admin password lifetime
UPDATE core_config_data set `value`= 0 where path ='admin/security/password_lifetime';
-- update admin passwords to 1password
update admin_user set password='a5ec80364e779062f5ff4b249f0fa923465ce7bdb4908c6e1b821a391fb14f4d:JcWvsqZm5rYnDR8Hai4WELQrhTQyk47v:1';
update admin_passwords set password_hash='a5ec80364e779062f5ff4b249f0fa923465ce7bdb4908c6e1b821a391fb14f4d:JcWvsqZm5rYnDR8Hai4WELQrhTQyk47v:1';

-- remove customer passwords - so everyone can log in to other accounts
UPDATE `customer_entity` SET `password_hash` = CONCAT(SHA2('xxxxxxxx1password', 256), ':xxxxxxxx:1') WHERE 1;


UPDATE marketplace_warehouses SET fetchr_pickup_address_id='ADDR12182_1463'
