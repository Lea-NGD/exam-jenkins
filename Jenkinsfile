pipeline {
environment { // Declaration of environment variables
DOCKER_ID = "lngd" // replace this with your docker-id
DOCKER_IMAGE_CAST = "api-movie"
DOCKER_IMAGE_MOVIE = "api-cast"
DOCKER_TAG = "v.${BUILD_ID}.0" // we will tag our images with the current build in order to increment the value by 1 with each new build
}
agent any // Jenkins will be able to select all available agents
stages {
        stage('Docker Build'){ // docker build image stage
            parallel {
                stage('Test On Movie Service') {
                    agent { label "movie" }
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
                stage('Test On Cast Service') {

                    agent { label "movie" }
                    steps {
                        script {
                        sh '''
                        docker rm -f jenkins
                        docker build -t $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG ./cast-service
                        sleep 6
                        '''
                            }
                        }
                }
        }
        stage('Docker run'){ // run container from our builded image
                steps {
                    script {
                    sh '''
                    docker run -d -p 8001:8001 --name jenkins-movie $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
                    sleep 10
                    '''
                    sh '''
                    docker run -d -p 8002:8002 --name jenkins-cast $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG
                    sleep 10
                    '''
                    }
                }
            }

        stage('Test Acceptance'){ // we launch the curl command to validate that the container responds to the request
            steps {
                    script {
                    sh '''
                    curl 52.49.107.170:8001
                    '''
                    }
                    script {
                    sh '''
                    curl 52.49.107.170:8002
                    '''
                    }
            }

        }
        stage('Docker Push'){ //we pass the built image to our docker hub account
            environment
            {
                DOCKER_PASS = credentials("DOCKER_HUB_PASS") // we retrieve  docker password from secret text called docker_hub_pass saved on jenkins
            }

            steps {

                script {
                sh '''
                docker login -u $DOCKER_ID -p $DOCKER_PASS
                docker push $DOCKER_ID/$DOCKER_IMAGE_MOVIE:$DOCKER_TAG
                '''
                sh '''
                docker login -u $DOCKER_ID -p $DOCKER_PASS
                docker push $DOCKER_ID/$DOCKER_IMAGE_CAST:$DOCKER_TAG
                '''
                }
            }

        }

// stage('Deploiement en qa'){
//         environment
//         {
//         KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
//         }
//             steps {
//                 script {
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-movie.yaml values.yml
//                 cat values.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace qa
//                 '''
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-cast.yaml values.yml
//                 cat values.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace qa
//                 '''
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-nginx.yaml values.yml
//                 cat values.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace qa
//                 '''
//                 }
//             }

//         }
// stage('Deploiement en dev'){
//         environment
//         {
//         KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
//         }
//             steps {
//                 script {
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-movie.yaml values.yml
//                 cat values-movie.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace dev
//                 '''
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-cast.yaml values.yml
//                 cat values-movie.yml
//                 cat values-cast.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace dev
//                 '''
//                 }
//             }

//         }
// stage('Deploiement en staging'){
//         environment
//         {
//         KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
//         }
//             steps {
//                 script {
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-movie.yaml values.yml
//                 cat values-movie.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace staging
//                 '''
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-cast.yaml values.yml
//                 cat values-movie.yml
//                 cat values-cast.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace staging
//                 '''
//                 }
//             }

//         }
//   stage('Deploiement en prod'){
//         environment
//         {
//         KUBECONFIG = credentials("config") // we retrieve  kubeconfig from secret file called config saved on jenkins
//         }
//             when {
//                 expression {
//                     return env.BRANCH_NAME == 'master'
//                 }
//             }
//             steps {
//                 script {
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-movie.yaml values.yml
//                 cat values-movie.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace prod
//                 '''
//                 sh '''
//                 rm -Rf .kube
//                 mkdir .kube
//                 ls
//                 cat $KUBECONFIG > .kube/config
//                 cp jenkins-api/values-cast.yaml values.yml
//                 cat values-movie.yml
//                 cat values-cast.yml
//                 sed -i "s+tag.*+tag: ${DOCKER_TAG}+g" values.yml
//                 helm upgrade --install app jenkins-api --values=values.yml --namespace prod
//                 '''
//                 }
//             }
        // }
}
post { // send email when the job has failed
    // ..
    failure {
        echo "This will run if the job failed"
        mail to: "leanugue@gmail.com",
             subject: "${env.JOB_NAME} - Build # ${env.BUILD_ID} has failed",
             body: "For more info on the pipeline failure, check out the console output at ${env.BUILD_URL}"
    }
    // ..
}
}