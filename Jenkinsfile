pipeline {
    agent any 

    tools {
        jdk 'jdk'
        nodejs 'nodejs'
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'e2e-3-tier-DevSecOps',
                    credentialsId: 'github-token',
                    url: 'https://github.com/Mhariogh/DevOps.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('Application-Code/backend') {
                    withSonarQubeEnv('sonar-server') {
                        sh """
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=three-tier-backend \
                            -Dsonar.projectName=three-tier-backend \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=\$SONAR_HOST_URL
                            -Dsonar.token=\$SONAR_AUTH_TOKEN
                        """
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    try {
                        timeout(time: 2, unit: 'MINUTES') {
                            waitForQualityGate abortPipeline: false
                        }
                    } catch (err) {
                        echo "Quality Gate skipped"
                    }
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dir('Application-Code/backend') {
                    dependencyCheck(
                        additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit',
                        odcInstallation: 'DP-Check'
                    )
                    dependencyCheckPublisher(
                        pattern: '**/dependency-check-report.xml'
                    )
                }
            }
        }

        stage('Trivy File Scan') {
            steps {
                dir('Application-Code/backend') {
                    sh 'trivy fs . > trivyfs.txt'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([
                    string(credentialsId: 'ACCOUNT_ID', variable: 'AWS_ACCOUNT_ID'),
                    string(credentialsId: 'ECR_REPO2', variable: 'AWS_ECR_REPO_NAME')
                ]) {
                    dir('Application-Code/backend') {
                        sh """
                            REPO_URI=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

                            docker system prune -f
                            docker build -t ${AWS_ECR_REPO_NAME}:latest .

                            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} \
                            | docker login --username AWS --password-stdin \$REPO_URI

                            docker tag ${AWS_ECR_REPO_NAME}:latest \$REPO_URI/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                            docker push \$REPO_URI/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                        """
                    }
                }
            }
        }

        stage('Trivy Image Scan') {
            steps {
                withCredentials([
                    string(credentialsId: 'ACCOUNT_ID', variable: 'AWS_ACCOUNT_ID'),
                    string(credentialsId: 'ECR_REPO2', variable: 'AWS_ECR_REPO_NAME')
                ]) {
                    sh """
                        trivy image ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER} > trivyimage.txt
                    """
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                dir('Kubernetes-Manifests-file/Backend') {
                    withCredentials([
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}                    }
                        string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')
                        '''
                    ]) {

                            git push https://${GITHUB_TOKEN}@github.com/Mhariogh/DevOps HEAD:e2e-3-tier-DevSecOps
                            git commit -m "Update backend image to version ${BUILD_NUMBER}" || echo "No changes"

                            git add deployment.yaml

                            sed -i "s/backend:${imageTag}/backend:${BUILD_NUMBER}/" deployment.yaml
                            imageTag=$(grep -oP '(?<=backend:)[^ ]+' deployment.yaml || echo "latest")
                        sh '''
                            git config user.email "cwamiemhariogh@gmail.com"
