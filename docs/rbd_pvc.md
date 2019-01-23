# RBD PVC backup/restore script

This MOP covers Maintenance Activities related to using the rbd_pvc.sh script
to backup and recover PVCs within your kubernetes environment using Ceph.	

## Usage
Execute rbd_pvc.sh without arguements to list usage options.

```
/tmp/rbd_pvc.sh
Backup Usage: /tmp/rbd_pvc.sh [-b <pvc name>] [-n <namespace>] [-d <backup dest> (optional, default: /tmp/backup)] [-p <ceph rbd pool> (optional, default: rbd)] 
Restore Usage: /tmp/rbd_pvc.sh [-r <restore_file>] [-p <ceph rbd pool> (optional, default: rbd)]
```

## Backing up a PVC from RBD
To backup a PVC, execute the following:

```
rbd_pvc.sh -b mysql-data-mariadb-server-0 -n openstack
```

## Restoring a PVC backup
To restore a PVC RBD backup image, execute the following:

```
rbd_pvc.sh -r /tmp/kubernetes-dynamic-pvc-ab1f2e8f-21a4-11e9-ab61-ca77944df03c.img.xz
```
