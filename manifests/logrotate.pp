# == Class consul_template::logrotate
#
class consul_template::logrotate (
  $logrotate_compress        = $consul_template::logrotate_compress,
  $logrotate_files           = $consul_template::logrotate_files,
  $logrotate_on              = $consul_template::logrotate_on,
  $logrotate_period          = $consul_template::logrotate_period,
  String $postrotate_command = '/bin/systemctl restart consul-template.service',
) {
  if $logrotate_on {
    file { '/etc/logrotate.d/consul-template':
      ensure  => file,
      content => template("${module_name}/consul-template.logrotate.erb"),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }
}
