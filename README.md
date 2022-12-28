# helloworld

Hello World for Jenkins GitHub and Vault Integration Testing

## Purpose

This Hello World deploys an nginx "hello world" deployment on a local
Kubernetes cluster. It is a proof-of-concept for the Jenkins student. It
assumes that one has set up a localgitops pipeline system as per
https://github.com/PentheusLennuye/localgitops.

This Hello World is meant to be pulled and executed by Jenkins as an
SCM-controlled Freestyle project. Jenkins should not only have the Git and ANSI
modules installed, but the Kubernetes and Vault plugins installed and configured
as well.

## Use

You will need the Kubernetes cluster CA, located in _$HOME/.kube/config_. You 
will want to create a cluster user that has the rights to create namespaces and
deployments. Personally, I cheat and use the admin certificates already set up
in my "localgitops" system _.kube/config_. Place the certificates in your
Hashicorp Vault under _kv/ci/tfbackend_ as:

- cluster_ca_certificate
- jenkins_k8s_client_certificate
- jenkins_k8s_client_key

Of course, you can modify the Jenkinsfile to set up your own secret storage
path.

Upon "Build Now," Jenkins downloads the repo and executes the Jenkinsfile.

## Note

The Kubernetes backend for terraform appears to ignore the -backend-config
command-line switch. One must create a dummy .kubeconfig. Note that this is
written in the first stage of the Jenkinsfile.

