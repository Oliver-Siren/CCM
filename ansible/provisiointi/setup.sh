#!/bin/bash

mkdir /home/joona/.ssh

chown joona /home/joona/.ssh

cat <<EOF > /home/joona/.ssh/authorized_keys

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPo6LysH1CFdynfjhodoF2DzqooYbvslFlTMfn83q+GMPr4OlbK+r+DtXHzTL2oxJNmLVzHLPasSZaBk/MU/CErZCxnvrdEs+PqXq1sEVXLqMCqC0m5F7IodPOXnqxYErtUu/6KvTAEM010Le4DolGlIYiA7k9sGwCXJ22AiAv6TiMa2clwe/VBWWVF8p+LltXif836aY0OenAT7Ke0nukNqX5n9Pu/dE31pv5s+HfJrSEnrdh2frqQqxhcFsTB5q7ZKDI9F67rsBs6ypwHu10PRjnLg2xp1F0uxSHNd/QDiwkCrw8PXn83Dsb9xNvJ1chrATnie5W87337S3FLaPR joona@esitys

EOF

chown joona /home/joona/.ssh/authorized_keys
