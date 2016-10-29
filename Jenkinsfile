echo 'hello from Pipeline'

jettyUrl = 'http://localhost:8081/'

stage('Dev') {
    node {
        checkout scm
       // servers = load 'servers.groovy'
       // mvn '-o clean package'
       // dir('target') {stash name: 'war', includes: 'x.war'}
      // sh "rake package"
    }
}

stage('QA') {
    //parallel(longerTests: {
    //    runTests(servers, 30)
    //}, quickerTests: {
    //    runTests(servers, 20)
    //})
}

milestone 1
stage('Staging') {
    lock(resource: 'staging-server', inversePrecedence: true) {
        milestone 2
        node {
           // servers.deploy 'staging'
        }
        input message: "Does ${jettyUrl}staging/ look good?"
    }
    try {
        checkpoint('Before production')
    } catch (NoSuchMethodError _) {
        echo 'Checkpoint feature available in CloudBees Jenkins Enterprise.'
    }
}
