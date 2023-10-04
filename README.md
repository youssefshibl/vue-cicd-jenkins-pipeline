![Untitled-2023-08-22-15341](https://github.com/youssefshibl/vue-cicd-jenkins-pipeline/assets/63800183/32823b09-45df-4c7a-b6c4-c0e97086ad42)


# vue-cicd-jenkins-pipeline

make vue git repo with jenkins pipeline which will build by install dependencies and run unit test and build the project and build new docker image from build then push image to docker hub and configure nginx container to disable one of web app container until update app docker image and then switch to new container see architecture diagram in repo 

- jenkins master using scm to check every two minutes for any changes in repo and if there are change start pipeline job

![Screenshot from 2023-10-04 21-35-23](https://github.com/youssefshibl/vue-cicd-jenkins-pipeline/assets/63800183/3bdbe0ab-7c92-4104-acf3-65def7d0abfa)

![Screenshot from 2023-10-04 21-35-40](https://github.com/youssefshibl/vue-cicd-jenkins-pipeline/assets/63800183/6997eb76-63d8-4b41-a2b0-78a76a0fd666)


- jenkins master master will using jenkins slave as agent to make job , but what is jenkins slave ? , jeinkins slave is a container with nodejs as base layer  which have jenkins agent installed and configured to connect to jenkins master and run any job in jenkins master
- after jenkins slave container start it will connect to jenkins master and wait for any job to run, after job start it will clone repo and start pipeline job which 
    + install dependencies
    + run unit test
    + build project
    + build docker image with build code with latest tag
    + push docker image to docker hub

- after that i want update two app with new docker iamge version so i make nginx container ignore one of app container and make it down and update app docker image and then switch to new app container and make old app container down
```conf
worker_processes 2;

events { worker_connections 1024; }

#make config for web server
http {
   upstream backend {
      server 172.24.0.5:8080 ; 
      server 172.24.0.6:8080 ; 

   }

   # This server accepts all traffic to port 80 and passes it to the upstream. 
   # Notice that the upstream name and the proxy_pass need to match.

   server {
      listen 8080; 
      location / {
          proxy_pass http://backend;
      }
   }
}
```
disable one of app container
```conf
worker_processes 2;

events { worker_connections 1024; }

#make config for web server
http {
   upstream backend {
      #server 172.24.0.5:8080 ; 
      server 172.24.0.6:8080 ; 

   }

   # This server accepts all traffic to port 80 and passes it to the upstream. 
   # Notice that the upstream name and the proxy_pass need to match.

   server {
      listen 8080; 
      location / {
          proxy_pass http://backend;
      }
   }
}
```
then updat app docker image of this app1 and disable app2 
```conf
worker_processes 2;

events { worker_connections 1024; }

#make config for web server
http {
   upstream backend {
      server 172.24.0.5:8080 ; 
      #server 172.24.0.6:8080 ; 

   }

   # This server accepts all traffic to port 80 and passes it to the upstream. 
   # Notice that the upstream name and the proxy_pass need to match.

   server {
      listen 8080; 
      location / {
          proxy_pass http://backend;
      }
   }
}
```
the enable app2 on nginx container , then this case two container is runing 

![Screenshot from 2023-10-04 21-36-11](https://github.com/youssefshibl/vue-cicd-jenkins-pipeline/assets/63800183/33d726ca-34d5-4065-b8fb-6abca661351d)


## How start infrastructure
+ i make file called infrastructur which have docker-compose file to start jenkins master and jenkins slave and nginx container and app1 and app2 container , nginx config of load balancer  , node_ubuntu.sh script , this script which make node js container commpitable as jenkins slave and communicate with jenkins master and run any job in jenkins master

+ after run this docker compose file you will go to `localhost:8000` this will login to jenkins master , then you should use configuation as code plugin to import jenkins.yaml file which containe all jenkins credential and job and pipeline job and jenkins slave agent configuration

![Screenshot from 2023-10-04 21-54-50](https://github.com/youssefshibl/vue-cicd-jenkins-pipeline/assets/63800183/e1231d76-37b3-4277-a7a4-8e488f5222d0)