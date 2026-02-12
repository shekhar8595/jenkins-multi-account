// pipeline {
//     agent any

//     parameters {
//         choice(
//             name: 'ENV',
//             choices: ['dev', 'uat', 'prod'],
//             description: 'Select deployment environment'
//         )
//     }

//     tools {
//         maven 'Maven3'
//         jdk 'Java11'
//     }

//     stages {
//         stage('Checkout') {
//             steps {
//                 git branch: 'main', url: 'https://github.com/shekhar8595/jenkins-multi-account.git'
//             }
//         }

//         stage('Build') {
//             steps {
//                 echo "Building module1"
//                 sh "cd module1 && mvn clean package"
//             }
//         }

//         stage('Test') {
//             steps {
//                 echo "Running tests for module1"
//                 sh "cd module1 && mvn test"
//             }
//         }

//         stage('Deploy') {
//             steps {
//                 script {
//                     // Environment folder
//                     def envFolder = "environment/${params.ENV}"
                    
//                     // Map of environment → server
//                     def servers = [
//                         dev: 'dev-server',
//                         uat: 'uat-server',
//                         prod: 'prod-server'
//                     ]
                    
//                     echo "Deploying module1 to ${params.ENV} environment on ${servers[params.ENV]}"

//                     // Copy the built jar
//                     sh "scp module1/target/*.jar user@${servers[params.ENV]}:/opt/app/module1/"

//                     // Copy environment-specific config
//                     sh "scp ${envFolder}/module1-config.yaml user@${servers[params.ENV]}:/opt/app/module1/config.yaml"
//                 }
//             }
//         }
//     }

//     post {
//         success {
//             echo "Pipeline for ${params.ENV} succeeded!"
//         }
//         failure {
//             echo "Pipeline for ${params.ENV} failed!"
//         }
//     }
// }

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

    environment {
        // Map environment to server and user
        SERVERS = [
            dev: 'dev-server',
            uat: 'uat-server',
            prod: 'prod-server'
        ]
        USERS = [
            dev: 'dev-user',
            uat: 'uat-user',
            prod: 'prod-user'
        ]
        MODULE = 'module1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shekhar8595/jenkins-multi-account.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building ${env.MODULE}"
                sh "cd ${env.MODULE} && mvn clean package"
            }
        }

        stage('Test') {
            steps {
                echo "Running tests for ${env.MODULE}"
                sh "cd ${env.MODULE} && mvn test"
            }
        }

        stage('Deploy') {
            steps {
                script {
                    def envFolder = "environment/${params.ENV}"
                    def server = env.SERVERS[params.ENV]
                    def user = env.USERS[params.ENV]

                    echo "Deploying ${env.MODULE} to ${params.ENV} environment on ${server}"

                    try {
                        // Ensure target directory exists
                        sh "ssh ${user}@${server} 'mkdir -p /opt/app/${env.MODULE}/'"

                        // Copy the built JAR
                        sh "scp ${env.MODULE}/target/*.jar ${user}@${server}:/opt/app/${env.MODULE}/"

                        // Copy environment-specific config
                        sh "scp ${envFolder}/${env.MODULE}-config.yaml ${user}@${server}:/opt/app/${env.MODULE}/config.yaml"
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
