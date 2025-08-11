pipeline {
    agent any

    tools {
        maven 'Maven3' // Must match name in Jenkins -> Global Tool Configuration
        jdk 'JDK11'    // Must match name in Jenkins -> Global Tool Configuration
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
                SONAR_TOKEN = credentials('sonar-token') // Jenkins Credential ID for SonarQube token
            }
            steps {
                withSonarQubeEnv('SonarQube') { // Name must exactly match Jenkins SonarQube server config
                    sh '''
                        mvn sonar:sonar \
                          -Dsonar.projectKey=MyProject \
                          -Dsonar.host.url=https://sonarqjpb.ddns.net \
                          -Dsonar.login=$SONAR_TOKEN
                    '''
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
