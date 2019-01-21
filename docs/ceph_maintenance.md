# Ceph Maintenance

This MOP covers Maintenance Activities related to Ceph.


## Check OSD Status
To check the current status of OSDs, execute the following:

```
nccli osd-maintenance check_osd_status
```

## OSD Removal
To purge OSDs in down state, execute the following:

```
nccli osd-maintenance osd_remove
```

## OSD Removal By OSD ID
To purge OSDs by OSD ID in down state, execute the following:

```
nccli osd-maintenance remove_osd_by_id --osd-id <OSDID>
```

## Reweight OSDs
To adjust an OSD’s crush weight in the CRUSH map of a running cluster, execute the following:

```
nccli osd-maintenance reweight_osds
```