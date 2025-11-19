pipeline {
    agent any

    environment {
        APP_NAME = "monapp"
        TAG = "${env.BRANCH_NAME}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                echo "Code checked out from ${TAG}"
            }
        }

        stage('Setup') {
            steps {
                echo "Setup environment..."
                sh 'docker --version'
            }
        }

        stage('Build') {
            steps {
                echo "Build project..."

                sh '''
                    mkdir -p build
                    echo "Build completed at $(date)" > build/build.log
                '''
            }
        }

        stage('Docker Run') {
            steps {
                echo "Building and running Docker container..."

                sh '''
                    docker rm -f monapp_test || true
                    docker build -t ${APP_NAME}:${TAG} .
                    docker run -d --name monapp_test -p 8080:8080 ${APP_NAME}:${TAG}
                '''

                sleep 5
            }
        }

        stage('Smoke Test') {
            steps {
                echo "Running smoke tests..."

                sh '''
                    chmod +x scripts/smoke-test.sh
                    ./scripts/smoke-test.sh
                '''
            }
        }

        stage('Archive') {
            steps {
                echo "Archiving artifacts..."

                sh '''
                    mkdir -p release_${TAG}
                    cp -r build release_${TAG}/
                    cp smoke_result.txt release_${TAG}/
                '''

                archiveArtifacts artifacts: "release_${TAG}/**/*", fingerprint: true
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up Docker..."
                sh '''
                    docker rm -f monapp_test || true
                    docker rmi ${APP_NAME}:${TAG} || true
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished for branch ${TAG}"
        }
    }
}
