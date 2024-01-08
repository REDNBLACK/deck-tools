#!/usr/bin/env bash
org="io.github.streetpea.Chiaki4deck"
nickname="$(sed -nr 's/^.*server_nickname=(.+)$/\1/p' Chiaki.conf)"
reg_key="$(sed -nr 's/^.*rp_regist_key=@ByteArray\((.+)\)$/\1/p' Chiaki.conf | tr -d '\\0')"
ver="$(sed -nr 's/^.*ap_name=PS([[:digit:]])$/\1/p' Chiaki.conf)"
addr=""
mode="fullscreen"
passcode=""
timeout="35"

validate() {
    if ! [[ "$addr" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        if [[ "$addr" =~ ^[0-9a-zA-Z]+\.local$ ]]; then
            addr="$(getent hosts "$addr" | awk '{print $1}')"
        else
            echo "Error: Invalid or Empty --address: $addr" >&2
            exit 1;
        fi
    fi
    if ! [[ "$mode" =~ ^(fullscreen|zoom|stretch)$ ]]; then
        echo "Error: Invalid --mode: $mode" >&2
        exit 1;
    fi
    if ! [[ "$timeout" =~ ^[0-9]+$ ]] || [[ "$timeout" -lt 5 ]]; then
        echo "Error: Invalid --timeout: $timeout" >&2
        exit 1;
    fi
}

cmd() {
    flatpak run "${org}" $@ 2>/dev/null
}

connect_error() {
    echo "Error: Couldn't connect to your PlayStation console from your local address!" >&2
    echo "Error: Please check that your Steam Deck and PlayStation are on the same network" >&2
    echo "Error: ...and that you have the right PlayStation IP address or hostname!" >&2
    exit 1
}

wakeup_error() {
    echo "Error: Couldn't wake up PlayStation console from sleep!" >&2
    echo "Error: Please make sure you are using a PlayStation $ver." >&2
    echo "Error: If not, change the wakeup call to use the number of your PlayStation console" >&2
    exit 2
}

timeout_error() {
    echo "Error: PlayStation console didn't become ready in $timeout seconds!" >&2
    echo "Error: Please change $timeout to a higher number in your script if this persists." >&2
    exit 1
}

while getopts 'a:m:p:t:' opt; do
  case "$opt" in
    m) mode="$OPTARG"     ;;
    a) addr="$OPTARG"     ;;
    p) passcode="$OPTARG" ;;
    t) timeout="$OPTARG"  ;;
    ?|h)
      echo "Usage: $(basename $0) [-a address] [-m mode] [-p passcode] [-t timeout]"
      exit 1
    ;;
  esac
done

validate

SECONDS=0
# Wait for console to be in sleep/rest mode or on (otherwise console isn't available)
ps_status="$(cmd discover -h ${addr})"
while ! echo "${ps_status}" | grep -q 'ready\|standby'
do
    if [ ${SECONDS} -gt "$timeout" ]
    then
        connect_error
    fi
    sleep 1
    ps_status="$(cmd discover -h ${addr})"
done

# Wake up console from sleep/rest mode if not already awake
if ! echo "${ps_status}" | grep -q ready
then
    cmd wakeup -${ver} -h ${addr} -r ${reg_key}
fi

# Wait for PlayStation to report ready status, exit script on error if it never happens.
while ! echo "${ps_status}" | grep -q ready
do
    if [ ${SECONDS} -gt "$timeout" ]
    then
        if echo "${ps_status}" | grep -q standby
        then
            wakeup_error
        else
            timeout_error
        fi
    fi
    sleep 1
    ps_status="$(cmd discover -h ${addr})"
done

# Begin playing PlayStation remote play via Chiaki on your Steam Deck :)
flatpak run "${org}" --passcode "${passcode}" --${mode} stream "$(printf '%q ' "${nickname}" | xargs)" ${addr}
