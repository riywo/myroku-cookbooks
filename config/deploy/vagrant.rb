server '192.168.110.111', :admin, :proxy, :app, :db
set :user, 'vagrant'
set :password, 'vagrant'

set :deploy_via, :copy
set :repository, File.expand_path('../../../', __FILE__)
set :local_repository, '/vagrant'

namespace :chef do
  task :exam do
    set :chef_dir, "/vagrant"
    config
    attribute
    solo
  end
end

set :default_attribute, {
  :authorization => {
    :sudo => {
      :users => ["vagrant"],
    },
  },
  :mysql => {
    :server_root_password   => 'rootpass',
    :server_debian_password => 'debpass',
    :server_repl_password   => 'replpass',
  },
  :myroku => {
    :ssh => {
      :private_key => <<EOF,
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAvpltEarhGVcfIGXgOGfpkN7M/X4j81il6G96mlg6GW4CgFBy
m0/2C1VcO04SyOIXZzRBLYoKpfwynxyxwiOVNUKPjVuGiLxuCR6SShR5qRz4kqs7
cmXLy5BGgSkbFAwQrYO1ZjVQWE9XnjmgONiuIZwJlME4TmvT+JLNVNnmhbIosK4q
OsjPXVA5/Ibr71rszjIFZ7IR+WFtYjAvGXU8W1NI9Ipud/2Wvk0w6mFLoFtgRdPn
TW+U6C/SPQEx1gBSY64py6YMRw5Gv5wMAWntQ0C1ayNEvNMP+xtc98EIgANddWV9
5xM6qH9QJkehgD2xQ24ClUvnbSc40D0fX/7gSQIDAQABAoIBAQCbXBxXhl4tdaJd
mi0GTU1JVRLqneNX/C5gJF5faQMSr2VCilCg4LDB1DZ18NHHBOPmr+Vg5WCAo+3v
XEhY4wBAhZzVsIEc+9sFe/HqiH4SpxbHFuRB/0/7AgM2TPdRg/QkO3OleFehZCsb
QgWj0Js/shztMAJhiesidyb/vw30czeCd3uKEOwmw5AWxy6oky0bquMH8sUrf3ZS
UmGbAFYpB5spEBT00qh/yOEK3bfjShWMirNw2q5A9ElZMc9fff447ep+xUY+bwbB
XXk2PjFbD17ZripcLjp6jKoHVbhq3NzYJ2TnGrFub8EuUtvPTZ40hlTwMynjARVx
XS9s8I4BAoGBAOsEpx//HJdsmVq0J3Vo683TaLTTJ5bTUpdb9puE7hJB7gj8L4Th
KGECs80/rppI9UXalKSctNFYEmlbSNJPCl65qF1v6Pn8kbiTB/NzYZOuF3i054zx
O8r4305sNuJWLvJqxjPSnKBALLKHDKdpD+ukauGAC6Q6rAEVOs/roHjZAoGBAM+d
lDploZG1oycnmQBBJigDghvVSOFAESp5ReIbvFo5w2MfYvQlmrNCBhKfQplp8eDh
cOhtJjDAHuTSBmM9XW+sMCUgQjuLMcqI87xzKSZWnBGOx2azJdWxBTFbEBVA8PZC
jkgTC/bafJjqaRFZ5hK/D1oZJE3m9gLeyOBwBHzxAoGAdfOz3T8wnl8G6JsaYrby
Ai9kkbyYVf5hqU2ii5M/2TH1wdSwFMTcezPcAdtASnbrgs+dYrCzn43QT8hc2BCL
Z9dORPbxuuWkTTqd9vWlt3TcmtxQilBYbhpSGQ3+zcHrdgdYypGdwl/zDvbwxuTX
9LBkZCDbtuUrhq+dANWFiKECgYBG6rqhH+oKjZLHYx0+GwLflCMzQq18U5gJfBdE
3th9sVFuYGA6qUWoiZrtbX0gTjIS8K7SlcX/zQBAhQUtjN6HsLdZVyWIlUlSt2ka
K/QYZmk1DiJKkFMSJT9y1not6Frmo2FaeTcTARqiWR++j4ipSp4B1qix+3x5CoRv
NZQy4QKBgQCWR7fmnr/lAOi6TivYCzfu/Lmql0zG6QRtUuB0HHU1n3x/+XEfFPVC
EIaEaHU1t87WzQhIxi3vFHA1p9/RXiEYssfvOBeo5NqAIYpuhHBI+CzZYdYAZPaV
Dif8ijrJv2tURtnHo4FojFtNDDhT8fyNazOqoWQ30PcLd2ml5hICZg==
-----END RSA PRIVATE KEY-----
EOF
      :public_key  => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+mW0RquEZVx8gZeA4Z+mQ3sz9fiPzWKXob3qaWDoZbgKAUHKbT/YLVVw7ThLI4hdnNEEtigql/DKfHLHCI5U1Qo+NW4aIvG4JHpJKFHmpHPiSqztyZcvLkEaBKRsUDBCtg7VmNVBYT1eeOaA42K4hnAmUwThOa9P4ks1U2eaFsiiwrio6yM9dUDn8huvvWuzOMgVnshH5YW1iMC8ZdTxbU0j0im53/Za+TTDqYUugW2BF0+dNb5ToL9I9ATHWAFJjrinLpgxHDka/nAwBae1DQLVrI0S80w/7G1z3wQiAA111ZX3nEzqof1AmR6GAPbFDbgKVS+dtJzjQPR9f/uBJ created by vagrant',
    },
  },
}
