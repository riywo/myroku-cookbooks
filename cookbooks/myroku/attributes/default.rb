default['myroku']['username'] = 'myroku'
default['myroku']['ruby_version'] = '1.9.3-p327'
default['myroku']['mysql_db'] = 'myroku_admin'
default['myroku']['mysql_user'] = {
  'user'     => 'myroku',
  'host'     => '%',
  'password' => 'myrokupass',
  'database' => 'myroku_%',
}
