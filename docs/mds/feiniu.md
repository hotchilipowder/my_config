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

配置免密码:

```
sudo visudo
admin ALL=(ALL) NOPASSWD: NOPASSWD: ALL
```

部署证书&重启服务:

```
acme.sh --install-cert -d example.com --fullchain-file /home/admin/ssl/example.com.crt --key-file /home/admin/ssl/example.com.key \
        --reloadcmd "sudo bash /home/admin/ssl/update_cert.sh"
```

其中，配置 `update_cert.sh` 如下:

```
CERT_NAME="example.com"
CERT_PATH="/usr/trim/var/trim_connect/ssls/xxx"

sudo cp /home/admin/ssl/example.com.crt /usr/trim/var/trim_connect/ssls/example.com/xxxx/example.com.crt
sudo cp /home/admin/ssl/example.com.key /usr/trim/var/trim_connect/ssls/example.com/xxx/example.com.key

NEW_EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH/$CERT_NAME.crt" | sed "s/^.*=\(.*\)$/\1/")
NEW_EXPIRY_TIMESTAMP=$(date -d "$NEW_EXPIRY_DATE" +%s%3N)  # 获取毫秒级时间戳
echo "新证书的有效期到: $NEW_EXPIRY_DATE"

sudo systemctl restart webdav.service smbftpd.service trim_nginx.service
psql -U postgres -d trim_connect -c "UPDATE cert SET valid_to=$NEW_EXPIRY_TIMESTAMP WHERE domain='$CERT_NAME'"
echo "服务已更新"
```

### 参考资料
1. https://github.com/lfgyx/fnos_certificate_update/blob/main/src/update_cert.sh
2. https://club.fnnas.com/forum.php?mod=viewthread&tid=6890
