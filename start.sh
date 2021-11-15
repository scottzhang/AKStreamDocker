docker run --privileged=true -d --name akstream_dev -v $PWD/mysql_data:/var/lib/mysql -v $PWD/video_record:/root/AKStreamKeeper/record -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro --tmpfs /run:rw --net=host akstream:v1 /usr/sbin/init