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
            }
    }
        stage('Build') {
            steps {
                // Run Maven build
                sh './mvnw quarkus:dev'
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
