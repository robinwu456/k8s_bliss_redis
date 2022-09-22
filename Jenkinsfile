pipeline {
    agent {
        kubernetes {
            inheritFrom 'bliss'
            defaultContainer 'p1'
            yaml """
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
    - name: regcred
  containers:
  - name: jnlp
    image: quay.io/flysangel/inbound-agent:4.13-2-jdk11
  - name: p1
    securityContext:
      privileged: true
    image: quay.io/podman/stable:v3.4.7
    command: ["sleep"]
    args: ["infinity"]
  - name: k1
    securityContext:
      privileged: true
    image: bitnami/kubectl
    command: ["sleep"]
    args: ["infinity"]
"""
        }
    }
    environment {
        QUAY_ADMIN = credentials('quay-cred')
        KUBECONFIG = credentials('kubeconfig-cred')
        IMAGE_TAG = "quay.io/robinwu456/bliss_redis:${env.BRANCH_NAME}.${env.BUILD_NUMBER}"
    }
    stages {
	stage ('build redis') {
            steps {
                sh 'podman login --tls-verify=false -u=${QUAY_ADMIN_USR} -p=${QUAY_ADMIN_PSW} quay.io'
                sh 'podman build --tls-verify=false -t "${IMAGE_TAG}" .'
                sh 'podman images'
                sh 'podman push --tls-verify=false "${IMAGE_TAG}"'
            }
        }
        stage ('deploy redis-prod') {
            when { branch 'master' }
            steps {
                container('k1') {
                    sh 'mkdir -p ~/.kube && cp ${KUBECONFIG} ~/.kube/config'
                    sh "sed -i.bak 's#quay.io/robinwu456/bliss_redis#${IMAGE_TAG}#' deploy/redis.yaml"
                    sh 'kubectl apply -f deploy/service_redis.yaml -n bliss-prod'
                    sh 'kubectl apply -f deploy/redis.yaml -n bliss-prod'
                }
            }
	}       
    }
}
