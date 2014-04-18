# /etc/puppet/modules/hadoop/manafests/init.pp

class hadoop::params {

    include java::params

    $version = $::hostname ? {
        default            => "2.2.0",
    }

    $hadoop_user = $::hostname ? {
        default            => "hduser",
    }
 
    $hdfs_user = $::hostname ? {
        default            => "hdfs",
    }
 
    $yarn_user = $::hostname ? {
        default            => "yarn",
    }
 
    $mapred_user = $::hostname ? {
        default            => "mapred",
    }
 
    $hadoop_group = $::hostname ? {
        default            => "hadoop",
    }
        
    $master = $::hostname ? {
        default            => "localhost",
    }

    $slaves = $::hostname ? {
        default            => ["localhost"],
    }

    $resourcemanager = $::hostname ? {
        default            => "localhost",
    }
        
    $resource_tracker_port = $::hostname ? {
        default            => "8031",
    }

    $scheduler_port = $::hostname ? {
        default            => "8030",
    }

    $scheduler_class = $::hostname ? {
        default            => "org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler",
    }
 
    $resourcemanager_port = $::hostname ? {
        default            => "8032",
    }
 
    $hdfsport = $::hostname ? {
        default            => "8020",
    }

    $replication = $::hostname ? {
        default            => "1",
    }

    #$jobtrackerport = $::hostname ? {
    #    default            => "8021",
    #}

    $java_home = $::hostname ? {
        default            => "${java::params::java_base}/jdk${java::params::java_version}",
    }

    $hadoop_base = $::hostname ? {
        default            => "/opt/hadoop",
    }
 
    $hadoop_conf = $::hostname ? {
        default            => "${hadoop_base}/hadoop/conf",
    }
 
    $yarn_conf = $::hostname ? {
        default            => "${hadoop_base}/hadoop/conf",
    }
 
    $hadoop_user_path = $::hostname ? {
        default            => "/home/${hadoop_user}",
    }             

    $hdfs_user_path = $::hostname ? {
        default            => "/home/${hdfs_user}",
    }             

    $yarn_user_path = $::hostname ? {
        default            => "/home/${yarn_user}",
    }             

    $mapred_user_path = $::hostname ? {
        default            => "/home/${mapred_user}",
    }             

    #$hdfs_path = $::hostname ? {
    #    default            => "${hadoop_user_path}/hdfs",
    #}

    $hadoop_tmp_path = $::hostname ? {
        default            => "${hadoop_user_path}/tmp",
    }

    $hadoop_log_dir = $::hostname ? {
        default            => "${hadoop_base}/hadoop/hadoop_log",
    }

    $yarn_log_dir = $::hostname ? {
        default            => "${hadoop_base}/hadoop/yarn_log",
    }

    #$yarn_nodemanager_localdirs = $::hostname ? {
    #    default            => "${yarn_user_path}/nm-local-dir}",
    #}

    #$yarn_nodemanager_logdirs = $::hostname ? {
    #    default            => "${yarn_user_path}/userlogs}",
    #}

}
