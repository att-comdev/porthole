# RBD PV backup/restore script

This MOP covers Maintenance Activities related to using the nccli rbd_pv.sh script
to backup and recover PVCs within your kubernetes environment using Ceph.

## Usage
Execute nccli rbd_pv without arguements to list usage options.

```
/tmp/nccli rbd_pv.sh
Backup Usage: nccli rbd_pv [-b <pvc name>] [-n <namespace>] [-d <backup dest> (optional, default: /tmp/backup)] [-p <ceph rbd pool> (optional, default: rbd)]
Restore Usage: nccli rbd_pv [-r <restore_file>] [-p <ceph rbd pool> (optional, default: rbd)]
Snapshot Usage: nccli rbd_pv [-b <pvc name>] [-n <namespace>] [-p <ceph rbd pool> (optional, default: rbd] [-s <create|rollback|remove> (required)]
```

## Backing up a PVC from RBD
To backup a PV, execute the following:

```
nccli rbd_pv -b mysql-data-mariadb-server-0 -n openstack
```

## Restoring a PVC backup
To restore a PV RBD backup image, execute the following:

```
nccli rbd_pv -r /tmp/kubernetes-dynamic-pvc-ab1f2e8f-21a4-11e9-ab61-ca77944df03c.img.xz
```
NOTE: The original PVC/PV residing in Ceph must be removed, otherwise the restore script will rename it.

## Creating a Snapshot for a PVC

```
nccli rbd_pv -b mysql-data-mariadb-server-0 -n openstack -s create
```

## Rolling back to a Snapshot for a PVC

```
nccli rbd_pv -b mysql-data-mariadb-server-0 -n openstack -s rollback
```

## Removing a Snapshot for a PVC

```
nccli rbd_pv -b mysql-data-mariadb-server-0 -n openstack -s remove
```

NOTE: Removing the snapshot will remove all snapshots in Ceph associated to this PVC.
