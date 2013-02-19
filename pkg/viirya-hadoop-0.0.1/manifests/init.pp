# /etc/puppet/modules/hadoop/manafests/init.pp

class hadoop {

	require hadoop::params
	
	group { "${hadoop::params::hadoop_group}":
		ensure => present,
		gid => "800"
	}

	user { "${hadoop::params::hadoop_user}":
		ensure => present,
		comment => "Hadoop",
		password => "!!",
		uid => "800",
		gid => "800",
		shell => "/bin/bash",
		home => "${hadoop::params::hadoop_user_path}",
		require => Group["hadoop"],
	}
	
	file { "${hadoop::params::hadoop_user_path}/.bash_profile":
		ensure => present,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "${hadoop::params::hadoop_user}-bash_profile",
		content => template("hadoop/home/bash_profile.erb"),
		require => User["${hadoop::params::hadoop_user}"]
	}
		
	file { "${hadoop::params::hadoop_user_path}":
		ensure => "directory",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "${hadoop::params::hadoop_user}-home",
		require => [ User["${hadoop::params::hadoop_user}"], Group["hadoop"] ]
	}
 
	file {"${hadoop::params::hadoop_tmp_path}":
		ensure => "directory",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "hadoop-tmp-dir",
		require => File["${hadoop::params::hadoop_user}-home"]
	}
 
	file {"${hadoop::params::hdfs_path}":
		ensure => "directory",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "hdfs-dir",
		require => File["${hadoop::params::hadoop_user}-home"]
	}
	
	file {"${hadoop::params::hadoop_base}":
		ensure => "directory",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "hadoop-base",
	}

 	file {"${hadoop::params::hadoop_conf}":
		ensure => "directory",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "hadoop-conf",
        require => [File["hadoop-base"], Exec["untar-hadoop"]],
        before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["yarn-site-xml"], File["yarn-env-sh"], File["hadoop-env-sh"], File["capacity-scheduler-xml"]]
	}
 
# file {"${hadoop::params::yarn_conf}":
# 	ensure => "directory",
# 	owner => "${hadoop::params::hadoop_user}",
# 	group => "${hadoop::params::hadoop_group}",
# 	alias => "yarn-conf",
#     require => [File["hadoop-base"], Exec["untar-hadoop"]],
# }
    
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}.tar.gz":
		mode => 0644,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		source => "puppet:///modules/hadoop/hadoop-${hadoop::params::version}.tar.gz",
		alias => "hadoop-source-tgz",
		before => Exec["untar-hadoop"],
		require => File["hadoop-base"]
	}
	
	exec { "untar hadoop-${hadoop::params::version}.tar.gz":
		command => "tar xfvz hadoop-${hadoop::params::version}.tar.gz",
		cwd => "${hadoop::params::hadoop_base}",
		creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
		alias => "untar-hadoop",
		refreshonly => true,
		subscribe => File["hadoop-source-tgz"],
		user => "${hadoop::params::hadoop_user}",
		before => [ File["hadoop-symlink"], File["hadoop-app-dir"]],
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
	}

	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}":
		ensure => "directory",
		mode => 0644,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		alias => "hadoop-app-dir",
        require => Exec["untar-hadoop"],
	}
		
	file { "${hadoop::params::hadoop_base}/hadoop":
		force => true,
		ensure => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
		alias => "hadoop-symlink",
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		require => File["hadoop-source-tgz"],
		before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["yarn-site-xml"], File["yarn-env-sh"], File["hadoop-env-sh"], File["capacity-scheduler-xml"]]
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/core-site.xml":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "core-site-xml",
		content => template("hadoop/conf/core-site.xml.erb"),
	}

 	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/capacity-scheduler.xml":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "capacity-scheduler-xml",
		content => template("hadoop/conf/capacity-scheduler.xml.erb"),
	}
 
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hdfs-site.xml":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop/conf/hdfs-site.xml.erb"),
	}
 
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/yarn-env.sh":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "yarn-env-sh",
		content => template("hadoop/conf/yarn-env.sh.erb"),
	}
    
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hadoop-env.sh":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "hadoop-env-sh",
		content => template("hadoop/conf/hadoop-env.sh.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/mapred-site.xml":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "mapred-site-xml",
		content => template("hadoop/conf/mapred-site.xml.erb"),		
	}
 
	file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/yarn-site.xml":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		alias => "yarn-site-xml",
		content => template("hadoop/conf/yarn-site.xml.erb"),		
	}

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/masters":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        alias => "hadoop-master",
        content => template("hadoop/conf/masters.erb"),
    }

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/slaves":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        alias => "hadoop-slave",
        content => template("hadoop/conf/slaves.erb"),
    }
    
	file { "${hadoop::params::hadoop_user_path}/.ssh/":
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "700",
		ensure => "directory",
		alias => "${hadoop::params::hadoop_user}-ssh-dir",
	}
	
	file { "${hadoop::params::hadoop_user_path}/.ssh/id_rsa.pub":
		ensure => present,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["${hadoop::params::hadoop_user}-ssh-dir"],
	}
	
	file { "${hadoop::params::hadoop_user_path}/.ssh/id_rsa":
		ensure => present,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "600",
		source => "puppet:///modules/hadoop/ssh/id_rsa",
		require => File["${hadoop::params::hadoop_user}-ssh-dir"],
	}
 
	file { "${hadoop::params::hadoop_user_path}/.ssh/config":
		ensure => present,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "600",
		source => "puppet:///modules/hadoop/ssh/config",
		require => File["${hadoop::params::hadoop_user}-ssh-dir"],
	}
    
	file { "${hadoop::params::hadoop_user_path}/.ssh/authorized_keys":
		ensure => present,
		owner => "${hadoop::params::hadoop_user}",
		group => "${hadoop::params::hadoop_group}",
		mode => "644",
		source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
		require => File["${hadoop::params::hadoop_user}-ssh-dir"],
	}	
}
