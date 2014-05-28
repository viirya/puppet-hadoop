# /etc/puppet/modules/hadoop/manafests/init.pp

class hadoop::params {

    include java::params

    $version = $::hostname ? {
        default            => "2.2.0",
    }

    $download_url = $::hostname ? {
        default            => "http://ftp.tc.edu.tw/pub/Apache/hadoop/common/hadoop-${version}",
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
        default            => "vm1.openstacklocal",
    }

    $dfs_slaves = $::hostname ? {
        default            => ["vm3.openstacklocal", "vm4.openstacklocal"],
    }

    $yarn_slaves = $::hostname ? {
        default            => ["vm1.openstacklocal", "vm3.openstacklocal", "vm4.openstacklocal"],
    }

    $slaves = $::hostname ? {
        default            => unique(flatten([$dfs_slaves, $yarn_slaves])),
    }
 
    $resourcemanager = $::hostname ? {
        default            => "vm2.openstacklocal",
    }
        
    $resource_tracker_port = $::hostname ? {
        default            => "8031",
    }

    $jobhistory_addr = $resourcemanager

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
        default            => "/data/hadoop",
    }
 
    $mapred_log_dir = $::hostname ? {
        default            => "${hadoop_base}/hadoop/logs",
    }
 
    $hadoop_log_dir = $::hostname ? {
        default            => "${hadoop_base}/hadoop/hadoop_log",
    }

    $yarn_log_dir = $::hostname ? {
        default            => "${hadoop_base}/hadoop/yarn_log",
    }

    $kerberos_mode = $::hostname ? {
        default            => "yes",
    }

    $keytab_path = $::hostname ? {
        default            => "/etc/security/keytab",
    }

    $kerberos_realm = $::hostname ? {
        default            => "OPENSTACKLOCAL",
    }
 
    $common_base = $::hostname ? {
        default            => "/opt/jsvc",
    }
 
    $common_version = $::hostname ? {
        default            => "1.0.15",
    }

    if $kerberos_mode == "yes" {
        $hadoop_path_owner = "root"
    } elsif $kerberos_mode == "no" {
        $hadoop_path_owner = "${hadoop_user}"
    }

    $qjm_ha_mode = $::hostname ? {
        default            => "yes",
    }

    if $qjm_ha_mode == "yes" {

        $dfs_nameservices = "mycluster"
        $standby_master = "vm2.openstacklocal"
        $journalnodes = unique(flatten(["vm2.openstacklocal",  $yarn_slaves]))
        $journal_data_dir = "/tmp/journaldata"
        $journal_master = $dfs_slaves[0]

        $zookeeper_quorum = $::hostname ? {
            default         => unique(flatten(["vm2.openstacklocal",  $yarn_slaves])),
        }

        $zk_auth_text = "digest:hdfs-zkfcs:mypassword"
        # obtain following acl text by running:
        # java -cp $ZK_HOME/lib/*:$ZK_HOME/zookeeper-3.4.2.jar org.apache.zookeeper.server.auth.DigestAuthenticationProvider hdfs-zkfcs:mypassword
        $zk_acl_text = "digest:hdfs-zkfcs:P/OQvnYyU/nF/mGYvB/xurX8dYs=:rwcda"

    } elsif $qjm_ha_mode == "no" {

        $dfs_nameservices = undef
        $standby_master = undef
        $journalnodes = under
        $journal_data_dir = undef
        $journal_master = undef

        $zookeeper_quorum = undef
        $zk_auth_text = undef
        $zk_acl_text = undef

    }
 
    $yarn_nodemanager_localdirs = $::hostname ? {
        default            => "${yarn_user_path}/nm-local-dir",
    }

    $yarn_nodemanager_logdirs = $::hostname ? {
        default            => "${yarn_user_path}/userlogs",
    }

}
