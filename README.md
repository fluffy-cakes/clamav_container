# clamav_container
Container for scanning completed torrents in Transmission

Inspired by https://github.com/rordi/docker-antivirus

Example:
```bash
docker run --detach \
    --name=clamav \
    -e ENVIP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | awk 'gsub("/.*", "")') \
    -v /downloads:/data/done \
    -v /completed:/data/scan \
    clamav:latest
```
