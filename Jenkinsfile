pipeline {
    agent { label 'slave' }

    stages {
        stage('install dependencies') {
            steps {
                // git(
                //         url: 'https://github.com/MichaelCurrin/vue-quickstart.git',
                //         branch: "master",
                //         changelog: true,
                //         poll: true
                //     )   
               sh 'npm install'
               sh 'npm run serve -- --port 3000'

            }
        }
    }
}