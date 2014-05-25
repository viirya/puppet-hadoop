# /etc/puppet/modules/hadoop/manifests/master.pp

define datanodeprinciple {
    exec { "create DataNode principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey dn/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-dn-${name}",
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.dn.service.keytab",
    }
}
 
define journalnodeprinciple {
    exec { "create JournalNode principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey hdfs/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-jn-${name}",
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.hdfs.service.keytab",
    }
}
 
define journalnode_internal_principle {
    exec { "create JournalNode Internal principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey HTTP/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        alias => "add-princ-HTTP-${name}",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        require => File["keytab-path"],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.hdfs.service.keytab",
    }
}
 
define webhdfs_principle {
    exec { "create WebHDFS principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey HTTP/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        alias => "add-princ-HTTP-${name}",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        require => File["keytab-path"],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.http.service.keytab",
    }
}
 
define nodemanagerprinciple {
    exec { "create NodeManager principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey nm/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-nm-${name}",
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.nm.service.keytab",
    }
}
 
define masterhostprinciple {
    exec { "create host principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-host-${name}",
        onlyif => "test (! -e ${hadoop::params::keytab_path}/nn.service.keytab) -a (! -e ${hadoop::params::keytab_path}/sn.service.keytab) -a (! -e ${hadoop::params::keytab_path}/rm.service.keytab) -a (! -e ${hadoop::params::keytab_path}/jhs.service.keytab)",
    }
}
 
define standbymasterhostprinciple {
    exec { "create host principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-host-${name}",
        onlyif => "test (! -e ${hadoop::params::keytab_path}/standby_nn.service.keytab) -a (! -e ${hadoop::params::keytab_path}/sn.service.keytab) -a (! -e ${hadoop::params::keytab_path}/rm.service.keytab) -a (! -e ${hadoop::params::keytab_path}/jhs.service.keytab)",
    }
} 
define hostprinciple {
    exec { "create host principle ${name}":
        command => "kadmin.local -q 'addprinc -randkey host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        alias => "add-princ-host-${name}",
        onlyif => "test (! -e ${hadoop::params::keytab_path}/${name}.dn.service.keytab) -a (! -e ${hadoop::params::keytab_path}/${name}.nm.service.keytab)",
    }
}
 
define datanodekeytab {
    exec { "create DataNode keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.dn.service.keytab dn/$name@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.dn.service.keytab host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.dn.service.keytab",
        alias => "create-keytab-dn-${name}",
        require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-dn-${name}"], Exec["add-princ-host-${name}"] ],
    }
}
 
define journalnodekeytab {
    exec { "create JournalNode keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.hdfs.service.keytab hdfs/$name@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.hdfs.service.keytab HTTP/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.hdfs.service.keytab",
        alias => "create-keytab-jn-${name}",
        require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-jn-${name}"], Exec["add-princ-host-${name}"], Exec["add-princ-HTTP-${name}"] ],
    }
}
 
define webhdfskeytab {
    exec { "create WebHDFS keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.http.service.keytab HTTP/$name@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.http.service.keytab host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        alias => "create-keytab-http-${name}",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${name}"], Exec["add-princ-HTTP-${name}"] ],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.http.service.keytab",
    }
}
 
define nodemanagerkeytab {
    exec { "create NodeManager keytab ${name}":
        command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.nm.service.keytab nm/$name@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/${name}.nm.service.keytab host/$name@${hadoop::params::kerberos_realm}'",
        user => "root",
        group => "root",
        path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
        onlyif => "test ! -e ${hadoop::params::keytab_path}/${name}.nm.service.keytab",
        alias => "create-keytab-nm-${name}",
        require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-nm-${name}"], Exec["add-princ-host-${name}"] ],

    }
}
 
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

class hadoop::cluster::kerberos {

    require hadoop::params
    require hadoop
 
    if $hadoop::params::kerberos_mode == "yes" {

        file { "${hadoop::params::keytab_path}":
            ensure => "directory",
            owner => "root",
            group => "${hadoop::params::hadoop_group}",
            mode => "750",
            alias => "keytab-path",
            require => [ File["hadoop-master"], File["hadoop-slave"] ],
        }

        exec { "create NameNode principle":
            command => "kadmin.local -q 'addprinc -randkey nn/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "add-princ-nn",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => File["keytab-path"],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/nn.service.keytab",  
        }

        if $hadoop::params::qjm_ha_mode == "yes" {
            exec { "create StandBy NameNode principle":
                command => "kadmin.local -q 'addprinc -randkey nn/${hadoop::params::standby_master}@${hadoop::params::kerberos_realm}'",
                user => "root",
                group => "root",
                alias => "add-princ-standby-nn",
                path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
                require => File["keytab-path"],
                onlyif => "test ! -e ${hadoop::params::keytab_path}/standby_nn.service.keytab",  
            }
        }
 
        exec { "create Secondary NameNode principle":
            command => "kadmin.local -q 'addprinc -randkey sn/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "add-princ-sn",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => File["keytab-path"],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/sn.service.keytab",
        }

        datanodeprinciple { $hadoop::params::dfs_slaves: 
            require => File["keytab-path"],
        }

        nodemanagerprinciple { $hadoop::params::yarn_slaves:
            require => File["keytab-path"],
        }

        if ! member($hadoop::params::slaves, $hadoop::params::master) {
            masterhostprinciple { $hadoop::params::master:
                require => File["keytab-path"],
                before  => Exec["create-keytab-nn"],
            } 
        }

        if $hadoop::params::qjm_ha_mode == "yes" {
 
            if ! member($hadoop::params::slaves, $hadoop::params::standby_master) {
                standbymasterhostprinciple { $hadoop::params::standby_master:
                    require => File["keytab-path"],
                    before  => Exec["create-keytab-standby-nn"],
                } 
            }

            journalnodeprinciple { $hadoop::params::journalnodes: 
                require => File["keytab-path"],
            }

            journalnode_internal_principle { $hadoop::params::journalnodes:
                require => File["keytab-path"],
            }

        }
 
        if is_array(hadoop::params::slaves) or $hadoop::params::master != $hadoop::params::slaves {
            hostprinciple { $hadoop::params::slaves:
                require => File["keytab-path"],
                before  => Exec["create-keytab-nn"],
            } 
        }
 
        exec { "create ResourceManager principle":
            command => "kadmin.local -q 'addprinc -randkey rm/${hadoop::params::resourcemanager}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "add-princ-rm",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => File["keytab-path"],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/rm.service.keytab",
        }
 
        exec { "create JobHistoryServer principle":
            command => "kadmin.local -q 'addprinc -randkey jhs/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "add-princ-jhs",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => File["keytab-path"],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/jhs.service.keytab",
        }

        if $hadoop::params::qjm_ha_mode == "no" or ! member($hadoop::params::journalnodes, $hadoop::params::master) {
 
            exec { "create WebHDFS principle":
                command => "kadmin.local -q 'addprinc -randkey HTTP/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
                user => "root",
                group => "root",
                alias => "add-princ-HTTP-${hadoop::params::master}",
                path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
                require => File["keytab-path"],
                onlyif => "test ! -e ${hadoop::params::keytab_path}/http.service.keytab",
            }
        }

        exec { "create NameNode keytab":
            command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/nn.service.keytab nn/${hadoop::params::master}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/nn.service.keytab host/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "create-keytab-nn",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"] ],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/nn.service.keytab",
        }

        if $hadoop::params::qjm_ha_mode == "yes" {
 
            exec { "create StandBy NameNode keytab":
                command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/standby_nn.service.keytab nn/${hadoop::params::standby_master}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/standby_nn.service.keytab host/${hadoop::params::standby_master}@${hadoop::params::kerberos_realm}'",
                user => "root",
                group => "root",
                alias => "create-keytab-standby-nn",
                path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
                require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-standby-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"] ],
                onlyif => "test ! -e ${hadoop::params::keytab_path}/standby_nn.service.keytab",
            }
 
            journalnodekeytab { $hadoop::params::journalnodes:
            }
 
        }
 
        exec { "create SecondaryNameNode keytab":
            command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/sn.service.keytab sn/${hadoop::params::master}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/sn.service.keytab host/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "create-keytab-sn",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"] ],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/sn.service.keytab",
        }

        datanodekeytab { $hadoop::params::dfs_slaves: 
        }

        nodemanagerkeytab { $hadoop::params::yarn_slaves:
        }
         
        exec { "create ResourceManager keytab":
            command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/rm.service.keytab rm/${hadoop::params::resourcemanager}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/rm.service.keytab host/${hadoop::params::resourcemanager}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "create-keytab-rm",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"] ],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/rm.service.keytab",
        }
 
        exec { "create JobHistory keytab":
            command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/jhs.service.keytab jhs/${hadoop::params::master}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/jhs.service.keytab host/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
            user => "root",
            group => "root",
            alias => "create-keytab-jhs",
            path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
            require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"] ],
            onlyif => "test ! -e ${hadoop::params::keytab_path}/jhs.service.keytab",
        }
 
        if $hadoop::params::qjm_ha_mode == "yes" {

            webhdfskeytab { $hadoop::params::journalnodes: 
            }
 
        } 

        if $hadoop::params::qjm_ha_mode == "no" or ! member($hadoop::params::journalnodes, $hadoop::params::master) {
            exec { "create WebHDFS keytab":
                command => "kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/http.service.keytab HTTP/${hadoop::params::master}@${hadoop::params::kerberos_realm}'; kadmin.local -q 'ktadd -k ${hadoop::params::keytab_path}/http.service.keytab host/${hadoop::params::master}@${hadoop::params::kerberos_realm}'",
                user => "root",
                group => "root",
                alias => "create-keytab-http",
                path    => ["/usr/sbin", "/usr/kerberos/sbin", "/usr/bin"],
                require => [ Exec["add-princ-jhs"], Exec["add-princ-rm"], Exec["add-princ-nn"], Exec["add-princ-sn"], Exec["add-princ-host-${hadoop::params::master}"], Exec["add-princ-HTTP-${hadoop::params::master}"] ],
                onlyif => "test ! -e ${hadoop::params::keytab_path}/http.service.keytab",
            }
        }
        
    }        


}

class hadoop::cluster::master($format_namenode = 'no', $launch_dfs = 'no', $launch_yarn = 'no', $launch_history_server = 'no') {

    require hadoop::params
    require hadoop

    if $hadoop::params::kerberos_mode == "yes" { 
 
        if $hadoop::params::qjm_ha_mode == "yes" and member($hadoop::params::journalnodes, $fqdn) {
 
            file { "${hadoop::params::keytab_path}/hdfs.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.hdfs.service.keytab",
            }
 
            file { "${hadoop::params::keytab_path}/http.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.http.service.keytab",
            }
 
        }
 
        if member($hadoop::params::yarn_slaves, $fqdn) {
 
            file { "${hadoop::params::keytab_path}/nm.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.nm.service.keytab",
            }
        }
    }
 
    if $format_namenode == "yes" {
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
    }

    if $launch_dfs == "yes" {

        exec { "Start DFS services":
            command => "./start-dfs.sh",
            cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
            user => "${hadoop::params::hdfs_user}",
            alias => "start-dfs",
            path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
            before => [Exec["start-yarn"]],
            onlyif => "test 0 -eq $(${hadoop::params::java_home}/bin/jps | grep -c NameNode)",
        }

        if $hadoop::params::kerberos_mode == "yes" {
            exec { "Start Secure DFS services":
                command => "sudo HADOOP_SECURE_DN_USER=${hadoop::params::hdfs_user} ./start-secure-dns.sh",
                cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
                user => "${hadoop::params::hdfs_user}",
                alias => "start-secure-dfs",
                path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
                before => [Exec["start-yarn"]],
                require => [Exec["start-dfs"]],
            }
        }
    }

    if $launch_yarn == "yes" {

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
    }

    if $launch_history_server == "yes" { 

        exec { "Start historyserver":
            command => "./mr-jobhistory-daemon.sh start historyserver",
            cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin",
            user => "${hadoop::params::mapred_user}",
            alias => "start-historyserver",
            path    => ["/bin", "/usr/bin", "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::version}/sbin"],
            require => Exec["start-yarn"],
            onlyif => "test 0 -eq $(${hadoop::params::java_home}/bin/jps | grep -c JobHistoryServer)",
        }
    }

    if $launch_dfs == "yes" {
 
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

}

class hadoop::cluster::slave {

    require hadoop::params
    require hadoop

    if $hadoop::params::kerberos_mode == "yes" {
 
        file { "${hadoop::params::keytab_path}":
            ensure => "directory",
            owner => "root",
            group => "${hadoop::params::hadoop_group}",
            mode => "750",
            alias => "keytab-path",
            require => [ File["hadoop-master"], File["hadoop-slave"] ],
        }

        if $hadoop::params::qjm_ha_mode == "yes" and $fqdn == $hadoop::params::standby_master {
 
            file { "${hadoop::params::keytab_path}/nn.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/standby_nn.service.keytab",
                require => File["keytab-path"],
            }

        }
 
        if $hadoop::params::qjm_ha_mode == "yes" and member($hadoop::params::journalnodes, $fqdn) {
 
            file { "${hadoop::params::keytab_path}/hdfs.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.hdfs.service.keytab",
                require => File["keytab-path"],
            }
 
            file { "${hadoop::params::keytab_path}/http.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.http.service.keytab",
                require => File["keytab-path"],
            }
   
        }
 
        if member($hadoop::params::dfs_slaves, $fqdn) { 
            file { "${hadoop::params::keytab_path}/dn.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.dn.service.keytab",
                require => File["keytab-path"],
            }
        }

        if $hadoop::params::resourcemanager == $fqdn {
 
            file { "${hadoop::params::keytab_path}/rm.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/rm.service.keytab",
                require => File["keytab-path"],
            }
 
        } 

        if member($hadoop::params::yarn_slaves, $fqdn) {
 
            file { "${hadoop::params::keytab_path}/nm.service.keytab":
                ensure => present,
                owner => "root",
                group => "${hadoop::params::hadoop_group}",
                mode => "440",
                source => "puppet:///modules/hadoop/keytab/${fqdn}.nm.service.keytab",
                require => File["keytab-path"],
            }
        }
 
    }

}
