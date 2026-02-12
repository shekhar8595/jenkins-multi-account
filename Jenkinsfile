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
                    def envFolder = "environment/${params.ENV}"
                    def module = 'module1'

                    // Maps must be inside script block, not environment block
                    def servers = [
                        dev : 'dev-server',
                        uat : 'uat-server',
                        prod: 'prod-server'
                    ]
                    def users = [
                        dev : 'dev-user',
                        uat : 'uat-user',
                        prod: 'prod-user'
                    ]

                    def server = servers[params.ENV]
                    def user = users[params.ENV]

                    echo "Deploying ${module} to ${params.ENV} environment on ${server}"

                    try {
                        // Ensure target directory exists
                        sh "ssh ${user}@${server} 'mkdir -p /opt/app/${module}/'"

                        // Copy the built JAR
                        sh "scp ${module}/target/*.jar ${user}@${server}:/opt/app/${module}/"

                        // Copy environment-specific config
                        sh "scp ${envFolder}/${module}-config.yaml ${user}@${server}:/opt/app/${module}/config.yaml"
                    } catch (Exception e) {
                        error "Deployment failed: ${e}"
                    }
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
