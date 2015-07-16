# Disable SELinux. WARNING: This is due to CentOS6.6 disallowing nginx workers to access web folders
setenforce 0

# Start nginx
nginx