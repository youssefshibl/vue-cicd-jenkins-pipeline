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
                sh 'docker build -t "$registry" .'
            }
        }
        stage('Docker Push') {
            steps {

                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                    sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                    sh 'docker push "$registry"'
                }
            }
        }
        stage('disable first machine in nginx load balancer') {
            steps {
                sh '''#!/bin/bash
                   docker exec  nginx_cicd bash -c 'echo "$(sed  "9s/^/#/" /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf && nginx -s reload'                               
                   '''
            }
        }
        stage('update first app container'){
            steps{
                sh '''#!/bin/bash
                    # update first app container from docker compose file 
                    docker container stop app1
                    docker container rm app1
                    docker pull youssefshebl/vueapp
                    docker run -d --name app1 --network jenkins --ip 172.24.0.5 youssefshebl/vueapp                  
                    '''
            }
        }
        stage('disable second machine in nginx load balancer') {
            steps {
                sh '''#!/bin/bash
                   # connected to nginx contianer and uncommit line 6 , commit line 7 and reload nginx config
                    docker exec  nginx_cicd bash -c 'echo "$(sed  '9s/^#//' /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf'
                    docker exec  nginx_cicd bash -c 'echo "$(sed  '10s/^/#/' /etc/nginx/nginx.conf)" > /etc/nginx/nginx.conf && nginx -s reload'                        
                   '''
            }
        }
        stage('update second app container'){
            steps{
                sh '''#!/bin/bash
                    # update first app container from docker compose file 
                    docker container stop app2
                    docker container rm app1
                    docker pull youssefshebl/vueapp
                    docker run -d --name app2 --network infrastructure_jenkins --ip 172.24.0.6 youssefshebl/vueapp                  
                    '''
            }
        }        
        // stage('test build') {
        //     steps {
        //         sh 'npm run serve -- --port ${PORT} -s dist'
        //     }
        // }

    }
}


     