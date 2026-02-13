# == Class consul_template::params
#
# This class is meant to be called from consul_template.
# It sets variables according to platform.
#
class consul_template::params {
  $os = downcase($facts['kernel'])

  case $facts['os']['architecture'] {
    'x86_64', 'amd64': {
      $arch = 'amd64'
    }

    'i386': {
      $arch = '386'
    }

    'aarch64': {
      $arch = 'arm64'
    }

    default:           {
      fail("Unsupported kernel architecture: ${facts['os']['architecture']}")
    }
  }
}
