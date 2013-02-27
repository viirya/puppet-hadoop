# /etc/puppet/modules/hadoop/manafests/init.pp

class hadoop::params {

	include java::params

	$version = $::hostname ? {
		default			=> "2.0.3-alpha",
	}

 	$hadoop_user = $::hostname ? {
		default			=> "hduser",
	}
 
 	$hadoop_group = $::hostname ? {
		default			=> "hadoop",
	}
        
	$master = $::hostname ? {
		default			=> "master.hadoop",
	}
 
	$resourcemanager = $::hostname ? {
		default			=> "master.hadoop",
	}
        
	$slaves = $::hostname ? {
		default			=> ["slave01.hadoop", "slave02.hadoop"] 
	}
 
	$resource_tracker_port = $::hostname ? {
		default			=> "8025",
	}

 	$scheduler_port = $::hostname ? {
		default			=> "8030",
	}

    $scheduler_class = $::hostname ? {
		default			=> "org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler",
	}
 
	$resourcemanager_port = $::hostname ? {
		default			=> "8040",
	}
 
	$hdfsport = $::hostname ? {
		default			=> "8020",
	}

	$replication = $::hostname ? {
		default			=> "3",
	}

	#$jobtrackerport = $::hostname ? {
	#	default			=> "8021",
	#}

	$java_home = $::hostname ? {
		default			=> "${java::params::java_base}/jdk${java::params::java_version}",
	}

	$hadoop_base = $::hostname ? {
		default			=> "/opt/hadoop",
	}
 
	$hadoop_conf = $::hostname ? {
		default			=> "${hadoop_base}/hadoop/conf",
	}
 
	$yarn_conf = $::hostname ? {
		default			=> "${hadoop_base}/hadoop/conf",
	}
 
    $hadoop_user_path = $::hostname ? {
		default			=> "/home/${hadoop_user}",
	}             

	$hdfs_path = $::hostname ? {
		default			=> "${hadoop_user_path}/hdfs",
	}

 	$hadoop_tmp_path = $::hostname ? {
		default			=> "${hadoop_user_path}/tmp",
	}
}
