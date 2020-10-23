# Description
`docker-openresty-gm` is a docker image with [OpenResty][1] , [rtmp module][3] and [GraphicsMagick][11] for [docker][6]

# Features
* Support RTMP, HLS and MPEG-DASH streaming (thanks to [nginx rtmp module][3])
* On the fly (and free) SSL registration and renewal inside [OpenResty/nginx][1] with [Let's Encrypt][7] (thanks to [lua-resty-auto-ssl][4])
* Integrated GeoIP REST Api (thanks to [Telize][2])
* Lightweight image based on [openresty/openresty:alpine-fat flavor][5]

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
