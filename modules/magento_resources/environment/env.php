<?php
return array (
  'backend' => 
  array (
    'frontName' => 'admin_1g3v9v',
  ),
  'crypt' => 
  array (
    'key' => '0335336012990dfa610f531d14a8bf83',
  ),
  'db' => 
  array (
    'table_prefix' => '',
    'connection' => 
    array (
      'default' => 
      array (
        'host' => 'db-restored.internal.sprii.com',
        'dbname' => 'magento',
        'username' => 'magento',
        'password' => 'UPLARDhjGAWvd3KB9JrV7A',
        'model' => 'mysql4',
        'engine' => 'innodb',
        'initStatements' => 'SET NAMES utf8;',
        'active' => '1',
      ),
    ),
  ),
  'session' => 
  array (
    'save' => 'redis',
    'redis' => 
    array (
      'host' => 'redissession.nwoalm.0001.euw1.cache.amazonaws.com',
      'port' => '6379',
      'password' => '',
      'timeout' => '2.5',
      'persistent_identifier' => '',
      'database' => '0',
      'compression_threshold' => '2048',
      'compression_library' => 'gzip',
      'log_level' => '1',
      'max_concurrency' => '6',
      'break_after_frontend' => '5',
      'break_after_adminhtml' => '30',
      'first_lifetime' => '600',
      'bot_first_lifetime' => '60',
      'bot_lifetime' => '7200',
      'disable_locking' => '0',
      'min_lifetime' => '60',
      'max_lifetime' => '2592000',
    ),
  ),
  'resource' => 
  array (
    'default_setup' => 
    array (
      'connection' => 'default',
    ),
  ),
  'x-frame-options' => 'SAMEORIGIN',
  'MAGE_MODE' => 'developer',
  'cache_types' => 
  array (
    'config' => 1,
    'layout' => 1,
    'block_html' => 1,
    'collections' => 1,
    'reflection' => 1,
    'db_ddl' => 1,
    'eav' => 1,
    'customer_notification' => 1,
    'full_page' => 1,
    'config_integration' => 1,
    'config_integration_api' => 1,
    'translate' => 1,
    'config_webservice' => 1,
    'compiled_config' => 1,
  ),
  'install' => 
  array (
    'date' => 'Sat, 10 Feb 2018 14:19:09 +0000',
  ),
  'http_cache_hosts' => 
  array (
  ),
);
