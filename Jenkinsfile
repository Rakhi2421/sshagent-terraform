#!/usr/bin/env groovy

library identifier: 'jenkins-shared-library@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'https://github.com/Rakhi2421/jenkins-shared-library.git',
     credentialsId: 'Githubcred'
    ]
)

pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'srirakesh124'
        BACKEND_IMAGE = "${DOCKER_HUB_USER}/backend:latest"
        FRONTEND_IMAGE = "${DOCKER_HUB_USER}/frontend:latest"
        MYSQL_IMAGE = "${DOCKER_HUB_USER}/mysql:latest"
    }
    stages {
        stage('build backend image') {
            steps {
                script {
                   echo 'building backend docker image...'
                   buildImage(env.BACKEND_IMAGE, "./backend")
                   dockerLogin()
                   dockerPush(env.BACKEND_IMAGE)
                }
            }
        }
        stage('build frontend image') {
            steps {
                script {
                   echo 'building frontend docker image...'
                   buildImage(env.FRONTEND_IMAGE, "./frontend")
                   dockerLogin()
                   dockerPush(env.FRONTEND_IMAGE)
                }
            }
        
        }
        stage('build mysql image') {
            steps {
                script {
                   echo 'building mysql docker image...'
                   buildImage(env.MYSQL_IMAGE, "./mysql")
                   dockerLogin()
                   dockerPush(env.MYSQL_IMAGE)
                }
            }
        }
        stage('provision server') {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                TF_VAR_env_prefix = 'test'
            }
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                        EC2_PUBLIC_IP = sh(
                            script: "terraform output ec2_public_ip",
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        stage('deploy') {
            environment {
                DOCKER_CREDS = credentials('docker-hub-repo')
            }
            steps {
                script {
                   echo "waiting for EC2 server to initialize" 
                   sleep(time: 90, unit: "SECONDS") 

                   echo 'deploying docker image to EC2...'
                   echo "${EC2_PUBLIC_IP}"

                   def shellCmd = "bash ./server-cmds.sh ${BACKEND_IMAGE} ${FRONTEND_IMAGE} ${MYSQL_IMAGE} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
                   def ec2Instance = "ec2-user@${EC2_PUBLIC_IP}"

                   sshagent(['server-ssh-key']) {
                       sh "scp -o StrictHostKeyChecking=no server-cmds.sh ${ec2Instance}:/home/ec2-user"
                       sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${ec2Instance}:/home/ec2-user"
                       sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                   }
                }
            }
        }
    }
}

