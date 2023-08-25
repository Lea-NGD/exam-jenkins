pipeline {
    environment {
    }
    agent any
    stages {
        stage('Service Cast') {
            when { changeset "cast-service/*"}
            steps {
                sh "make deploy-cast"
            }
        }
        stage('Service Movie') {
            when { changeset "cast-movie/*"}
            steps {
                sh "make deploy-movies"
            }
        }
    }
}

