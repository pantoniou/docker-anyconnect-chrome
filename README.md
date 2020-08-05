# Docker VPN'ed chrome using anyconnect + working audio

A working VPN using open connect + chrome + audio/video working

## Configuration

Modify the vpn-chrome.sh script with what your connection details are.

For example if your server to connect is `foo.com`, your auth group is `work-group` and
user name is `john`

```
./start-vpn.sh -s foo.com -g work-group -u john
```

Note that if you don't supply a password via -p one will be requested upon start.


## Building
```bash
./buid.sh
```

## Running
```bash
./host_runner.sh
```
