#!/bin/bash
I='false'
ENV=$1

check_file() {
	#echo $(whoami)
	if [ -f "${HOME}/Downloads/$ENV.yaml" ];then echo "file found in Downloads" && cp "${HOME}/Downloads/$ENV.yaml" "${HOME}/.kube/$ENV.yaml"; if [ ! -f "${HOME}/.kube/$ENV.yaml" ];then echo "No yaml file found";exit 0;fi else echo "No ENV.yaml present in kube dir or dowloads dir"; exit 1;fi
}

env_list=("aura-qe" "core" "core-qe" "atlas" "white" "certify" "qe" "byte" "pt" "rnd" "certify" "pulse")

if [[ "$ENV" == "aura" ]];then ENV='dev';check_file;cp "${HOME}/.kube/$ENV.yaml" "${HOME}/.kube/config";fi

if [[ ! " ${list[*]}" =~ " $value " ]]; then echo "$ENV"; check_file; cp "${HOME}/.kube/$ENV.yaml" "${HOME}/.kube/config"; else echo "Environment not listed available"; echo "below are the existing environments"; echo "aura aura-qe core core-qe atlas white certify qe byte pt rnd certify"; exit 0;fi

if [[ $I == 'false' ]]
then
	mkdir -p "${HOME}/k8sconfig/rently-$ENV" 
	if [ ! -f "${HOME}/k8sconfig/rently-$ENV/.bashrc" ];then
	echo """
# ~/.bashrc: executed by bash(1) for non-login shells.

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
#PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want 'ls' to be colorized:
export LS_OPTIONS='--color=auto'
#eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias k='kubectl' # Use k instead of kubectl 
alias kd='kubectl -n protons' #Use kd instead of kubectl For DEV / AURA DEV Cluster""" > ${HOME}/k8sconfig/rently-$ENV/.bashrc
	fi
	cp -r "${HOME}/.kube" "${HOME}/k8sconfig/rently-$ENV/.kube"
	docker run -it -h "rently-$ENV" --name "rently-$ENV"  -v "${HOME}/k8sconfig/rently-$ENV":/root --rm abhinavkishoregv/kctl-debian:latest bash -c "echo 'Use Kubectl commands just like your machine. You can also use the below aliases'; tail -n 2 ~/.bashrc && bash"
fi
