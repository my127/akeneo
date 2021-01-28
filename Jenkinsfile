pipeline {
    agent { label 'my127ws' }
    options {
        buildDiscarder(logRotator(daysToKeepStr: '30'))
        parallelsAlwaysFailFast()
    }
    triggers { cron(env.BRANCH_NAME ==~ /^main$/ ? 'H H(0-6) 2 * *' : '') }
    stages {
        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }
        stage('Publish') {
            environment {
                DOCKER_REGISTRY_CREDS = credentials('docker-registry-credentials')
            }
            when {
                branch 'main'
            }
            steps {
                sh 'echo "$DOCKER_REGISTRY_CREDS_PSW" | docker login --username "$DOCKER_REGISTRY_CREDS_USR" --password-stdin docker.io'
                sh 'docker-compose push'
            }
            post {
                always {
                    sh 'docker logout docker.io'
                }
            }
        }
    }
    post {
        always {
            sh 'docker-compose down -v --rmi local'
            cleanWs()
        }
    }
}
