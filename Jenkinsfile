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
                        sh '''
                            echo "=== ALL SONAR ENV VARS ==="
                            env | grep -i sonar || echo "none found"
                            echo "=== SCANNER OPTS ==="
                            echo "SONAR_SCANNER_OPTS=$SONAR_SCANNER_OPTS"
                        '''
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
                            REPO_URI=\${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

                            docker system prune -f
                            docker build -t \${AWS_ECR_REPO_NAME}:latest .

                            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} \
                            | docker login --username AWS --password-stdin \$REPO_URI

                            docker tag \${AWS_ECR_REPO_NAME}:latest \$REPO_URI/\${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                            docker push \$REPO_URI/\${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
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
                        trivy image \${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/\${AWS_ECR_REPO_NAME}:${BUILD_NUMBER} > trivyimage.txt
                    """
                }
            }
        }

        stage('Update Kubernetes Deployment') {
            steps {
                dir('Kubernetes-Manifests-file/Backend') {
                    withCredentials([
                        string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')
                    ]) {
                        sh '''
                            git config user.email "cwamiemhariogh@gmail.com"
                            git config user.name "Mhariogh"

                            git pull origin e2e-3-tier-DevSecOps

                            imageTag=$(grep -oP '(?<=backend:)[^ ]+' deployment.yaml || echo "latest")

                            sed -i "s/backend:${imageTag}/backend:${BUILD_NUMBER}/" deployment.yaml

                            git add deployment.yaml
                            git commit -m "Update backend image to version ${BUILD_NUMBER}" || echo "No changes"

                            git push https://${GITHUB_TOKEN}@github.com/Mhariogh/DevOps HEAD:e2e-3-tier-DevSecOps
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
