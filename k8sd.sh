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
	echo """alias k='kubectl'
alias kd='kubectl -n protons'""" > ~/.kube/alias-cmds
	mkdir -p "${HOME}/k8sconfig/rently-$ENV"
	cp -r "${HOME}/.kube" "${HOME}/k8sconfig/rently-$ENV/.kube"
	docker run -it -h "rently-$ENV" --name "rently-$ENV"  -v "${HOME}/rently-$ENV":/root --rm abhinavkishoregv/kctl-debian:latest \
		 bash -c "PATH=$PATH:/root/.local/bin;cp /root/.bashrc /root/.bashrc.bak; cat /root/.kube/alias-cmds >> /root/.bashrc && echo 'Use Kubectl commands just like your machine. You can also use the below aliases'; cat ~/.kube/alias-cmds && cd && bash"
fi
