pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prod'],
            description: 'Select deployment environment'
        )
    }

    environment {
        // Jenkins credentials for GCP service account
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shekhar8595/jenkins-multi-account.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                script {
                    def modulePath = "modules/vm"
                    def envFolder = "${WORKSPACE}/environment/${params.ENV}"

                    // Sanity check: ensure terraform.tfvars exists
                    sh """
                    echo "Checking for tfvars file..."
                    if [ ! -f ${envFolder}/terraform.tfvars ]; then
                        echo "ERROR: terraform.tfvars not found in ${envFolder}!"
                        exit 1
                    fi
                    """

                    echo "Initializing Terraform for ${params.ENV}"
                    sh "terraform -chdir=${modulePath} init -input=false -backend-config=${envFolder}/backend.tfvars"

                    echo "Planning Terraform deployment"
                    sh "terraform -chdir=${modulePath} plan -var-file=${envFolder}/terraform.tfvars"
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                script {
                    def modulePath = "modules/vm"
                    def envFolder = "${WORKSPACE}/environment/${params.ENV}"

                    echo "Applying Terraform configuration for ${params.ENV}"
                    sh "terraform -chdir=${modulePath} apply -auto-approve -var-file=${envFolder}/terraform.tfvars"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform deployment for ${params.ENV} succeeded!"
        }
        failure {
            echo "Terraform deployment for ${params.ENV} failed!"
        }
    }
}
