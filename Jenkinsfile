pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout source code from your SCM (e.g., Git)
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Run Maven build
                sh 'mvn quarkus:dev'
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
