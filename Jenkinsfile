@Library('shared-lib@main') _

    pipeline {
         agent {
            kubernetes {
                yaml libraryResource('podTemplates/mvn-docker-helm.yaml')
            }
        }   

        environment { 
        KUBECONFIG = "${WORKSPACE}/kubeconfig"  // kubectl will use this path
        DOCKER_CREDS_ID = 'nexus-creds' 
        NEXUS_REGISTRY = 'nexus-nexus-repository-manager:5000'
        IMAGE_TAG = 'myversion' 
    }

        stages {
            stage('Checkout') {
                steps {
                    container('mvn') {
                        checkout scm
                        function()
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
                    container('mvn') {
                        sh 'mvn clean package'
                    }
                    // Run Maven build
                    //sh './mvnw clean package'
                }
            }

            stage('Build-image') {
                steps {
                    container('docker') {
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
                            withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                                sh '''
                                    # Replace 127.0.0.1 with host IP reachable from the pod
                                    sed -i 's|127.0.0.1|host.docker.internal|g' $KUBECONFIG_FILE

                                    helm install my-chart ./my-chart -n jenkins
                                    
                                    
                                '''
                            }
                        }
                    }
                }
            }

            stage('Package-Push-chart') {
                steps {
                    container('helm') {
                        withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh '''
                                helm package ./my-chart
                                curl -u $USERNAME:$PASSWORD --upload-file my-chart-0.1.0.tgz http://nexus-nexus-repository-manager:8081/repository/helm-repo/
                                
                            '''
                        }  
                    }
                }
            }
            

            stage('Push-docker-image') {
                steps {
                    container('docker') {
                        script {
                                docker.withRegistry("http://${NEXUS_REGISTRY}", "${DOCKER_CREDS_ID}") {
                                myImage.push("${IMAGE_TAG}") 

                                }   
                        }
                    }
                }
            }

            stage('Add-install-nexus-chart') {
                steps {
                    container('helm') {
                        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG_FILE'), usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            withEnv(["KUBECONFIG=${KUBECONFIG_FILE}"]) {
                            sh '''
                                # Replace 127.0.0.1 with host IP reachable from the pod
                                sed -i 's|127.0.0.1|host.docker.internal|g' $KUBECONFIG_FILE
                                helm repo add --username $USERNAME --password $PASSWORD helm-nexus http://nexus-nexus-repository-manager:8081/repository/helm-repo/
                                helm repo update
                                helm repo list
                                helm install helm-nexus helm-nexus/my-chart --version 0.1.0 -n jenkins --set image.repository=nexus-nexus-repository-manager:5000/quarkus  --set image.tag=myversion
                                
                          
                            }    '''
                        }  
                    }
                }
            }   
            


        }
    }
