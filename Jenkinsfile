node {
    def dockerImage
    def testContainer
    def imageName = "mrkotte/docker-loginapp"

    stage('Clone repository') {
        /* Cloning the Repository to our Workspace */
        checkout scm
    }

    stage('Build image') {
        /*
            below will execute: "docker build -t imageName"
        */
        dockerImage = docker.build(imageName)
    }

    stage('Run Tests') {
        /*
            below will execute: "docker run -t --name ${testContainerName} ${imageName} npm test"
        */
        testContainer = dockerImage.run("-t", "npm test")
    }

    if (env.BRANCH_NAME == "master") {
        stage('Push image') {
            /*
                You would need to first register with DockerHub before you can push images to your account
            */
            steps{
                docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                                dockerImage.push("latest")
                            }
            }
        }
    } else {
        echo "Skipped Image pushing step"
    }

    stage('Clean Up') {
        /* Delete the test container and built image from the Jenkins server */
        testContainer.stop

        /* Delete the built image from the Jenkins server */
        sh "docker image rm ${imageName}"
    }

}