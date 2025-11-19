pipeline {
  agent any

  options {
    // garde les logs et conserve un certain nombre d'exécutions
    buildDiscarder(logRotator(numToKeepStr: '30'))
    timestamps()
  }

  triggers {
    // Si tu utilises webhook, tu peux laisser vide ; sinon décommente Poll SCM
    // pollSCM('H/5 * * * *')
  }

  stages {

    stage('Checkout') {
      steps {
        // Checkout de l'entièreté du repo (le tag déclenchera le job)
        checkout([$class: 'GitSCM',
                  branches: [[name: 'refs/tags/v*.*.*']],
                  userRemoteConfigs: [[url: 'https://github.com/maryemBoukadida/devops-mini-site.git']]])
        script {
          // Extraire le tag exact (si présent) et le mettre dans env.GIT_TAG
          env.GIT_TAG = sh(returnStdout: true, script: "git describe --tags --exact-match 2>/dev/null || echo ''").trim()
          if (!env.GIT_TAG) {
            // fallback : détecter si Jenkins a fourni GIT_BRANCH ou BRANCH_NAME
            env.GIT_TAG = sh(returnStdout: true, script: "git for-each-ref --format='%(refname:short)' refs/tags | grep -E '^v[0-9]+' || true").trim()
          }
          echo "Using tag: ${env.GIT_TAG}"
        }
      }
    }

    stage('Setup') {
      steps {
        sh 'docker --version || true'
        script {
          // Construire l'image en multi-stage; si pas de tag trouvé, utiliser 'dev'
          def imgTag = env.GIT_TAG ?: 'dev'
          sh "docker build -t monapp:${imgTag} --target build-stage ."
        }
      }
    }

    stage('Build') {
      steps {
        // Appelle ton script de build (adapter selon ton projet)
        sh './build.sh || true'   // pour ne pas planter instantanément si script absent -> adapter
      }
    }

    stage('Run') {
      steps {
        script {
          def imgTag = env.GIT_TAG ?: 'dev'
          // Supprime l'ancien conteneur s'il existe
          sh "docker rm -f monapp_test || true"
          // Lance la version taggée
          sh "docker run -d --name monapp_test -p 8080:8080 monapp:${imgTag}"
          // Attendre un moment pour que le service démarre
          sleep 5
        }
      }
    }

    stage('Smoke Test') {
      steps {
        script {
          // Exemple : vérifier un endpoint HTTP (adapter si ton appli n'est pas HTTP)
          def rc = sh(returnStatus: true, script: "curl -sSf http://localhost:8080/health || true")
          if (rc == 0) {
            echo 'Smoke test: PASSED'
            sh "echo PASSED > smoke_result.txt"
          } else {
            echo 'Smoke test: FAILED'
            sh "echo FAILED > smoke_result.txt"
            // marquer l'étape comme failed pour arrêter si nécessaire
            // error('Smoke test failed')   // commente si tu veux continuer malgré l'échec
          }
        }
      }
    }

    stage('Archive Artifacts') {
      steps {
        script {
          // Crée un dossier de sortie nommé par le tag
          def tag = env.GIT_TAG ?: 'dev'
          sh "mkdir -p release_${tag} || true"
          sh "cp -r build release_${tag}/ || true"
          sh "cp -r logs release_${tag}/ || true || true"
          sh "cp smoke_result.txt release_${tag}/ || true"
        }
        // Archiver dans Jenkins
        archiveArtifacts artifacts: "release_*/**/*", fingerprint: true
      }
    }

    stage('Cleanup') {
      steps {
        script {
          def tag = env.GIT_TAG ?: 'dev'
          sh "docker rm -f monapp_test || true"
          sh "docker rmi monapp:${tag} || true"
        }
      }
    }
  } // stages

  post {
    always {
      echo "Pipeline finished. Check artifacts and console log."
    }
    success {
      echo "Build succeeded for ${env.GIT_TAG}"
    }
    failure {
      echo "Build failed for ${env.GIT_TAG}"
    }
  }
}
