class nodejs ($version, $logoutput = "on_failure") {

    if !defined(Package["curl"]) {
        package { "curl" :
            ensure => present,
        }
    }

    package { "libssl-dev" :
        ensure => present,
    }
    package { "build-essential" :
        ensure => present,
    }

    package { "libexpat1" :
        ensure => present,
    }

    package { "libexpat1-dev" :
        ensure => present,
    }

    # Use nave, yo
    exec { "nave" :
        command     => "bash -c \"\$(curl -s 'https://raw.githubusercontent.com/isaacs/nave/master/nave.sh') usemain $version \"",
        path        => [ "/usr/local/bin", "/bin" , "/usr/bin" ],
        require     => [ Package[ "curl" ], Package[ "libssl-dev" ], Package[ "build-essential" ] ],
        environment => [ 'HOME=""', 'PREFIX=/usr/local/lib/node', 'NAVE_JOBS=1' ],
        logoutput   => $logoutput,
        # btw, this takes forever....
        timeout     => 0,
        unless      => "test \"v$version\" = \"\$(node -v)\"",
    }

    exec { "less" :
        command     => "npm install -g less",
        require     => [ Exec["nave"] ],
        logoutput   => $logoutput,
        unless      => "npm list -p -l -g | grep less",
    }
}
