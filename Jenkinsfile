node {
    def app
    def imageName = "mrkotte/docker-loginapp"

    stage('Clone repository') {
        /* Cloning the Repository to our Workspace */
        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image */
        app = docker.build(imageName)
    }

    stage('Run Tests') {
        sh "docker run -t ${imageName} npm test"
    }

    if (env.BRANCH_NAME == "master") {
        stage('Push image') {
            /*
                You would need to first register with DockerHub before you can push images to your account
            */
            steps {
                echo "Trying to Push Docker Build to DockerHub"
                docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                    app.push("latest")
                }
                echo "Pushed image to DockerHub"
            }
        }
    } else {
        echo "Skipped Image pushing step"
    }

    stage('Clean Up') {
        /* Delete the created image from the Jenkins server */
        sh "docker image rm ${imageName}"
    }

}