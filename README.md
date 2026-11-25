# Description
`docker-openresty-gm` is a docker image with [OpenResty][1] , [rtmp module][3] and [GraphicsMagick][11] for [docker][6]

# Features
* Support RTMP, HLS and MPEG-DASH streaming (thanks to [nginx rtmp module][3])
* On the fly (and free) SSL registration and renewal inside [OpenResty/nginx][1] with [Let's Encrypt][7] (thanks to [lua-resty-auto-ssl][4])
* Integrated GeoIP REST Api (thanks to [Telize][2])
* Lightweight image based on [openresty/openresty:alpine-fat flavor][5]

# Release versions

Each Git tag `vX.Y.Z` corresponds to an image release `X.Y.Z`. The component versions for each release are listed below.

| Git tag | Image release | Alpine | OpenResty | OpenSSL | PCRE2 | LuaRocks | GraphicsMagick |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `v1.0.0` | `1.0.0` | `3.24.3` | `1.31.9.1` | `3.5.8` | `10.49` | `3.13.0` | `1.3.49` |

Release `1.0.0` publishes the following image tags:

* `kuwork/openresty:alpine-1.0.0`: Alpine, OpenResty and the RTMP module.
* `kuwork/openresty:alpine-fat-1.0.0`: adds LuaRocks and build tools.
* `kuwork/openresty:alpine-fat-gm-1.0.0`: adds GraphicsMagick and FFmpeg.

## Automated Docker Hub releases

Add the following secrets under **Settings → Secrets and variables → Actions**:

* `DOCKERHUB_USERNAME`: Docker Hub username with push access to `kuwork/openresty`.
* `DOCKERHUB_TOKEN`: Docker Hub access token.

To test the build without Docker Hub credentials, open **Actions → Publish Docker images → Run workflow**. Manual runs build all three images in parallel on two native runners: `ubuntu-latest` for `linux/amd64` and `ubuntu-24.04-arm` for `linux/arm64` (free for public repositories). Each runner verifies its own architecture natively using a temporary registry, without QEMU emulation. Manual runs skip Docker Hub login and publishing, so no images or tags leave the runners.

Push a semantic version tag to build, verify, and publish all three images:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow pushes six tags: `alpine`, `alpine-1.0.0`, `alpine-fat`, `alpine-fat-1.0.0`, `alpine-fat-gm`, and `alpine-fat-gm-1.0.0`. Every tag is a multi-architecture manifest containing `linux/amd64` and `linux/arm64`, so Docker automatically selects the matching architecture. The two architectures are built and verified in parallel on native runners, then each runner pushes per-architecture tags such as `alpine-amd64` and `alpine-arm64`. A final publish job merges them into the six multi-architecture tags, so the release is published only after both architectures pass verification. GitHub-hosted runners use the official download sources rather than the local mirror defaults.

# Prerequisites
* [Git][8]
* [Docker][9], required for single server deployment only.

# Usage
### Quickstart with Docker
SSH to your server and run
```bash
# Clone this repo
git clone https://github.com/kuwork/docker-openresty-gm.git  
# Run image and mount config files for later editing
docker run -dit --name my_streaming_server \
  -p 80:80 \
  -p 443:443 \
  -p 1935:1935 \
  -v ~/docker-openresty-gm/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
  kuwork/docker-openresty-gm:alpine-fat 
```
Then your browser should display OpenResty welcome home page at http://*streaming_server_ip*/ . Later on, just edit the mounted nginx.config file at `~/docker-openresty-gm/nginx.conf` for your needs and apply changes with command below
```bash
sudo docker exec my_streaming_server sh -c "openresty -t && openresty -s reload"
```

* [nginx rtmp module][3] has default application endpoint `my_live_stream`. You can push your live stream to the server via url:
rtmp://*streaming_server_ip_or_domain*:1935/*my_live_stream*/*my_stream_name* and playback with hls url http://*streaming_server_ip_or_domain*/hls/*my_stream_name*

# Building from source

The build scripts use the DaoCloud Docker Hub mirror for Alpine and a GitHub proxy for PCRE2 by default. OpenSSL is downloaded from its official source site. Set `RESTY_IMAGE_BASE`, `RESTY_OPENSSL_URL_BASE`, or `RESTY_PCRE_URL_BASE` to override these download sources.

```bash
git clone https://github.com/kuwork/docker-openresty-gm.git
cd docker-openresty-gm
./build.sh
# Then run the image
docker run -dit --name openresty-gm \
  -p 80:80 \
  -p 443:443 \
  -p 1935:1935 \
  -v ./nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
  kuwork/openresty:alpine-fat-gm
```

[1]: https://github.com/openresty/openresty
[2]: https://github.com/fcambus/telize
[3]: https://github.com/arut/nginx-rtmp-module
[4]: https://github.com/GUI/lua-resty-auto-ssl
[5]: https://github.com/openresty/docker-openresty/blob/master/alpine-fat/Dockerfile
[6]: https://docker.com/
[7]: https://letsencrypt.org
[8]: https://git-scm.com/
[9]: https://docker.io
[10]:https://letsencrypt.org/docs/rate-limits/
[11]:http://www.GraphicsMagick.org/
