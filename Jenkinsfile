pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
    namespace: jenkins
spec:
  dnsPolicy: ClusterFirst 
  containers:
  - name: myagent
    image: myagent:v1
    command:
    - cat
    tty: true
    volumeMounts:
    - name: dockersock
      mountPath: /var/run/docker.sock
  - name: helm
    image: alpine/helm:3.18
    command:
    - cat
    tty: true      

  volumes:
  - name: dockersock
    hostPath:
      path: /var/run/docker.sock   
"""
        }
    }

    environment {
    KUBECONFIG = "${WORKSPACE}/kubeconfig"  // kubectl will use this path
    DOCKER_CREDS_ID = 'nexus-creds' 
    NEXUS_REGISTRY = 'localhost:30050'
    IMAGE_TAG = 'myversion' 
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
                    script {
                                myImage = docker.build("${NEXUS_REGISTRY}/quarkus:${IMAGE_TAG}")

                            }
                   
 
                }
                // Run Maven build
                //sh './mvnw clean package'
            }
        }
        //export KUBECONFIG=$KUBECONFIG_FILE
                            //cp $KUBECONFIG_FILE /root/.kube/config
                            //chmod 600 /root/.kube/config

                            //helm version
                            //helm list -n jenkins
        stage('Deploy-chart') {
            steps {
                container('helm') {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE')]) {
                        sh '''
                             # Replace 127.0.0.1 with host IP reachable from the pod
                            sed -i 's|127.0.0.1|host.docker.internal|g' $KUBECONFIG_FILE
                            export KUBECONFIG=$KUBECONFIG_FILE

                            helm install my-chart ./my-chart -n jenkins
                            
                            
                        '''
                    }
                }
            }
        }

        stage('Package-Push-chart') {
            steps {
                container('helm') {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE'), usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh '''

                            helm package ./my-chart
                            curl -u $USERNAME:$PASSWORD --upload-file my-chart-0.1.0.tgz http://nexus-nexus-repository-manager:32129/repository/helm-repo/
                            
                        '''
                    }  
                }
            }
        }
         

        stage('Push-docker-image') {
            steps {
                container('myagent') {
                    script {
                            docker.withRegistry("http://${NEXUS_REGISTRY}", "${DOCKER_CREDS_ID}") {
                            myImage.push("${IMAGE_TAG}") 

                            }   
                    }
                }
            }
        }   
        


    }
}
