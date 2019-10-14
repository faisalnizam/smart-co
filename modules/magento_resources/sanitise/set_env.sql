USE magento;

-- get store ids & website ids useful for configuration
select @store_ae_en:=store_id from store where code="ae_en";
select @store_ae_ar:=store_id from store where code="ae_ar";
select @store_sa_ar:=store_id from store where code="sa_ar";
select @store_sa_en:=store_id from store where code="sa_en";
select @store_bh_en:=store_id from store where code="bh_en";
select @store_bh_ar:=store_id from store where code="bh_ar";
select @store_kw_en:=store_id from store where code="kw_en";
select @store_kw_ar:=store_id from store where code="kw_ar";
select @store_om_en:=store_id from store where code="om_en";
select @store_om_ar:=store_id from store where code="om_ar";
select @store_qa_en:=store_id from store where code="qa_en";
select @store_qa_ar:=store_id from store where code="qa_ar";

select @website_ae:=website_id from store_website where code="ae";
select @website_sa:=website_id from store_website where code="sa";
select @website_bh:=website_id from store_website where code="bh";
select @website_kw:=website_id from store_website where code="kw";
select @website_om:=website_id from store_website where code="om";
select @website_qa:=website_id from store_website where code="qa";

-- update magento configuration:
insert into `core_config_data`(`scope`,`scope_id`,`path`,`value`) values
  ('default',0,'web/unsecure/base_url', 'https://{{ENVIRONMENT_NAME}}-admin.sprii-test.com/'),
  ('default',0,'web/secure/base_url','{{unsecure_base_url}}'),
  ('default',0,'web/unsecure/base_link_url','{{unsecure_base_url}}'),
  ('default',0,'web/secure/base_link_url','{{unsecure_base_url}}'),
  ('default',0,'web/unsecure/base_static_url','https://{{ENVIRONMENT_NAME}}-static.sprii-test.com/static/'),
  ('default',0,'web/unsecure/base_media_url','https://{{ENVIRONMENT_NAME}}-media.sprii-test.com/media/'),
  ('default',0,'web/secure/base_static_url','https://{{ENVIRONMENT_NAME}}-static.sprii-test.com/static/'),
  ('default',0,'web/secure/base_media_url','https://{{ENVIRONMENT_NAME}}-media.sprii-test.com/media/'),
  ('websites',@website_ae,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-ae.sprii-test.com/'),
  ('websites',@website_sa,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-sa.sprii-test.com/'),
  ('websites',@website_bh,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-bh.sprii-test.com/'),
  ('websites',@website_kw,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-kw.sprii-test.com/'),
  ('websites',@website_qa,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-qa.sprii-test.com/'),
  ('websites',@website_om,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-om.sprii-test.com/'),
  ('stores',@store_ae_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-ae.sprii-test.com/en/'),
  ('stores',@store_ae_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-ae.sprii-test.com/ar/'),
  ('stores',@store_sa_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-sa.sprii-test.com/en/'),
  ('stores',@store_sa_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-sa.sprii-test.com/ar/'),
  ('stores',@store_bh_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-bh.sprii-test.com/en/'),
  ('stores',@store_bh_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-bh.sprii-test.com/ar/'),
  ('stores',@store_kw_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-kw.sprii-test.com/en/'),
  ('stores',@store_kw_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-kw.sprii-test.com/ar/'),
  ('stores',@store_qa_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-qa.sprii-test.com/en/'),
  ('stores',@store_qa_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-qa.sprii-test.com/ar/'),
  ('stores',@store_om_en,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-om.sprii-test.com/en/'),
  ('stores',@store_om_ar,'web/unsecure/base_url','https://{{ENVIRONMENT_NAME}}-om.sprii-test.com/ar/')
  ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- elastic search settings:
insert into `core_config_data`(`scope`,`scope_id`,`path`,`value`) values
  ('default',0,'smile_elasticsuite_core_base_settings/es_client/servers', 'search.internal.sprii-test.com:80'),
  ('default',0,'smile_elasticsuite_core_base_settings/indices_settings/alias', 'magento2')
  ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- google analytics
insert into `core_config_data`(`scope`,`scope_id`,`path`,`value`) values
  ('default',0,'google/analytics/account', ''),
  ('default',0,'google/analytics/active', 0)
  ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- google tag manager
insert into `core_config_data`(`scope`,`scope_id`,`path`,`value`) values
  ('default',0,'weltpixel_googletagmanager/api/account_id', ''),
  ('default',0,'weltpixel_googletagmanager/api/container_id', ''),
  ('default',0,'weltpixel_googletagmanager/general/gtm_code', '')
  ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);

-- update product images:
update catalog_product_entity_media_gallery set value = concat('p/r/product', MOD(value_id,100),'.jpg');
update catalog_product_entity_varchar set value = concat('p/r/product', MOD(value_id, 100),'.jpg') where attribute_id in (85,86,87);

-- update links on cms pages:
update cms_page set content=replace(content, 'www.sprii.ae', '{{ENVIRONMENT_NAME}}-ae.sprii-test.com');
update cms_page set content=replace(content, 'sa.sprii.com', '{{ENVIRONMENT_NAME}}-sa.sprii-test.com');
update cms_page set content=replace(content, 'bh.sprii.com', '{{ENVIRONMENT_NAME}}-bh.sprii-test.com');
update cms_page set content=replace(content, 'kw.sprii.com', '{{ENVIRONMENT_NAME}}-kw.sprii-test.com');
update cms_page set content=replace(content, 'qa.sprii.com', '{{ENVIRONMENT_NAME}}-qa.sprii-test.com');
update cms_page set content=replace(content, 'om.sprii.com', '{{ENVIRONMENT_NAME}}-om.sprii-test.com');

-- update cache warmer:
update mst_cache_warmer_page set uri=replace(uri, 'www.sprii.ae', '{{ENVIRONMENT_NAME}}-ae.sprii-test.com');
update mst_cache_warmer_page set uri=replace(uri, 'sa.sprii.com', '{{ENVIRONMENT_NAME}}-sa.sprii-test.com');
update mst_cache_warmer_page set uri=replace(uri, 'bh.sprii.com', '{{ENVIRONMENT_NAME}}-bh.sprii-test.com');
update mst_cache_warmer_page set uri=replace(uri, 'kw.sprii.com', '{{ENVIRONMENT_NAME}}-kw.sprii-test.com');
update mst_cache_warmer_page set uri=replace(uri, 'qa.sprii.com', '{{ENVIRONMENT_NAME}}-qa.sprii-test.com');
update mst_cache_warmer_page set uri=replace(uri, 'om.sprii.com', '{{ENVIRONMENT_NAME}}-om.sprii-test.com');

-- checkout.com settings:
insert into `core_config_data`(`scope`,`scope_id`,`path`,`value`) values
  ('default',0,'spriicheckout/mode', 'sandbox')
  ON DUPLICATE KEY UPDATE `value`=VALUES(`value`);
