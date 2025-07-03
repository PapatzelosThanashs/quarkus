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
    - name: buildah
      image: quay.io/buildah/stable:latest   
"""
        }
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
                  container('buildah') {
                    sh 'buildah bud -t quarkus:myversion .'
                    //sh 'buildah push myimage:latest docker://myregistry/myimage:latest'
                }
                // Run Maven build
                //sh './mvnw clean package'
            }
        }

    }

}
