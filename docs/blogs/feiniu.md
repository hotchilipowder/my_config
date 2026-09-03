# 飞牛

## 证书问题

虽然飞牛官方提供了两个证书，但是这不是很实用。甚至为了安全性，都不开启FNID。

目前免费的更多的是使用 `acme.sh`申请的免费证书。

具体的安装和实用过程如下:

```
curl https://get.acme.sh | sh -s email=my@example.com

```

申请证书：
```
export DP_Id=xxxx
export DP_Key=xxxxxxxx
acme.sh --issue --dns dns_dp -d example.com -d *.example.com
```

查看证书安装位置:

```
cat /usr/trim/etc/network_gateway_cert.conf
```

注意填写        


部署证书&重启服务:

```
acme.sh --install-cert -d example.com --fullchain-file /home/admin/ssl/example.com.crt --key-file /home/admin/ssl/example.com.key \
        --reloadcmd "sudo bash /home/admin/ssl/update_cert.sh"
```

其中，配置 `update_cert.sh` 如下:

```
CERT_NAME="example.com"
CERT_PATH="/usr/trim/var/trim_connect/ssls/xxx"

sudo cp /home/admin/ssl/example.com.crt $CERT_PATH/example.com/xxx/example.com.crt
sudo cp /home/admin/ssl/example.com.key /usr/trim/var/trim_connect/ssls/example.com/xxx/example.com.key

NEW_EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH/$CERT_NAME.crt" | sed "s/^.*=\(.*\)$/\1/")
NEW_EXPIRY_TIMESTAMP=$(date -d "$NEW_EXPIRY_DATE" +%s%3N)  # 获取毫秒级时间戳
echo "新证书的有效期到: $NEW_EXPIRY_DATE"

sudo systemctl restart webdav.service smbftpd.service trim_nginx.service
psql -U postgres -d trim_connect -c "UPDATE cert SET valid_to=$NEW_EXPIRY_TIMESTAMP WHERE domain='$CERT_NAME'"
echo "服务已更新"
```

## 使用traefik替换默认的转发

1. 关闭系统设置-安全性-端口设置-高级设置-重定向。
2. 设置traefik的转发功能


```
tls:
  certificates:
    - certFile: /ssl/xxx.xxxx.xxxxx.crt
      keyFile: /ssl/xxx.xxxx.xxxxx.key

http:
  routers:
    # 针对80端口的路由器，直接返回重定向
    router-http:
      rule: "Host(`xxx.xxxx.xxxxx`)"
      entryPoints:
        - web
      middlewares:
        - redirect-http
      service: dummy-service

    router-https:
      rule: "Host(`xxx.xxxx.xxxxx`)"
      tls: true
      entryPoints:
        - websecure
      middlewares:
        - redirect-https
      service: dummy-service


  middlewares:
    # 针对HTTP请求的重定向，将端口改为5666
    redirect-http:
      redirectRegex:
        redirectRegex:
        regex: "^https?://xxx\\.xxxx\\.xxxxx(.*)$"
        replacement: "http://xxx.xxxx.xxxxx:5666$1"
        permanent: true

    # 针对HTTPS请求的重定向，将端口改为5667
    redirect-https:
      redirectRegex:
        regex: "^https://xxx\\.xxxx\\.xxxxx(.*)$"
        replacement: "https://xxx.xxxx.xxxxx:5667$1"
        permanent: true

  services:
    dummy-service:
      loadBalancer:
        servers:
          - url: "https://xxx.xxxx.xxxxx:5667"  # 无实际请求意义
```



### 参考资料
1. https://github.com/lfgyx/fnos_certificate_update/blob/main/src/update_cert.sh
2. https://club.fnnas.com/forum.php?mod=viewthread&tid=6890


## Zotero

[数据与文件的同步](https://zotero-chinese.com/user-guide/sync)
