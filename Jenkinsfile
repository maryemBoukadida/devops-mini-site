pipeline {
    agent any

    environment {
        APP_NAME = "monapp"
        TAG = "dev"     // car env.BRANCH_NAME est null dans ton job
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
                bat 'docker --version'
            }
        }

        stage('Build') {
            steps {
                echo "Build project..."

                bat """
                    mkdir build
                    echo Build completed at %DATE% %TIME% > build\\build.log
                """
            }
        }

        stage('Docker Run') {
            steps {
                echo "Building and running Docker container..."

                bat """
                    docker rm -f monapp_test || echo OK
                    docker build -t %APP_NAME%:%TAG% .
                    docker run -d --name monapp_test -p 8080:8080 %APP_NAME%:%TAG%
                """

                sleep 5
            }
        }

        stage('Smoke Test') {
            steps {
                echo "Running smoke tests..."

                bat """
                    scripts\\smoke-test.bat
                """
            }
        }

        stage('Archive') {
            steps {
                echo "Archiving artifacts..."

                bat """
                    mkdir release_%TAG%
                    xcopy build release_%TAG%\\build /E /I /Y
                    copy smoke_result.txt release_%TAG%\\
                """

                archiveArtifacts artifacts: "release_${TAG}/**/*", fingerprint: true
            }
        }

        stage('Cleanup') {
            steps {
                echo "Cleaning up Docker..."

                bat """
                    docker rm -f monapp_test || echo OK
                    docker rmi %APP_NAME%:%TAG% || echo OK
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline finished for branch ${TAG}"
        }
    }
}
