# Tell Puppet where to find system commands.
Exec {
	path => [ "/usr/sbin", "/usr/bin", "/sbin", "/bin", "/usr/local/bin" ]
}

exec { "import-key":
	command => "apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10",
	timeout => 0
}

exec { "mongo-list-file":
	command => 'echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list',
	timeout => 0,
	require => Exec["import-key"]
}

exec { "apt-get update":
	require => [ Exec["import-key"], Exec["mongo-list-file"] ]
}

package { "mongodb-org=3.0.7":
	ensure  => present,
	require => [ Exec["import-key"], Exec["mongo-list-file"], Exec["apt-get update"] ],
}

service { "mongod":
	ensure     => running,
	enable     => true,
	hasrestart => true,
	require    => Package["mongodb-org=3.0.7"],
}
