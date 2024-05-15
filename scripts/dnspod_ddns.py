import json
import logging
import argparse
import urllib
import urllib.request
import urllib.parse

GETIPV6 = "https://ipv6.ddnspod.com"
GETIPV4 = "https://ipv4.ddnspod.com"
DP_ID = 'xxx'  # replace with your ID
DP_TOKEN = 'xxx'  # replace with your Token
DOMAIN = 'xxx'

# for all subdomain, just use *.xx
parser = argparse.ArgumentParser()
parser.add_argument('--domain', '-d', default=DOMAIN, help='Domain')
parser.add_argument('--sub_domain', '-s', default='xxx', help='Subdomain, default: xxx')
parser.add_argument('--record_type', '-t', default='AAAA', help='Record Type, e.g., AAAA(default), A')
parser.add_argument('--local_ip_type', '-lt', default=None, help='Use local IPV4 or IPV6, default: None')
args = parser.parse_args()

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def get_public_ipv6():
    """just curl -6 -s $GETIPV6"""

    url = GETIPV6
    req = urllib.request.Request(url)
    req.add_header('Host', url.lstrip(
        'https://').lstrip('http://').split('/')[0])
    response = urllib.request.urlopen(req)
    content = response.read().decode('utf-8')
    return content


def get_public_ipv4():
    """just curl -s $GETIPV6"""

    url = GETIPV4
    req = urllib.request.Request(url)
    req.add_header('Host', url.lstrip(
        'https://').lstrip('http://').split('/')[0])
    response = urllib.request.urlopen(req)
    content = response.read().decode('utf-8')
    return content


def get_local_ipv4():
    cmdline = "ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172*'| head -n 1"
    res = subprocess.run(cmdline, shell=True, capture_output=True)
    ip = res.stdout.decode('utf8').strip()
    logger.warning(ip)
    return ip


def get_local_ipv6():
    cmdline = 'ip a | grep inet6 | grep -v "::1" | grep -Eo "([a-f0-9:]+:+)+[a-f0-9]+" | head -n 1'
    res = subprocess.run(cmdline, shell=True, capture_output=True)
    ip = res.stdout.decode('utf8').strip()
    logger.warning(ip)
    return ip


class DNSPod(object):
    """DNSPod ddns application."""

    def __init__(self, params):
        """Initialize with params."""
        self._params = params

    def post_data(self, url, data):
        encoded_data = urllib.parse.urlencode(data).encode()

        req = urllib.request.Request(url, data=encoded_data, method='POST')
        with urllib.request.urlopen(req) as response:
            response_data = response.read().decode('utf-8')
            return response_data

    def run(self, params=None):
        if params is None:
            params = self._params
        public_ip = None
        if args.local_ip_type is None:
            if params['record_type'] == 'AAAA':
                public_ip = get_public_ipv6()
            elif params['record_type'] == 'A':
                public_ip = get_public_ipv4()
        elif args.local_ip_type == 'A':
            public_ip = get_local_ipv4()
        elif args.local_ip_type == 'AAAA':
            public_ip = get_local_ipv6()
        if public_ip is None:
           logger.error('IP unknown')
           return
        # get record_id of sub_domain
        record_list = self.get_record_list(params)
        if record_list['code'] == '10' or record_list['code'] == '26':
            # create record for empty sub_domain
            record_id = self.create_record(params, public_ip)
            remote_ip = public_ip
        elif record_list['code'] == '1':
            # get record id
            remote_ip = record_list['ip_value']
            if remote_ip == public_ip:
                logger.warning('same ip: ' + remote_ip)
                return -1
            else:
                logger.warning(record_list)
                params['record_id'] = record_list['record_id']
                res = self.ddns(params, public_ip)
                logger.warning(res)
        else:
            logger.error('Update not work')
            logger.error(record_list)
            return -1
        current_ip = remote_ip
        logger.warning('current_ip: ' + current_ip)


    def get_record_list(self, params):
        """Get record list.
        https://www.dnspod.cn/docs/records.html#record-list
        :return: dict of code, record_id and IP value
        """
        record_list_url = 'https://dnsapi.cn/Record.List'

        r = self.post_data(record_list_url, data=params)
        jd = json.loads(r)
        code = jd['status']['code']
        record_id = jd['records'][0]['id'] if code == '1' else ""
        ip_value = jd['records'][0]['value'] if code == '1' else ""
        logger.warning('query_record')
        logger.warning(jd)
        return dict(code=code, record_id=record_id, ip_value=ip_value)


    def create_record(self, params, ip):
        """Create record if not created before.
        https://www.dnspod.cn/docs/records.html#record-create
        :return: record_id of new record
        """
        params['value'] = ip
        record_create_url = 'https://dnsapi.cn/Record.Create'
        r = self.post_data(record_create_url, data=params)
        jd = json.loads(r)
        assert jd['status']['code'] == '1'
        record_id = jd['record']['id']
        logger.warning('create_record')
        logger.warning(jd)
        return record_id

    def ddns(self, params, ip):
        """Update ddns ip.
        https://www.dnspod.cn/docs/records.html#dns
        """
        logger.warning(ip)
        logger.warning(params)
        params['value'] = ip
        ddns_url = 'https://dnsapi.cn/Record.Ddns'
        r = self.post_data(ddns_url, data=params)
        jd = json.loads(r)
        logger.warning('update_ddns')
        logger.warning(jd)
        return jd['status']['code'] == '1'


def main():
    params = dict(
        login_token=("%s,%s" % (DP_ID, DP_TOKEN)),
        format='json',
        domain=args.domain,
        sub_domain=args.sub_domain,
        record_line='默认',
        record_type=args.record_type
    )

    dnspod = DNSPod(params)
    dnspod.run()


def test():
    get_local_ipv4()

if __name__ == "__main__":
    main()

