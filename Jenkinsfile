pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checkout source from github....'
                checkout scm
                sh "ls -lat"
                sh 'printenv'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building..'
                sh "make rpm"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh "rpm -qlp *.rpm"
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
