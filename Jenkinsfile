pipeline {
    agent { label 'slave' }
    environment {
        CI = 'true'
        PORT = 3000
        registry = "youssefshebl/vueapp"
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
                sh 'docker build -t "$registry:$BUILD_NUMBER" .'
            }
        }
        stage('Docker Push') {
            steps {

                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh 'docker push "$registry:$BUILD_NUMBER"'
                }
            }
       }

        // stage('test build') {
        //     steps {
        //         sh 'npm run serve -- --port ${PORT} -s dist'
        //     }
        // }

    }
}