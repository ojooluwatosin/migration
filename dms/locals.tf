locals {
  #my_ip             = ["${chomp(data.http.myip.body)}/32"]
  #my_ip4address     = data.http.my_ip4address


  instance-userdata = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y wget perl
wget https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm -O /home/ec2-user/oracle-database-xe-18c-1.0-1.x86_64.rpm
wget https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm -O /home/ec2-user/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm
wget wget http://mirror.centos.org/centos/7/os/x86_64/Packages/compat-libstdc++-33-3.2.3-72.el7.i686.rpm -O /home/ec2-user/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
sudo yum localinstall -y /home/ec2-user/compat-libstdc++-33-3.2.3-72.el7.i686.rpm
sudo yum localinstall -y /home/ec2-user/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm
sudo yum localinstall -y /home/ec2-user/oracle-database-xe-18c-1.0-1.x86_64.rpm
(echo "manager"; echo "manager";) | /etc/init.d/oracle-xe-18c configure
sudo echo ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE/ >> /home/oracle/.bash_profile
sudo echo PATH=\$PATH:\$ORACLE_HOME/bin >> /home/oracle/.bash_profile
sudo echo ORACLE_SID=xe >> /home/oracle/.bash_profile
sudo echo export ORACLE_HOME PATH ORACLE_SID >> /home/oracle/.bash_profile
wget https://github.com/oracle/db-sample-schemas/archive/v19.2.tar.gz -O /home/oracle/v19.2.tar.gz
sudo su - oracle -c "tar -axf v19.2.tar.gz"
sudo su - oracle -c "cd db-sample-schemas-19.2; perl -p -i.bak -e 's#__SUB__CWD__#/home/oracle/db-sample-schemas-19.2#g' *.sql */*.sql */*.dat"
sudo su - oracle -c "cd db-sample-schemas-19.2; sqlplus system/manager@localhost/XEPDB1 @mksample manager manager manager manager manager manager manager manager users temp /tmp/ localhost/XEPDB1"
chkconfig --add oracle-xe-18c
EOF
}