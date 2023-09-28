pipeline {
    agent { label 'slave' }
    environment {
        CI = 'true'
        PORT = 3000
    }

    stages {
        stage('install dependencies') {
            steps {  
               sh 'npm install'
            }
        }
        stage('build'){
            steps {
                sh 'npm run build'
            }
        }
        stage('Building Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("$registry:$BUILD_NUMBER")
                }
            }
       }

        stage('test build') {
            steps {
                sh 'npm run serve -- --port ${PORT} -s dist'
            }
        }

    }
}