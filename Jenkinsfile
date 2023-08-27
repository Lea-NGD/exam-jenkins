pipeline {
    environment {
        DOCKER_ID = "lngd" // Replace this with your Docker ID
        DOCKER_IMAGE_MOVIE = "api-movie"
        DOCKER_TAG = "v.${BUILD_ID}.0"
    }
    agent any
    stages {
        stage('Docker Build') {
            steps {
                script {
                    sh '''
                    docker rm -f jenkins-movie
                    docker rm -f jenkins-cast
                    docker build -t $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG ./movie-service
                    docker build -t $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG ./cast-service
                    sleep 6
                    '''
                }
            }
        }
        stage('Docker Run and Test') {
            steps {
                script {
                    sh '''
                    docker run -d -p 80:8000 --name jenkins-movie $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
                    sleep 10
                    curl localhost
                    docker run -d -p 80:8000 --name jenkins-cast $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG
                    sleep 10
                    curl localhost
                    '''
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
                    sh "docker login -u $DOCKER_ID -p $DOCKER_PASS"
                    sh "docker push $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG"
                    sh "docker logout"
                }
            }
        }
        stage('Deploiement en qa') {
            environment {
                KUBECONFIG = credentials("config") // retrieve kubeconfig from secret file called config saved on Jenkins
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    ls
                    cat $KUBECONFIG > .kube/config
                    cp helm/api/values.yaml values.yaml
                    cat values.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yaml
                    helm upgrade --install app ./helm/api --values=values.yaml --namespace qa
                    '''
                }
            }
        }
        stage('Deploiement en dev') {
            environment {
                KUBECONFIG = credentials("config") // retrieve kubeconfig from secret file called config saved on Jenkins
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    ls
                    cat $KUBECONFIG > .kube/config
                    cp helm/api/values.yaml values.yaml
                    cat values.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yaml
                    helm upgrade --install app ./helm/api --values=values.yaml --namespace dev
                    '''
                }
            }
        }
        stage('Deploiement en staging') {
            environment {
                KUBECONFIG = credentials("config") // retrieve kubeconfig from secret file called config saved on Jenkins
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    ls
                    cat $KUBECONFIG > .kube/config
                    cp helm/api/values.yaml values.yaml
                    cat values.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yaml
                    helm upgrade --install app ./helm/api --values=values.yaml --namespace staging
                    '''
                }
            }
        }
        stage('Deploiement en prod Movie') {
            environment {
                KUBECONFIG = credentials("config") // retrieve kubeconfig from secret file called config saved on Jenkins
            }
            when {
                expression {
                    return env.GIT_BRANCH == 'master'
                }
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    ls
                    cat $KUBECONFIG > .kube/config
                    cp helm/api/values.yaml values.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yaml
                    cat values.yaml

                    helm upgrade --install app ./helm/api --values=values.yaml --namespace prod
                    '''
                }
            }
        }
    }
    // post {
    //     failure {
    //         echo "This will run if the job failed"
    //         mail to: "leanugue@gmail.com",
    //             subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
    //             body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    //     }
    // }
}



