pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
    namespace: jenkins
spec:
  containers:
  - name: myagent
    image: myagent:v1
    command:
    - cat
    tty: true
  - name: kubectl
    image: bitnami/kubectl:latest
    command:
    - cat
    tty: true  
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock

  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock   
"""
        }
    }

    environment {
    KUBECONFIG = "${WORKSPACE}/kubeconfig"  // kubectl will use this path
  }

    stages {
        stage('Checkout') {
            steps {
                container('myagent') {
                     checkout scm
                }
            
            }
        }

       // stage('Prepare') {
           // steps {
           //     sh 'chmod +x mvnw'
                //sh 'rm -rf ~/.m2/repository/org/mvnpm/echarts/'
          //  }
   // }
        stage('Build-jar') {
            steps {
                  container('myagent') {
                    sh 'mvn clean package'
                }
                // Run Maven build
                //sh './mvnw clean package'
            }
        }

        stage('Build-image') {
            steps {
                  container('myagent') {
                    sh 'docker build -t quarkus:myversion .'
                    //sh 'buildah push myimage:latest docker://myregistry/myimage:latest'
                   
 
                }
                // Run Maven build
                //sh './mvnw clean package'
            }
        }

        stage('Deploy-chart') {
            steps {
                container('kubectl') {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                        sh '''
                            cp $KUBECONFIG_FILE $KUBECONFIG
                            chmod 600 $KUBECONFIG

                            kubectl version
                            kubectl config current-context

                            kubectl get pods -n jenkins
                        '''
                    }
                }
            }
        }

    }
}
