pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout source code from your SCM (e.g., Git)
                checkout scm
            }
        }

        stage('Prepare') {
            steps {
                sh 'chmod +x mvnw'
                sh 'rm -rf ~/.m2/repository/org/mvnpm/echarts/'

            }
    }
        stage('Build') {
            steps {
                // Run Maven build
                sh './mvnw clean package'
            }
        }

    }

    post {
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
