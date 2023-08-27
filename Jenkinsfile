pipeline {
    environment {
        DOCKER_ID = "lngd" // Replace this with your Docker ID
        DOCKER_IMAGE_MOVIE = "api-movie"
        // DOCKER_TAG = "v.${BUILD_ID}.0"
        DOCKER_TAG = "latest"
    }
    agent any
    stages {
        // stage('Docker Build Movie') {
        //     steps {
        //         script {
        //             sh '''
        //             docker rm -f jenkins-movie
        //             docker build -t $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG ./movie-service
        //             sleep 6
        //             '''
        //         }
        //     }
        // }
        // stage('Docker Run Movie') {
        //     steps {
        //         script {
        //             sh '''
        //             docker run -d -p 80:80 --name jenkins-movie $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
        //             sleep 10
        //             '''
        //         }
        //     }
        // }
        // stage('Test Acceptance Movie') {
        //     steps {
        //         script {
        //             sh '''
        //             curl localhost
        //             docker rm -f jenkins-movie
        //             '''
        //         }
        //     }
        // }
        // stage('Docker Build Cast') {
        //     steps {
        //         script {
        //             sh '''
        //             docker rm -f jenkins-cast
        //             docker build -t $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG ./cast-service
        //             sleep 6
        //             '''
        //         }
        //     }
        // }
        // stage('Docker Run Cast') {
        //     steps {
        //         script {
        //             sh '''
        //             docker run -d -p 80:80 --name jenkins-cast $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG
        //             sleep 10
        //             '''
        //         }
        //     }
        // }
        // stage('Test Acceptance Cast') {
        //     steps {
        //         script {
        //             sh '''
        //             curl localhost
        //             '''
                    
        //         }
        //     }
        // }
        // stage('Docker Push Movie') {
        //     environment {
        //         DOCKER_PASS = credentials("DOCKER_HUB_PASS")
        //     }
        //     steps {
        //         script {
        //             sh "docker login -u $DOCKER_ID -p $DOCKER_PASS"
        //             sh "docker push $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG"
        //             sh "docker logout"
        //         }
        //     }
        // }
        // stage('Docker Push Cast') {
        //     environment {
        //         DOCKER_PASS = credentials("DOCKER_HUB_PASS")
        //     }
        //     steps {
        //         script {
        //             sh "docker login -u $DOCKER_ID -p $DOCKER_PASS"
        //             sh "docker push $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG"
        //             sh "docker logout"
        //         }
        //     }
        // }
        stage('Deploiement en qa Movie') {
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
                    cp helm/api/values-movie.yaml values-movie.yaml
                    cat values-movie.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-movie.yaml
                    helm upgrade --install app ./helm/api --values=values-movie.yaml --namespace qa
                    '''
                }
            }
        }
        stage('Deploiement en qa Cast') {
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
                    cp helm/api/values-cast.yaml values-cast.yaml
                    cat values-cast.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-cast.yaml
                    helm upgrade --install app ./helm/api --values=values-cast.yaml --namespace qa
                    '''
                }
            }
        }
        stage('Deploiement en dev Movie') {
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
                    cp helm/api/values-movie.yaml values-movie.yaml
                    cat values-movie.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-movie.yaml
                    helm upgrade --install app ./helm/api --values=values-movie.yaml --namespace dev
                    '''
                }
            }
        }
        stage('Deploiement en dev Cast') {
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
                    cp helm/api/values-cast.yaml values-cast.yaml
                    cat values-cast.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-cast.yaml
                    helm upgrade --install app ./helm/api --values=values-cast.yaml --namespace dev
                    '''
                }
            }
        }
        stage('Deploiement en staging Movie') {
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
                    cp helm/api/values-movie.yaml values-movie.yaml
                    cat values-movie.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-movie.yaml
                    helm upgrade --install app ./helm/api --values=values-movie.yaml --namespace staging
                    '''
                }
            }
        }
        stage('Deploiement en staging Cast') {
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
                    cp helm/api/values-cast.yaml values-cast.yaml
                    cat values-cast.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-cast.yaml
                    helm upgrade --install app ./helm/api --values=values-cast.yaml --namespace staging
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
                    cp helm/api/values-movie.yaml values-movie.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-movie.yaml
                    cat values-movie.yaml

                    helm upgrade --install app ./helm/api --values=values-movie.yaml --namespace prod
                    '''
                }
            }
        }
        stage('Deploiement en prod Cast') {
            environment {
                KUBECONFIG = credentials("config") // retrieve kubeconfig from secret file called config saved on Jenkins
            }
            when {
                branch 'master'
            }
            steps {
                script {
                    sh '''
                    rm -Rf .kube
                    mkdir .kube
                    ls
                    cat $KUBECONFIG > .kube/config
                    cp helm/api/values-cast.yaml values-cast.yaml
                    cat values-cast.yaml
                    sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values-cast.yaml
                    helm upgrade --install app ./helm/api --values=values-cast.yaml --namespace prod
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



