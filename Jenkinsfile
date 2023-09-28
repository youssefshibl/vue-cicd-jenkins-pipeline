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
               sh 'npm run serve -- --port 3000'

            }
        }
        stage('build'){
            steps {
                sh 'npm run build'
            }
        }

        stage('test build') {
            steps {
                sh 'npm run serve -- --port ${PORT} -s dist'
            }
        }

    }
}