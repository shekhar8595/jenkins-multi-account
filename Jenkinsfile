pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prod'],
            description: 'Select deployment environment'
        )
    }

    tools {
        maven 'Maven3'
        jdk 'Java11'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shekhar8595/jenkins-multi-account.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building module1"
                sh "cd module1 && mvn clean package"
            }
        }

        stage('Test') {
            steps {
                echo "Running tests for module1"
                sh "cd module1 && mvn test"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Environment folder
                    def envFolder = "environment/${params.ENV}"
                    
                    // Map of environment → server
                    def servers = [
                        dev: 'dev-server',
                        uat: 'uat-server',
                        prod: 'prod-server'
                    ]
                    
                    echo "Deploying module1 to ${params.ENV} environment on ${servers[params.ENV]}"

                    // Copy the built jar
                    sh "scp module1/target/*.jar user@${servers[params.ENV]}:/opt/app/module1/"

                    // Copy environment-specific config
                    sh "scp ${envFolder}/module1-config.yaml user@${servers[params.ENV]}:/opt/app/module1/config.yaml"
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline for ${params.ENV} succeeded!"
        }
        failure {
            echo "Pipeline for ${params.ENV} failed!"
        }
    }
}
