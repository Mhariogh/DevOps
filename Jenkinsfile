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
