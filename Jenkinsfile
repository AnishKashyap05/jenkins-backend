pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'anish385/dev'
        GCP_USER = 'navgottalla55'
        GCP_VM = '34.93.192.251'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/AnishKashyap05/jenkins-backend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub', url: '']) {
                    sh "docker push $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to GCP VM') {
            steps {
                sshagent(['jenkins-ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no $GCP_USER@$GCP_VM << 'EOF'
                        docker pull $DOCKER_IMAGE
                        docker stop my-react-container || true
                        docker rm my-react-container || true
                        docker run -d --name my-react-container -p 80:80 $DOCKER_IMAGE
                    EOF
                    """
                }
            }
        }
    }
}
