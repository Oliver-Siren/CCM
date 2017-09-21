define lampstack::vhost () {
	
	file { "/etc/apache2/sites-available/${title}.com.conf":
		content => template("lampstack/vhost.conf.erb"),
		require => Package["apache2"],
        }

	file { "/etc/apache2/sites-enabled/${title}.com.conf":
		ensure => "link",
		target => "../sites-available/${title}.com.conf",
		require => Package["apache2"],
	}
}
