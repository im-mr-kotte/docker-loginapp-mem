node {
    def dockerImage
    def testContainer
    def imageName = "mrkotte/docker-loginapp"
    def devServerLogin = "ec2-user@13.53.127.68"

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
            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                dockerImage.push("latest")
            }
        }

        stage('Deploy Dev') {
            sshagent(credentials: ['dev-server']) {
                def startDocker = "sudo service docker start"
                def dockrRm = "docker rm -f loginapp"
                def dockrRmImage = "docker rmi  ${imageName}:latest"
                def startNewContainer = "docker run -d -p 9999:9999 --name loginapp ${imageName}:latest"
                sh "ssh -o StrictHostKeyChecking=no ${devServerLogin} ${startDocker}"
                sh "ssh -o StrictHostKeyChecking=no ${devServerLogin} ${dockrRm}"
                sh "ssh -o StrictHostKeyChecking=no ${devServerLogin} ${dockrRmImage}"
                sh "ssh -o StrictHostKeyChecking=no ${devServerLogin} ${startNewContainer}"
            }
            catchError(buildResult: 'FAILURE', stageResult: 'FAILURE') {
               sh "exit 0"
            }
        }
    }

    stage('Clean Up') {
        /* Stop and Delete the test container */
        testContainer.stop()

        /* Delete the built image from the Jenkins server */
        sh "docker image rm ${imageName}"
    }

}