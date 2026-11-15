
pipeline {
    agent any

    tools {
        jdk 'jdk17'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        APP_NAME = 'BoardGame'
    }

    stages {

        // 1. Git Checkout
        stage('Git Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'git-cred',
                    url: 'https://github.com/GowthamReddy999/Boardgame.git'
            }
        }

        // 2. Prepare Trivy HTML Template
        stage('Prepare Trivy HTML Template') {
            steps {
                sh '''
                    curl -fsSL \
                    https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl \
                    -o html.tpl

                    ls -l html.tpl
                '''
            }
        }

        // 3. Compile
        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        // 4. Test Cases
        stage('Test-Cases') {
            steps {
                sh 'mvn test'
            }
        }

        // 5. File System Scan
        stage('File System Scan') {
            steps {
                sh '''
                    trivy fs \
                    --format template \
                    --template "@html.tpl" \
                    -o trivy-fs-report.html .
                '''
            }
        }

        // 6. SonarQube Analysis
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        $SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=BoardGame \
                        -Dsonar.projectKey=BoardGame \
                        -Dsonar.java.binaries=target/classes
                    '''
                }
            }
        }

        // 7. Quality Gate
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate(
                        abortPipeline: false,
                        credentialsId: 'sonar-token'
                    )
                }
            }
        }

        // 8. Maven Build
        stage('Build') {
            steps {
                sh 'mvn package'
            }
        }

        // 9. Publish to Nexus
        stage('Publish To Nexus') {
            steps {
                withMaven(
                    globalMavenSettingsConfig: 'global-settings',
                    jdk: 'jdk17',
                    maven: 'maven3',
                    traceability: true
                ) {
                    sh 'mvn deploy'
                }
            }
        }

        // 10. Build Docker Image
        stage('Build & Tag Docker Image') {
            steps {
                script {
                    withDockerRegistry(
                        credentialsId: 'docker-cred',
                        toolName: 'Docker'
                    ) {
                        sh '''
                            docker build \
                            -t reddy0507/BoardGame:latest .
                        '''
                    }
                }
            }
        }

        // 11. Docker Image Scan
        stage('Docker Image Scan') {
            steps {
                sh '''
                    trivy image \
                    --format template \
                    --template "@html.tpl" \
                    -o trivy-image-report.html \
                    reddy0507/BoardGame:latest
                '''
            }
        }

        // 12. Push Docker Image
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(
                        credentialsId: 'docker-cred',
                        toolName: 'Docker'
                    ) {
                        sh 'docker push reddy0507/BoardGame:latest'
                    }
                }
            }
        }

        // 13. Deploy to Kubernetes
        stage('Deploy To Kubernetes') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'Kubernetes',
                    contextName: '',
                    credentialsId: 'k8s-cred',
                    namespace: 'webapps',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://172.31.3.17:6443'
                ) {
                    sh 'kubectl apply -f deployment-service.yaml'
                }
            }
        }

        // 14. Display Pods
        stage('Display Pods') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'Kubernetes',
                    contextName: '',
                    credentialsId: 'k8s-cred',
                    namespace: 'webapps',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://172.31.3.17:6443'
                ) {
                    sh 'kubectl get pods -n webapps'
                }
            }
        }

        // 15. Display Services
        stage('Display Services') {
            steps {
                withKubeConfig(
                    caCertificate: '',
                    clusterName: 'Kubernetes',
                    contextName: '',
                    credentialsId: 'k8s-cred',
                    namespace: 'webapps',
                    restrictKubeConfigAccess: false,
                    serverUrl: 'https://172.31.3.17:6443'
                ) {
                    sh 'kubectl get svc -n webapps'
                }
            }
        }
    }

    // EMAIL NOTIFICATION
    post {

        always {
            script {

                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.currentResult
                def buildUrl = env.BUILD_URL

                // Check which Trivy reports exist
                def reports = []

                if (fileExists('trivy-fs-report.html')) {
                    reports.add('trivy-fs-report.html')
                }

                if (fileExists('trivy-image-report.html')) {
                    reports.add('trivy-image-report.html')
                }

                // Email body
                def body = """
                <html>
                <body style="font-family: Arial, sans-serif;">

                    <h2>Jenkins Build Notification</h2>

                    <p>Hello,</p>

                    <p>Your Jenkins pipeline has completed.</p>

                    <p><b>Project:</b> ${jobName}</p>

                    <p><b>Application:</b> ${env.APP_NAME}</p>

                    <p><b>Build Number:</b> ${buildNumber}</p>

                    <p><b>Build Status:</b> ${pipelineStatus}</p>

                    <p>
                        Check the build details here:
                        <a href="${buildUrl}">View Jenkins Build</a>
                    </p>

                    <h3>Trivy Security Reports</h3>

                    <p>1. File System Scan Report</p>

                    <p>2. Docker Image Scan Report</p>

                    <p>Both reports are attached when available.</p>

                    <br>

                    <p>Regards,</p>
                    <p>Jenkins CI/CD Pipeline</p>

                </body>
                </html>
                """

                // Send email
                emailext(
                    subject: "Jenkins Build ${buildNumber} - ${pipelineStatus}",
                    body: body,
                    to: 'gowthamavula0906@gmail.com',
                    mimeType: 'text/html',
                    attachmentsPattern: reports.join(',')
                )
            }
        }
    }
}
