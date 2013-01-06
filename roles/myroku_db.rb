name "myroku_db"
description "myroku db"
run_list [
  "recipe[myroku::base]",
  "recipe[redisio::install]",
  "recipe[redisio::enable]",
  "recipe[mysql::server]",
  "recipe[myroku::db]",
]
override_attributes "mysql" => { "bind_address" => '0.0.0.0' }
