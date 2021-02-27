# Clam AV Container

Container for virus scanning completed torrents in Transmission.

Inspired by https://github.com/rordi/docker-antivirus
Used in conjunction with https://github.com/haugene/docker-transmission-openvpn

- Once Transmission downloads are complete they are moved to the `completed` folder
- Clam AV container will connect to Transmission and list all downloads
- Any downloads that are `100%` will be removed via `transmission-remote` command
- Clam AV will run a scan on `completed` folder
- Any infected files will be deleted, else those that are OK will be moved to `downloads`

```log
Fetching latest ClamAV virus definitions ...
Sat Feb 27 12:15:04 2021 -> ClamAV update process started at Sat Feb 27 12:15:04 2021
Sat Feb 27 12:15:04 2021 -> daily.cvd database is up to date (version: 26092, sigs: 3971946, f-level: 63, builder: raynman)
Sat Feb 27 12:15:04 2021 -> main.cvd database is up to date (version: 59, sigs: 4564902, f-level: 60, builder: sigmgr)
Sat Feb 27 12:15:04 2021 -> bytecode.cvd database is up to date (version: 332, sigs: 93, f-level: 63, builder: awillia2)
Waiting for changes to /data/scan  ...
Found files to process
Processing /data/scan/ubuntu-20.04.2-live-server-amd64.iso
[2021-02-27 12:19:09]
Checking and removing completed torrents
ID     Done       Have  ETA           Up    Down  Ratio  Status       Name
   2   100%    1.22 GB  Unknown      0.0     0.0    0.0  Idle         ubuntu-20.04.2-live-server-amd64.iso
Sum:           1.22 GB               0.0     0.0
192.168.8.201:9091/transmission/rpc/ responded: "success"
Running scan on completed torrents  --> File ok, moving
Done with processing
```

Container run example:
```bash
docker run --detach \
    --name=clamav \
    -e ENVIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | awk 'gsub("/.*", "")') \
    -v /mnt/downloads:/data/done \
    -v /mnt/completed:/data/scan \
    clamav:latest
```

Transmission example:
```bash
docker run --detach \
    --name=transmission \
    --cap-add=NET_ADMIN \
    --log-driver json-file \
    --log-opt max-size=10m \
    -e LOCAL_NETWORK=192.168.0.0/24 \
    -e OPENVPN_CONFIG=uk_london \
    -e OPENVPN_PASSWORD='password' \
    -e OPENVPN_PROVIDER=PIA \
    -e OPENVPN_USERNAME=p123456 \
    -e TZ=UTC \
    -p 9091:9091 \
    -v /mnt/docker/transmission:/data \
    -v /mnt/completed:/data/completed \
    haugene/transmission-openvpn
```