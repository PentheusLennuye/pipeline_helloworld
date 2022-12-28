def secrets = [
  [
    path: 'kv/ci/tfbackend', engineVersion: 2, secretValues: [
      [envVar: 'CA_CERT', vaultKey: 'cluster_ca_certificate'],
      [envVar: 'CLIENT_CERT', vaultKey: 'jenkins_k8s_client_certificate'],
      [envVar: 'CLIENT_KEY', vaultKey: 'jenkins_k8s_client_key']
    ]
  ]
]
def k8sapi = "https://kubernetes.default.svc"
pipeline {
  agent {
    kubernetes {
      defaultContainer 'shell'
      yamlFile 'KubernetesPod.yml'
    }
  }
  options {
    ansiColor('xterm')
    buildDiscarder(logRotator(numToKeepStr: '5'))
    disableConcurrentBuilds()
  }
  parameters {
    // When a build gets triggered, the first choice becomes the default.
    choice(
      name: 'OPERATION',
      choices: ['Audit', 'Deploy', 'Destroy'],
      description: 'Deployment Option'
    )
  }
  stages{
    stage('Create kubeconfig from template') {
    // Not recommended in the long run (i.e. writing secrets to disk) but
    // required for Kubernetes Terraform backend. This backend permits a
    // tfstate to be kept by Kubernetes as a secret.
      steps {
        withVault([vaultSecrets: secrets]) { 
          dir('terraform') {
            script {
              k8sconfig = readYaml file: 'kubeconfig_template'
              k8sconfig.clusters[0].cluster.'certificate-authority-data' = CA_CERT
              k8sconfig.clusters[0].cluster.server = k8sapi
              k8sconfig.users[0].user.'client-certificate-data' = CLIENT_CERT
              k8sconfig.users[0].user.'client-key-data' = CLIENT_KEY
              writeYaml file: 'kubeconfig', data: k8sconfig
            }
          }
        }
      }
    }
    stage('Audit HelloWorld') {
      when { equals expected: 'Audit', actual: params.OPERATION }
      steps {
        dir('terraform') {
          sh 'terraform init' // safe to run multiple times
          sh 'terraform plan -out the.plan'
        }
      }
    }
    stage('Deploy HelloWorld') {
      when { equals expected: 'Deploy', actual: params.OPERATION }
      steps {
        dir('terraform') {
          sh 'terraform init' // safe to run multiple times
          sh 'terraform plan -out the.plan'
          sh 'terraform apply the.plan'
        }
      }
    }
    stage('Destroy HelloWorld') {
      when { equals expected: 'Destroy', actual: params.OPERATION }
      steps {
        dir('terraform') {
          sh 'terraform init' // safe to run multiple times
          sh 'terraform destroy -auto-approve the.plan'
        }
      }
    }
  }
}

