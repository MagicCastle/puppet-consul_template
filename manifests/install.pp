# == Class consul_template::intall
#
class consul_template::install {
  if ! empty($consul_template::data_dir) {
    file { $consul_template::data_dir:
      ensure => 'directory',
      owner  => $consul_template::user,
      group  => $consul_template::group,
      mode   => '0755',
    }
  }

  if $consul_template::install_method == 'url' {
    include archive

    archive { "/tmp/consul-template-${consul_template::version}.zip":
      source       => $consul_template::_download_url,
      extract      => true,
      extract_path => $consul_template::bin_dir,
      creates      => "${consul_template::bin_dir}/consul-template",
      cleanup      => true,
    }
    -> file {
      "${consul_template::bin_dir}/consul-template":
        owner => 'root',
        group => 0, # 0 instead of root because OS X uses "wheel".
        mode  => '0555';
    }

  } elsif $consul_template::install_method == 'package' {
    package { $consul_template::package_name:
      ensure => $consul_template::package_ensure,
    }
  } else {
    fail("The provided install method ${consul_template::install_method} is invalid")
  }

  file { '/lib/systemd/system/consul-template.service':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('consul_template/consul-template.systemd.erb'),
  }

  if $consul_template::manage_user {
    user { $consul_template::user:
      ensure => 'present',
      system => true,
    }
  }
  if $consul_template::manage_group {
    group { $consul_template::group:
      ensure => 'present',
      system => true,
    }
  }
}
