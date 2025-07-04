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
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      command:
      - cat
      tty: true   
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
                  container('kaniko') {
                    //sh 'buildah bud -t quarkus:myversion .'
                    //sh 'buildah push myimage:latest docker://myregistry/myimage:latest'
                    sh 'cp /home/jenkins/agent/workspace/mypipeline/target/my-app-1.0.0-SNAPSHOT.jar ./workspace'
                    sh '/kaniko/executor  --dockerfile Dockerfile --no-push'
 
                }
                // Run Maven build
                //sh './mvnw clean package'
            }
        }

    }

}
