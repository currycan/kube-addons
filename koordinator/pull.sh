
repo=registry.cn-hangzhou.aliyuncs.com
tag=1.1.1
img=(koord-descheduler koord-scheduler koordlet koord-manager)
for i in ${img[@]};
do
    # echo $repo/$i:$tag
    docker pull $repo/koordinator-sh/$i:v$tag
done

docker save $repo/koordinator-sh/{koord-descheduler,koord-scheduler,koordlet,koord-manager}:v$tag -o koord.tgz
