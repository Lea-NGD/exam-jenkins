pipeline {
    environment {
        DOCKER_ID = "lngd" // Remplacez ceci par votre identifiant Docker
        DOCKER_IMAGE_MOVIE = "api-cast"
        DOCKER_TAG = "v.${BUILD_ID}.0"
    }
    agent any
    stages {
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                    docker rm -f jenkins
                    docker build -t $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG ./movie-service
                    sleep 6
                    '''
                }
            }
        }
        stage('Docker Run') {
            steps {
                script {
                    sh '''
                    docker run -d -p 80:80 --name jenkins-movie $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
                    sleep 10
                    '''
                }
            }
        }
        stage('Test Acceptance') {
            steps {
                script {
                    sh 'curl localhost'
                }
            }
        }
        stage('Docker Push') {
            environment {
                DOCKER_PASS = credentials("DOCKER_HUB_PASS")
            }
            steps {
                script {
                    sh "docker login -u $DOCKER_ID -p $DOCKER_PASS"
                    sh "docker push $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG"
                    sh "docker logout"
                }
            }
        }
stage('Deploiement en qa'){
        environment
        {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
        }
            steps {
                script {
                sh '''
                rm -Rf .kube
                mkdir .kube
                ls
                cat $KUBECONFIG > .kube/config
                cp /helm/api/values-movie.yaml values.yml
                cat values.yml
                sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
                helm upgrade --install app jenkins-api --values=values.yml --namespace qa
                '''
                }
            }

        }
stage('Deploiement en dev'){
        environment
        {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
        }
            steps {
                script {
                sh '''
                rm -Rf .kube
                mkdir .kube
                ls
                cat $KUBECONFIG > .kube/config
                cp /helm/api/values-movie.yaml values.yml
                cat values.yml
                sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
                helm upgrade --install app jenkins-api --values=values.yml --namespace dev
                '''
                }
            }

        }
stage('Deploiement en staging'){
        environment
        {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
        }
            steps {
                script {
                sh '''
                rm -Rf .kube
                mkdir .kube
                ls
                cat $KUBECONFIG > .kube/config
                cp /helm/api/values-movie.yaml values.yml
                cat values.yml
                sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
                helm upgrade --install app jenkins-api --values=values.yml --namespace staging
                '''
                }
            }

        }
stage('Deploiement en prod'){
        environment
        {
        KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
        }
            when {
                expression {
                    return env.BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                sh '''
                rm -Rf .kube
                mkdir .kube
                ls
                cat $KUBECONFIG > .kube/config
                cp /helm/api/values-movie.yaml values.yml
                cat values.yml
                sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
                helm upgrade --install app jenkins-api --values=values.yml --namespace prod
                '''
                }
            }
        }
    post {
        failure {
            echo "This will run if the job failed"
            mail to: "leanugue@gmail.com",
                subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
                body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
            }
        }
    }
}