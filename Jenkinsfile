pipeline {
    agent any

    tools {
        maven 'Maven3' // Name you configured in Jenkins -> Global Tool Configuration
        jdk 'JDK11'    // Name you configured in Jenkins -> Global Tool Configuration
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/kamaal12345/kamaal.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SONARQUBE = credentials('sonar-token') // Jenkins credential ID for SonarQube token
            }
            steps {
                withSonarQubeEnv('MySonarQube') { // 'MySonarQube' is the name in Jenkins SonarQube server config
                    sh "mvn sonar:sonar \
                        -Dsonar.projectKey=my-project-key \
                        -Dsonar.host.url=https://sonarqjpb.ddns.net \
                        -Dsonar.login=${SONARQUBE}"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}

