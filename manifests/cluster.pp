# /etc/puppet/modules/hadoop/manifests/master.pp

class hadoop::cluster {
    # do nothing, magic lookup helper
}

class hadoop::cluster::pseudomode {

    require hadoop::params
    require hadoop

    exec { "Format namenode":
        command => "./hdfs namenode -format",
        user => "${hadoop::params::hdfs_user}",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin",
        creates => "${hadoop::params::hadoop_tmp_path}/dfs/name/current/VERSION",
        alias => "format-hdfs",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin"],
        require => File["hadoop-master"],
        before => Exec["start-dfs"],
    }

    exec { "Start DFS services":
        command => "./start-dfs.sh",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::hdfs_user}",
        alias => "start-dfs",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        before => [Exec["start-yarn"]],
        onlyif => "test 0 -eq $(${hadoop::params::java_home}/bin/jps | grep -c NameNode)",
    }
 
    exec { "Start YARN services":
        command => "./start-yarn.sh",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::yarn_user}",
        alias => "start-yarn",
        require => Exec["start-dfs"],
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        onlyif => "test 0 -eq $(${hadoop::params::java_home}/bin/jps | grep -c ResourceManager)",
        before => Exec["start-historyserver"],
    }
 
    exec { "Start historyserver":
        command => "./mr-jobhistory-daemon.sh start historyserver",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::mapred_user}",
        alias => "start-historyserver",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        require => Exec["start-yarn"],
        onlyif => "test 0 -eq $(${hadoop::params::java_home}/bin/jps | grep -c JobHistoryServer)",
    }
 
    exec { "Set /tmp mode":
        command => "./hdfs dfs -chmod -R 1777 /tmp; ./hdfs dfs -chown -R ${hadoop::params::hdfs_user} /tmp; touch ${hadoop::params::hdfs_user_path}/tmp_init_done",
        user => "${hadoop::params::hdfs_user}",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin",
        creates => "${hadoop::params::hdfs_user_path}/tmp_init_done",
        alias => "set-tmp",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin"],
        require => Exec["start-historyserver"],
    } 
 
}

class hadoop::cluster::master {

    require hadoop::params
    require hadoop

    exec { "Format namenode":
        command => "./hdfs namenode -format",
        user => "${hadoop::params::hdfs_user}",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin",
        creates => "${hadoop::params::hadoop_tmp_path}/dfs/name/current/VERSION",
        alias => "format-hdfs",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/bin"],
        before => [Exec["start-namenode"], Exec["start-datanodes"], Exec["start-resourcemanager"], Exec["start-nodemanager"], Exec["start-historyserver"]],
        require => File["hadoop-master"],
    }

    exec { "Start namenode":
        command => "./hadoop-daemon.sh start namenode",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::hdfs_user}",
        alias => "start-namenode",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        before => [Exec["start-datanodes"], Exec["start-resourcemanager"], Exec["start-nodemanager"], Exec["start-historyserver"]],
    }

    exec { "Start datanodes":
        command => "./hadoop-daemons.sh start datanode",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::hdfs_user}",
        alias => "start-datanodes",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        before => [Exec["start-resourcemanager"], Exec["start-nodemanager"], Exec["start-historyserver"]],
    }
    exec { "Start resourcemanager":
        command => "./yarn-daemon.sh start resourcemanager",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::yarn_user}",
        alias => "start-resourcemanager",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        before => [Exec["start-nodemanager"], Exec["start-historyserver"]],
    }
    exec { "Start nodemanager":
        command => "./yarn-daemons.sh start nodemanager",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::yarn_user}",
        alias => "start-nodemanager",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
        before => Exec["start-historyserver"],
    }

    exec { "Start historyserver":
        command => "./mr-jobhistory-daemon.sh start historyserver",
        cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
        user => "${hadoop::params::mapred_user}",
        alias => "start-historyserver",
        path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
    }
 
}

class hadoop::cluster::slave {

    require hadoop::params
    require hadoop

}
