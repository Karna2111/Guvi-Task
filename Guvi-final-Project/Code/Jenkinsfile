pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'karna2111'
        DEV_REPO = 'karna2111/dev'
        PROD_REPO = 'karna2111/prod'
        IMAGE_NAME = 'react-static-app'
    }

    options {
        skipStagesAfterUnstable()
    }

    triggers {
        githubPush() // Webhook-based trigger from GitHub
    }

    stages {

        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'chmod +x build/build.sh'
                sh './build/build.sh'
            }
        }

        stage('Push Docker Image') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'main'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'Docker-Jenkins', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        sh 'chmod +x build/deploy.sh'
                    if (env.BRANCH_NAME == 'dev') {
                        sh './build/deploy.sh dev'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh './build/deploy.sh prod'
                    }
                }
            }
        }
    }    

        stage('Deploy to EC2') {
               when {
             branch 'main' // This ensures the stage runs ONLY on 'main' branch
        }
            steps {
                sshagent(credentials: ['ec2-user-jenkins']) {
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@44.202.244.130 "docker pull $DOCKER_HUB_USER/$IMAGE_NAME && docker stop web || true && docker rm web || true && docker run -d -p 80:80 --name web $DOCKER_HUB_USER/$IMAGE_NAME"'
                }
            }
        }     
    }
}
