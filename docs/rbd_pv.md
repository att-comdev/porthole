# RBD PV backup/restore script

This MOP covers Maintenance Activities related to using the rbd_pv.sh script
to backup and recover PVCs within your kubernetes environment using Ceph.

## Usage
Execute rbd_pv.sh without arguements to list usage options.

```
/tmp/rbd_pv.sh
Backup Usage: /tmp/rbd_pv.sh [-b <pvc name>] [-n <namespace>] [-d <backup dest> (optional, default: /tmp/backup)] [-p <ceph rbd pool> (optional, default: rbd)]
Restore Usage: /tmp/rbd_pv.sh [-r <restore_file>] [-p <ceph rbd pool> (optional, default: rbd)]
Snapshot Usage: /tmp/rbd.pv.sh [-b <pvc name>] [-n <namespace>] [-p <ceph rbd pool> (optional, default: rbd] [-s <create|rollback|remove> (required)]
```

## Backing up a PVC from RBD
To backup a PV, execute the following:

```
rbd_pv.sh -b mysql-data-mariadb-server-0 -n openstack
```

## Restoring a PVC backup
To restore a PV RBD backup image, execute the following:

```
rbd_pv.sh -r /tmp/kubernetes-dynamic-pvc-ab1f2e8f-21a4-11e9-ab61-ca77944df03c.img.xz
```
NOTE: The original PVC/PV residing in Ceph must be removed, otherwise the restore script will rename it.

## Creating a Snapshot for a PVC

```
rbd_pv.sh -b mysql-data-mariadb-server-0 -n openstack -s create
```

## Rolling back to a Snapshot for a PVC

```
rbd_pv.sh -b mysql-data-mariadb-server-0 -n openstack -s rollback
```

## Removing a Snapshot for a PVC

```
rbd_pv.sh -b mysql-data-mariadb-server-0 -n openstack -s remove
```

NOTE: Removing the snapshot will remove all snapshots in Ceph associated to this PVC.
