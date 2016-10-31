#!/usr/bin/env groovy

/* Only execute on a node with the 'docker' label, which I use to indicate a
 * running and accessible Docker daemon
 */
node('docker-localhost') {
    /* checkout our source tree at the revision that triggered this pipeline */
    checkout scm

    /* In order to execute our tests, we need a running MongoDB instance.
     * Instead of expecting our Jenkins agents to have MongoDB running and
     * in a clean state, use a Docker container which will be executed in the
     * background (courtesy of the CloudBees Docker Pipeline plugin)
     */
    docker.image('mongodb').withRun { container ->

        /* We need a specific version of Ruby (MRI) available, so execute that
         * in a second Docker container which is going to have our RVM
         * environment and a Ruby pre-installed already.
         *
         * The `inside` parameters also allow for linking with our `postgres`
         * container, allowing the steps executed inside the 'rvm' container to
         * interact with the PostgreSQL daemon running inside the 'postgres'
         * container
         */
        docker.image('rtyler/rvm:2.3.0').inside("--link=${container.id}:mongodb") {

            /* There are specific packages we need to execute RSpec for this
             * project, they are largely system dependencies that our gems
             * depend on (e.g. capybara-webkit) for testing the project
             *
             * This could be baked into the container at one point, which would
             * make the pipeline execute faster, but leaving it here for
             * demonstration purposes
             */
            stage 'Prepare Container'
            sh 'sudo apt-get install -qy xvfb node libxslt-dev libxml2-dev libpq-dev postgresql-client qt5-default qt5-qmake libqt5webkit5-dev qtdeclarative5-dev'

            stage 'Install Gems'
            rvm 'gem install bundler -N'
            /* Tell nokogiri to avoid compiling its built-in libraries in favor
             * of what we already have installed
             */
            withEnv(['NOKOGIRI_USE_SYSTEM_LIBRARIES=true']) {
                rvm 'bundle install'
            }

            stage 'Prepare Database'
            sh "psql -c 'create database cfp_app_test;' --username=postgres --host=postgres"

            withEnv(['DATABASE_URL=postgres://postgres@postgres:5432/']) {

                /* Invoke rake(1) which drives the DB scaffolding and test
                 * execution
                 */
                stage 'Rake'
                rvm 'xvfb-run bundle exec rake || true'

                /* Since we used the ci_reporter gem, our JUnit-compatible test
                 * reports were saved into `spec/reports/`, allowing us to get
                 * trends and prettier Test Reports in the Jenkins UI
                 */
                junit 'spec/reports/*.xml'
            }

            stage 'Security scan'
            /* Invoke `brakeman` a Rails security scanner and utilize the
             * `publishBrakeman` step provided by the Brakeman plugin to add
             * security reports to our page in Jenkins
             */
            rvm 'brakeman -o brakeman-output.tabs --no-progress --separate-models'
            publishBrakeman 'brakeman-output.tabs'
        }
    }

    stage 'Deploy'
    /* Only deploy if we have a successful build */
    if (currentBuild.result == 'SUCCESS') {
        echo 'Pretend this invokes `git push heroku` or some analogue'
    }
    else {
        echo 'Something is awry, no deployment!'
    }
}

/* Small helper command to execute a `sh` step with RVM pre-loaded and our
 * proper Ruby selected
 */
def rvm(String commands) {
    //sh "bash -c 'source ~/.rvm/scripts/rvm && rvm use 2.3.0 && ${commands}'"
    sh "bash -c '${commands}'"
}
