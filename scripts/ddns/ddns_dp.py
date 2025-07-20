#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: hotchilipowder
@file: ddns_dp.py
@time: 2024/10/14
"""

import os
import re
import json
import logging
import subprocess
import argparse
import platform
import urllib
import urllib.request
import urllib.parse
import locale

DP_ID = "xxx"  # replace with your ID
DP_TOKEN = "xxx"  # replace with your Token


DOMAIN = "utlab.ltd"

GETIPV6 = "https://ipv6.ddnspod.com"
GETIPV4 = "https://ipv4.ddnspod.com"
# for all subdomain, just use *.xx
parser = argparse.ArgumentParser(
    description="After input DP_ID, DP_TOKEN, you can use `python ddns_dp.py -d utlab.ltd -s *.xxx -t A`"
)
parser.add_argument("--domain", "-d", default=DOMAIN, help=f"Domain, default {DOMAIN}")
parser.add_argument("--sub_domain", "-s", default="xxx", help="Subdomain, default: xxx")
parser.add_argument(
    "--record_type", "-t", default="AAAA", help="Record Type, e.g., AAAA(default), A"
)
parser.add_argument(
    "--local_ip_type",
    "-lt",
    default=None,
    help="Use local IPV4(A) or IPV6(AAAA), default: None, e.g., -lt A (it will get local ipv4)",
)
args = parser.parse_args()

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


ENCODING = locale.getpreferredencoding(False)


def get_public_ipv6():
    """just curl -6 -s $GETIPV6"""

    url = GETIPV6
    req = urllib.request.Request(url)
    req.add_header("Host", url.lstrip("https://").lstrip("http://").split("/")[0])
    response = urllib.request.urlopen(req)
    content = response.read().decode("utf-8")
    return content


def get_public_ipv4():
    """just curl -s $GETIPV6"""

    url = GETIPV4
    req = urllib.request.Request(url)
    req.add_header("Host", url.lstrip("https://").lstrip("http://").split("/")[0])
    response = urllib.request.urlopen(req)
    content = response.read().decode("utf-8")
    return content

def get_local_ipconfig_cmd():
    system_name = platform.system()
    if system_name == "Windows":
        return "ipconfig"
    elif system_name == "Darwin":  
        return "ifconfig"
    elif system_name == "Linux":
        return "ip a"
    else:
        return ""


def get_local_ipv4():
    cmd = get_local_ipconfig_cmd()
    res = subprocess.run(cmd, shell=True, capture_output=True)
    output = res.stdout.decode(ENCODING, errors="ignore")

    ips = re.findall(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b', output)
    for ip in ips:
        if not ip.startswith("127.") and not ip.startswith("172."):
            logger.warning(f"Local IPv4: {ip}")
            return ip
    return None



def get_local_ipv6():
    cmd = get_local_ipconfig_cmd()
    res = subprocess.run(cmd, shell=True, capture_output=True)
    output = res.stdout.decode(ENCODING, errors="ignore")

  
    ipv6_list = re.findall(r'\b(?:[a-fA-F0-9]{1,4}:){1,7}[a-fA-F0-9]{1,4}\b', output)
    for ip in ipv6_list:
        if ip.startswith("2"):
            logger.warning(f"Local IPv6: {ip}")
            return ip
    logger.warning("No valid public IPv6 found.")
    return None


class DNSPod(object):
    """DNSPod ddns application."""

    def __init__(self, params):
        """Initialize with params."""
        self._params = params

    def post_data(self, url, data):
        encoded_data = urllib.parse.urlencode(data).encode()

        req = urllib.request.Request(url, data=encoded_data, method="POST")
        with urllib.request.urlopen(req) as response:
            response_data = response.read().decode("utf-8")
            return response_data

    # 在DNSPod类中增加一个方法 check_and_delete_conflict
    def check_and_delete_conflict(self, params, current_record_type):
        """Check if there's a conflicting record type and delete it."""
        record_list_url = "https://dnsapi.cn/Record.List"

        # 请求所有类型的记录
        params_all_types = params.copy()
        params_all_types.pop('record_type', None)
        r = self.post_data(record_list_url, data=params_all_types)
        logger.warning(record_list_url)
        jd = json.loads(r)
        logger.info(f"Check conflict: {jd}")

        if jd['status']['code'] != '1':
            logger.error("Failed to retrieve record list")
            return

        records = jd.get('records', [])
        for record in records:
            if record['name'] == params['sub_domain'] and record['type'] != current_record_type:
                delete_url = "https://dnsapi.cn/Record.Remove"
                delete_params = params.copy()
                delete_params["record_id"] = record["id"]
                delete_response = self.post_data(delete_url, data=delete_params)
                jd_delete = json.loads(delete_response)
                assert jd_delete["status"]["code"] == "1", f"Failed to delete record: {jd_delete}"
                logger.info(f"Deleted conflicting record: {record}")

# 修改run函数，在添加或更新记录之前调用这个新方法
    def run(self, params=None):
        if params is None:
            params = self._params

        public_ip = None
        if args.local_ip_type is None:
            if params["record_type"] == "AAAA":
                public_ip = get_public_ipv6()
            elif params["record_type"] == "A":
                public_ip = get_public_ipv4()
        elif args.local_ip_type == "A":
            public_ip = get_local_ipv4()
        elif args.local_ip_type == "AAAA":
            public_ip = get_local_ipv6()

        if public_ip is None:
            logger.error("IP unknown")
            return

        # 检测并删除冲突的记录类型
        self.check_and_delete_conflict(params, params["record_type"])

        record_list = self.get_record_list(params)
        if record_list["code"] == "10" or record_list["code"] == "26":
            self.create_record(params, public_ip)
        elif record_list["code"] == "1":
            remote_ip = record_list["ip_value"]
            if remote_ip == public_ip:
                logger.info("same ip: " + remote_ip)
                return -1
            else:
                params["record_id"] = record_list["record_id"]
                self.ddns(params, public_ip)
        else:
            logger.error("Update not work")
            return -1
        logger.info(f"Updated IP to: {public_ip}")


    def get_record_list(self, params):
        """Get record list.
        https://www.dnspod.cn/docs/records.html#record-list
        :return: dict of code, record_id and IP value
        """
        record_list_url = "https://dnsapi.cn/Record.List"

        r = self.post_data(record_list_url, data=params)
        jd = json.loads(r)
        code = jd["status"]["code"]
        record_id = jd["records"][0]["id"] if code == "1" else ""
        ip_value = jd["records"][0]["value"] if code == "1" else ""
        logger.warning("query_record")
        logger.warning(jd)
        return dict(code=code, record_id=record_id, ip_value=ip_value)

    def create_record(self, params, ip):
        """Create record if not created before.
        https://www.dnspod.cn/docs/records.html#record-create
        :return: record_id of new record
        """
        if len(ip) == 0: 
            logger.error("ip not set")
            return
        params["value"] = ip
        record_create_url = "https://dnsapi.cn/Record.Create"
        logger.warning(params)
        r = self.post_data(record_create_url, data=params)
        jd = json.loads(r)
        assert jd["status"]["code"] == "1", jd
        record_id = jd["record"]["id"]
        logger.warning("create_record")
        logger.warning(jd)
        return record_id

    def ddns(self, params, ip):
        """Update ddns ip.
        https://www.dnspod.cn/docs/records.html#dns
        """
        logger.warning(ip)
        logger.warning(params)
        params["value"] = ip
        ddns_url = "https://dnsapi.cn/Record.Ddns"
        r = self.post_data(ddns_url, data=params)
        jd = json.loads(r)
        logger.warning("update_ddns")
        logger.warning(jd)
        return jd["status"]["code"] == "1"


def main():
    params = dict(
        login_token=("%s,%s" % (DP_ID, DP_TOKEN)),
        format="json",
        domain=args.domain,
        sub_domain=args.sub_domain,
        record_line="默认",
        record_type=args.record_type,
    )

    dnspod = DNSPod(params)
    dnspod.run()


def test():
    get_local_ipv4()


if __name__ == "__main__":
    main()

