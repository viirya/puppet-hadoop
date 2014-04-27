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

    user { "${hadoop::params::hdfs_user}":
        ensure => present,
        comment => "Hadoop",
        password => "!!",
        uid => "801",
        gid => "800",
        shell => "/bin/bash",
        home => "${hadoop::params::hdfs_user_path}",
        require => Group["hadoop"],
    }

    user { "${hadoop::params::yarn_user}":
        ensure => present,
        comment => "Hadoop",
        password => "!!",
        uid => "802",
        gid => "800",
        shell => "/bin/bash",
        home => "${hadoop::params::yarn_user_path}",
        require => Group["hadoop"],
    }
 
    user { "${hadoop::params::mapred_user}":
        ensure => present,
        comment => "Hadoop",
        password => "!!",
        uid => "803",
        gid => "800",
        shell => "/bin/bash",
        home => "${hadoop::params::mapred_user_path}",
        require => Group["hadoop"],
    }
 
    file { "/etc/profile.d/hadoop.sh":
        ensure => present,
        owner => "root",
        group => "root",
        alias => "profile-hadoop",
        content => template("hadoop/home/bash_profile.erb"),
    }
     
    file { "${hadoop::params::hadoop_user_path}/.bashrc":
        ensure => present,
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::hadoop_user}-bashrc",
        content => template("hadoop/home/bashrc.erb"),
        require => User["${hadoop::params::hadoop_user}"]
    }
    
    file { "${hadoop::params::hdfs_user_path}/.bashrc":
        ensure => present,
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::hdfs_user}-bashrc",
        content => template("hadoop/home/bashrc.erb"),
        require => User["${hadoop::params::hdfs_user}"]
    }
    
    file { "${hadoop::params::yarn_user_path}/.bashrc":
        ensure => present,
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::yarn_user}-bashrc",
        content => template("hadoop/home/bashrc.erb"),
        require => User["${hadoop::params::yarn_user}"]
    }
    
    file { "${hadoop::params::mapred_user_path}/.bashrc":
        ensure => present,
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::mapred_user}-bashrc",
        content => template("hadoop/home/bashrc.erb"),
        require => User["${hadoop::params::mapred_user}"]
    }
        
    file { "${hadoop::params::hadoop_user_path}":
        ensure => "directory",
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::hadoop_user}-home",
        require => [ User["${hadoop::params::hadoop_user}"], Group["hadoop"] ]
    }
 
    file { "${hadoop::params::hdfs_user_path}":
        ensure => "directory",
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::hdfs_user}-home",
        require => [ User["${hadoop::params::hdfs_user}"], Group["hadoop"] ]
    }
 
    file { "${hadoop::params::yarn_user_path}":
        ensure => "directory",
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::yarn_user}-home",
        require => [ User["${hadoop::params::yarn_user}"], Group["hadoop"] ]
    }
 
    file { "${hadoop::params::mapred_user_path}":
        ensure => "directory",
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "${hadoop::params::mapred_user}-home",
        require => [ User["${hadoop::params::mapred_user}"], Group["hadoop"] ]
    }
 
    file {"${hadoop::params::hadoop_tmp_path}":
        ensure => "directory",
        mode => "g=rwx,o=r",
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "hadoop-tmp-dir",
        require => File["${hadoop::params::hadoop_user}-home"]
    }
 
    file {"${hadoop::params::hadoop_log_dir}":
        ensure => "directory",
        mode => "g=rwx,o=r",
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "hadoop-log-dir",
        require => [ File["hadoop-base"], Exec["untar-hadoop"], File["hadoop-symlink"] ],
    }
 
    file {"${hadoop::params::yarn_log_dir}":
        ensure => "directory",
        mode => "g=rwx,o=r",
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "yarn-log-dir",
        require => [ File["hadoop-base"], Exec["untar-hadoop"], File["hadoop-symlink"] ],
    }
 
    #file {"${hadoop::params::yarn_nodemanager_localdirs}":
    #    ensure => "directory",
    #    owner => "${hadoop::params::yarn_user}",
    #    group => "${hadoop::params::hadoop_group}",
    #    alias => "hadoop-tmp-dir",
    #    require => File["${hadoop::params::yarn_user}-home"]
    #}
    #
    #file {"${hadoop::params::yarn_nodemanager_logdirs}":
    #    ensure => "directory",
    #    owner => "${hadoop::params::yarn_user}",
    #    group => "${hadoop::params::hadoop_group}",
    #    alias => "hadoop-tmp-dir",
    #    require => File["${hadoop::params::yarn_user}-home"]
    #}
 
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
        require => [File["hadoop-base"], Exec["untar-hadoop"], File["hadoop-symlink"]],
        before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["yarn-site-xml"], File["yarn-env-sh"], File["hadoop-env-sh"], File["capacity-scheduler-xml"], File["hadoop-master"], File["hadoop-slave"] ]
    }
 
    exec { "download hadoop-${hadoop::params::version}.tar.gz":
        command => "wget http://apache.stu.edu.tw/hadoop/common/hadoop-${hadoop::params::version}/hadoop-${hadoop::params::version}.tar.gz",
        cwd => "${hadoop::params::hadoop_base}",
        alias => "download-hadoop",
        user => "${hadoop::params::hadoop_user}",
        require => File["hadoop-base"],
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        #onlyif => "test -d ${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
        creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}.tar.gz",
        before => [Exec["untar-hadoop"], File["hadoop-symlink"], File["hadoop-app-dir"]],
    }

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}.tar.gz":
        mode => 0664,
        ensure => present,
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        alias => "hadoop-source-tgz",
        before => Exec["untar-hadoop"],        
        require => [File["hadoop-base"], Exec["download-hadoop"]],
    }

    exec { "untar hadoop-${hadoop::params::version}.tar.gz":
        command => "tar xfvz hadoop-${hadoop::params::version}.tar.gz",
        cwd => "${hadoop::params::hadoop_base}",
        creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}",
        alias => "untar-hadoop",
        onlyif => "test 0 -eq $(ls -al ${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version} | grep -c bin)",
        user => "${hadoop::params::hadoop_user}",
        before => [ File["hadoop-symlink"], File["hadoop-app-dir"] ],
        path    => ["/bin", "/usr/bin", "/usr/sbin"],
        require => File["hadoop-source-tgz"]
    }

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}":
        ensure => "directory",
        mode => 0664,
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
        require => [Exec["untar-hadoop"], File["hadoop-app-dir"]],
        before => [ File["core-site-xml"], File["hdfs-site-xml"], File["mapred-site-xml"], File["yarn-site-xml"], File["yarn-env-sh"], File["hadoop-env-sh"], File["capacity-scheduler-xml"], File["hadoop-master"], File["hadoop-slave"] ]
    }
    
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/core-site.xml":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "core-site-xml",
        content => template("hadoop/conf/core-site.xml.erb"),
    }

     file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/capacity-scheduler.xml":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "capacity-scheduler-xml",
        content => template("hadoop/conf/capacity-scheduler.xml.erb"),
    }
 
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hdfs-site.xml":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "hdfs-site-xml",
        content => template("hadoop/conf/hdfs-site.xml.erb"),
    }
 
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/yarn-env.sh":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "yarn-env-sh",
        content => template("hadoop/conf/yarn-env.sh.erb"),
    }
    
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/hadoop-env.sh":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "hadoop-env-sh",
        content => template("hadoop/conf/hadoop-env.sh.erb"),
    }
    
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/mapred-site.xml":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "mapred-site-xml",
        content => template("hadoop/conf/mapred-site.xml.erb"),        
    }
 
    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/yarn-site.xml":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "yarn-site-xml",
        content => template("hadoop/conf/yarn-site.xml.erb"),        
    }

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/masters":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
        alias => "hadoop-master",
        content => template("hadoop/conf/masters.erb"),
    }

    file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/conf/slaves":
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "664",
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
 
    file { "${hadoop::params::hdfs_user_path}/.ssh/":
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "700",
        ensure => "directory",
        alias => "${hadoop::params::hdfs_user}-ssh-dir",
    }
 
    file { "${hadoop::params::yarn_user_path}/.ssh/":
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "700",
        ensure => "directory",
        alias => "${hadoop::params::yarn_user}-ssh-dir",
    }
 
    file { "${hadoop::params::mapred_user_path}/.ssh/":
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "700",
        ensure => "directory",
        alias => "${hadoop::params::mapred_user}-ssh-dir",
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
 
    file { "${hadoop::params::hdfs_user_path}/.ssh/id_rsa.pub":
        ensure => present,
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::hdfs_user}-ssh-dir"],
    }
    
    file { "${hadoop::params::hdfs_user_path}/.ssh/id_rsa":
        ensure => present,
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/id_rsa",
        require => File["${hadoop::params::hdfs_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::yarn_user_path}/.ssh/id_rsa.pub":
        ensure => present,
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::yarn_user}-ssh-dir"],
    }
    
    file { "${hadoop::params::yarn_user_path}/.ssh/id_rsa":
        ensure => present,
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/id_rsa",
        require => File["${hadoop::params::yarn_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::mapred_user_path}/.ssh/id_rsa.pub":
        ensure => present,
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::mapred_user}-ssh-dir"],
    }
    
    file { "${hadoop::params::mapred_user_path}/.ssh/id_rsa":
        ensure => present,
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/id_rsa",
        require => File["${hadoop::params::mapred_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::hadoop_user_path}/.ssh/config":
        ensure => present,
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/config",
        require => File["${hadoop::params::hadoop_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::hdfs_user_path}/.ssh/config":
        ensure => present,
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/config",
        require => File["${hadoop::params::hdfs_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::yarn_user_path}/.ssh/config":
        ensure => present,
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/config",
        require => File["${hadoop::params::yarn_user}-ssh-dir"],
    }
 
    file { "${hadoop::params::mapred_user_path}/.ssh/config":
        ensure => present,
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "600",
        source => "puppet:///modules/hadoop/ssh/config",
        require => File["${hadoop::params::mapred_user}-ssh-dir"],
    }
    
    file { "${hadoop::params::hadoop_user_path}/.ssh/authorized_keys":
        ensure => present,
        owner => "${hadoop::params::hadoop_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::hadoop_user}-ssh-dir"],
    }    

    file { "${hadoop::params::hdfs_user_path}/.ssh/authorized_keys":
        ensure => present,
        owner => "${hadoop::params::hdfs_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::hdfs_user}-ssh-dir"],
    }    

    file { "${hadoop::params::yarn_user_path}/.ssh/authorized_keys":
        ensure => present,
        owner => "${hadoop::params::yarn_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::yarn_user}-ssh-dir"],
    }    

    file { "${hadoop::params::mapred_user_path}/.ssh/authorized_keys":
        ensure => present,
        owner => "${hadoop::params::mapred_user}",
        group => "${hadoop::params::hadoop_group}",
        mode => "644",
        source => "puppet:///modules/hadoop/ssh/id_rsa.pub",
        require => File["${hadoop::params::mapred_user}-ssh-dir"],
    }

}
