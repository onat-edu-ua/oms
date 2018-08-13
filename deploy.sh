#!/bin/bash

set -e

function usage(){
	echo -e "usage: $0 <api_base> <local repo name> <publish prefix>/<publish distribution> deb_file1 [ deb_file2 ...]"
	exit 1
}

[ -z "$1" ] && echo -e "\nmissed api base\n" && usage
[ -z "$2" ] && echo -e "\nmissed local repo name\n" && usage
[ -z "$3" ] && echo -e "\nmissed publish prefix and distribution\n" && usage
[ -z "$4" ] && echo -e "\nmissed package\n" && usage

api_base="$1"
shift
repo="$1"
shift
pub="$1"
shift

files="$@"
timestamp="$(date +%s)"
dir="${repo}_${timestamp}"

function fail {
	echo "$1"
	exit 1
}

for file in $files; do
	echo -e "\n\e[33m> upload pkg \e[39m $file\n"
	curl -sSfF file=@"$file" "${api_base}/files/$dir" || fail "can't upload pkg file $file"
done

echo -e "\n\e[33m> add pkg to repo $repo\e[39m\n"
curl -sSf -X POST "${api_base}/repos/$repo/file/$dir" || fail "can't add pkg to repo"

echo -e "\n\e[33m> update publish $pub \e[39m\n"
curl -sSf -X PUT -H 'Content-Type: application/json' --data '{ "Signing": {"PassphraseFile":"/home/pkg/gpg_pass"} }' "${api_base}/publish/${pub}" || fail "can't publish"

