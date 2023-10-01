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
        // stage('disable first machine in nginx load balancer') {
        //     steps {
        //         sh '''#!/bin/bash
        //            # connected to nginx contianer and commit line 6 and reload nginx config
        //            docker exec -it nginx bash -c "sed -i '6s/^/#/' /etc/nginx/nginx.conf && nginx -s reload"            
        //            '''
        //     }
        // }
        // stage('update first app container'){
        //     steps{
        //         sh '''#!/bin/bash
        //             # update first app container from docker compose file 
        //             cd ./infrastructure
        //             docker-compose up -d --no-deps --build app1                    
        //             '''
        //     }
        // }
        // stage('disable second machine in nginx load balancer') {
        //     steps {
        //         sh '''#!/bin/bash
        //            # connected to nginx contianer and uncommit line 6 , commit line 7 and reload nginx config
        //            docker exec -it nginx bash -c "sed -i '6s/^#//' /etc/nginx/nginx.conf && \
        //            sed -i '7s/^/#/' /etc/nginx/nginx.conf && nginx -s reload"            
        //            '''
        //     }
        // }
        // stage('test build') {
        //     steps {
        //         sh 'npm run serve -- --port ${PORT} -s dist'
        //     }
        // }

    }
}