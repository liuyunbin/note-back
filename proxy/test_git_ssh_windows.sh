#!/bin/bash

set -ueo pipefail

function log_info() { echo -e "$(date +'%Y-%m-%d %H:%M:%S %z') $@" > /dev/tty;          }
function log_erro() { echo -e "$(date +'%Y-%m-%d %H:%M:%S %z') $@" > /dev/tty; exit -1; }

function set_proxy_env_empty() {
    export  http_proxy=
    export https_proxy=
    export   all_proxy=
    export  HTTP_PROXY=
    export HTTPS_PROXY=
    export   ALL_PROXY=
}

function test_proxy_base() {
    if git clone git@github.com:liuyunbin/liuyunbin &> /dev/null; then
        log_info "git --- $@ --- 成功"
    else
        log_info "git --- $@ --- 失败"
    fi
    rm -rf liuyunbin
}

function test_proxy_protocol_help() {
    echo "Host github.com"  > ~/.ssh/config
    echo "ProxyCommand connect $@ %h %p"  >> ~/.ssh/config

    test_proxy_base $@

    echo ""  > ~/.ssh/config
}

function test_proxy_protocol() {
    test_proxy_protocol_help -H              host-60:8001
   # test_proxy_protocol_help -H        admin@host-60:8002
   # test_proxy_protocol_help -S              host-60:8003
  #  test_proxy_protocol_help -S              host-60:8004
    test_proxy_protocol_help -S              host-60:8005
    #test_proxy_protocol_help -S        admin@host-60:8006
    test_proxy_protocol_help -H        yunbinliu.com:8007
    #test_proxy_protocol_help -H  admin@yunbinliu.com:8008
    log_info ""
}

function test_no_proxy() {
    set_proxy_env_empty
    test_proxy_base
    log_info ""
}


log_info "测试未设置代理:"
test_no_proxy

log_info "测试支持的代理协议:"
test_proxy_protocol

