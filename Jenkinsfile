pipeline {
    agent any

    stages {
        stage('Checkout') { steps { echo 'Checkout...' } }
        stage('Setup') { steps { echo 'Setup...' } }
        stage('Build') { steps { echo 'Build OK' } }
        stage('Docker Run') { steps { echo 'Run container...' } }
        stage('Smoke Test') { steps { echo 'Smoke test...' } }
        stage('Archive') { steps { echo 'Archive...' } }
    }
}
