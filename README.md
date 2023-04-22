# opencv-cuvid-docker

OpenCV compiled with CUDA NVCUVID support for Docker.

build docker
```shell
docker build -t zzj136598/opencv-cuvid:cuda11.3.1-cudnn8-devel-ubuntu20.04 . 
```

run
```shell
 docker run -it -e NVIDIA_DRIVER_CAPABILITIES=video,compute,utility --rm --gpus all zzj136598/opencv-cuvid:cuda11.3.1-cudnn8-devel-ubuntu20.04 bash
```

test in container
```shell
cd /home 
python3 test.py
```

踩坑笔记:
+ 需要好的网络环境解决opencv编译时需要拉取资源的问题.
+ 需要指定CUDA_nvcuvid_LIBRARY=/lib/x86_64-linux-gnu/libnvcuvid.so.1，默认指向/usr/local/cuda/lib64中.
+ libnvcuvid.so.1文件无论如何都要指向真实显卡驱动所带的，务必不要使用官网下载的Video_Codec_SDK中的动态链接库，在物理环境可以find / -n libnvcuvid.so.1,在docker中需要增加NVIDIA_DRIVER_CAPABILITIES=video,compute,utility让nvidia-docker映射动态链接库到容器，如果有多个cuda版本存在，需要手动映射文件.
+ windows的docker基于wls2才可以使用显卡驱动，由于底层原理导致容器调用物理环境显卡驱动方式不同，由windows build镜像与linux无法通用，请在一致的平台build


参考:
+ https://github.com/opencv/opencv_contrib/issues/3359
+ https://github.com/NVIDIA/nvidia-docker/issues/1001
+ https://stackoverflow.com/questions/48786654/nvidia-driver-libraries-in-nvidia-cuda-image
