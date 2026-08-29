pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-1'
        AWS_ACCOUNT_ID = '904053119758'
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        ECR_PREFIX = "${ECR_REGISTRY}/med-erp"
        EKS_CLUSTER = 'med-erp-dev-eks'
        K8S_NAMESPACE = 'med-erp'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend') {
            steps {
                sh '''
                    set -e

                    for SERVICE in user-service product-service order-service; do
                        echo "===== Building $SERVICE ====="
                        cd $WORKSPACE/$SERVICE

                        chmod +x mvnw 2>/dev/null || true

                        if [ -f mvnw ]; then
                            ./mvnw clean package -DskipTests
                        else
                            mvn clean package -DskipTests
                        fi
                    done
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    set -e

                    TAG="v1.0.${BUILD_NUMBER}"

                    docker build \
                      -t ${ECR_PREFIX}/user-service:${TAG} \
                      -t ${ECR_PREFIX}/user-service:latest \
                      ./user-service

                    docker build \
                      -t ${ECR_PREFIX}/product-service:${TAG} \
                      -t ${ECR_PREFIX}/product-service:latest \
                      ./product-service

                    docker build \
                      -t ${ECR_PREFIX}/order-service:${TAG} \
                      -t ${ECR_PREFIX}/order-service:latest \
                      ./order-service

                    echo "Images built successfully"
                    docker images | grep med-erp
                '''
            }
        }

        stage('ECR Login') {
            steps {
                sh '''
                    aws ecr get-login-password \
                      --region ${AWS_REGION} | \
                    docker login \
                      --username AWS \
                      --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Images') {
            steps {
                sh '''
                    set -e

                    TAG="v1.0.${BUILD_NUMBER}"

                    docker push ${ECR_PREFIX}/user-service:${TAG}
                    docker push ${ECR_PREFIX}/user-service:latest

                    docker push ${ECR_PREFIX}/product-service:${TAG}
                    docker push ${ECR_PREFIX}/product-service:latest

                    docker push ${ECR_PREFIX}/order-service:${TAG}
                    docker push ${ECR_PREFIX}/order-service:latest
                '''
            }
        }

        stage('EKS Deploy') {
            steps {
                sh '''
                    set -e

                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER}

                    TAG="v1.0.${BUILD_NUMBER}"

                    kubectl -n ${K8S_NAMESPACE} set image \
                      deployment/user-service \
                      user-service=${ECR_PREFIX}/user-service:${TAG}

                    kubectl -n ${K8S_NAMESPACE} set image \
                      deployment/product-service \
                      product-service=${ECR_PREFIX}/product-service:${TAG}

                    kubectl -n ${K8S_NAMESPACE} set image \
                      deployment/order-service \
                      order-service=${ECR_PREFIX}/order-service:${TAG}
                '''
            }
        }

        stage('Rollout Verification') {
            steps {
                sh '''
                    set -e

                    kubectl rollout status deployment/user-service \
                      -n ${K8S_NAMESPACE} --timeout=180s

                    kubectl rollout status deployment/product-service \
                      -n ${K8S_NAMESPACE} --timeout=180s

                    kubectl rollout status deployment/order-service \
                      -n ${K8S_NAMESPACE} --timeout=180s

                    echo "===== PODS ====="
                    kubectl get pods -n ${K8S_NAMESPACE} -o wide

                    echo "===== DEPLOYMENTS ====="
                    kubectl get deployment -n ${K8S_NAMESPACE}

                    echo "===== INGRESS ====="
                    kubectl get ingress -n ${K8S_NAMESPACE}
                '''
            }
        }
    }

    post {
        success {
            echo 'MED-ERP CI/CD PIPELINE SUCCESS'
        }

        failure {
            echo 'MED-ERP CI/CD PIPELINE FAILED'
        }
    }
}
