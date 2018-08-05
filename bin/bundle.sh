#!/bin/bash

function usage {
	cat >&2 <<EOF
usage: $0 <bundle args>
EOF
}

[ $# -eq 0 ] && { usage; exit 1; }

script_path="$(realpath "$0")"
bins_dir="$(dirname "$script_path")"
project_dir="$(realpath "${bins_dir}/..")"
bundle="$bins_dir/bundle"
env_file="/etc/oms/environment"

if [[ -z  $script_path || -z $bins_dir || -z $project_dir ]]; then
	printf "Failed to setup environment: \n" >&2
	printf "Script: %s; Binaries dir: %s; Project dir: %s.\n" "$script_path" "$bins_dir" "$project_dir" >&2
	exit 2
else
	cd "$project_dir"
fi

export GEM_HOME="${project_dir}/vendor/bundle" && echo "GEM_HOME: $GEM_HOME"
export GEM_PATH="${project_dir}/vendor/bundler:${project_dir}/vendor/bundle" && echo "GEM_PATH: $GEM_PATH"
export PATH="$bins_dir:$GEM_HOME/bin:$PATH"
export BUNDLE_GEMFILE="${project_dir}/Gemfile"

if [[ -f $env_file ]]; then
	while read line; do
		[[ -n "$line" ]] && \
			export "$line" && \
			echo "From env file: $line"
	done < "$env_file"
fi

"$bundle" "$@"
