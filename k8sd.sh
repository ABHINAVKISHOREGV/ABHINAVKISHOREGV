#!/bin/bash
I='false'
ENV=$1

check_file() {
	if [ ! -f /.kube/$ENV.yaml ];then if [ -f ~/Downloads/$ENV.yaml ];then cp ~/Downloads/$ENV.yaml ~/.kube/$ENV.yaml; else echo "Download Kubeconfig file for $ENV cluster and store it in ~/.kube directory"; exit 1; fi fi
}


case $ENV in
	aura)
		ENV='dev' check_file
		cp ~/.kube/dev.yaml ~/.kube/config
		;;
	atlas)
		check_file
		cp ~/.kube/atlas.yaml ~/.kube/config
		;;
	aura-qe)
		check_file
		cp ~/.kube/aura-qe.yaml ~/.kube/config
		;;
	core)
		check_file
		cp ~/.kube/core.yaml ~/.kube/config
		;;
	core-qe)
		check_file
		cp ~/.kube/core-qe.yaml ~/.kube/config
		;;
	*)
		echo "Please mention env name."
		echo "aura aura-qe core core-qe atlas"
		I='true'
    
esac

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
