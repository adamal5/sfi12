pipeline{
        agent any
        environment {
            app_version = 'v1'
            rollback = 'false'
        }
        stages{
            stage('Install Docker and Docker-Compose'){
                steps{
                    sh '''
                    ssh adamakcontact@35.189.85.9 <<EOF
                    curl https://get.docker.com | sudo bash 
                    sudo usermod -aG docker $(whoami)
                    sudo apt update
                    sudo apt install -y curl jq
                    version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
                    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    sudo chmod +x /usr/local/bin/docker-compose
                    sudo chmod 666 /var/run/docker.sock
EOF
                    '''
  
            }
        }
            stage('clone repo and change directory'){
                steps{
                    sh '''
                    ssh adamakcontact@35.189.85.9 <<EOF
                    git clone https://github.com/adamal5/SFIA2.git
                    cd SFIA2
EOF
                    '''
            }
        }
      
            stage('Build frontend Image'){
                steps{
                    script{
                        if (env.rollback == 'false'){
                            sh '''
                            ssh adamakcontact@35.189.85.9 <<EOF
                            cd SFIA2/frontend
                            docker build -t frontend . 
EOF
                            '''
                        }
                    }
                }          
            }
            stage('Deploy App'){
                steps{
                    sh '''
                    ssh adamakcontact@35.189.85.9 <<EOF
                    cd SFIA2
                    export DB_PASSWORD='password'
                    export DATABASE_URI='mysql+pymysql://root:password@mysql:3306/users'
                    export TEST_DATABASE_URI='mysql+pymysql://root:password@mysql:3306/testdb'
                    export SECRET_KEY='abcd'
                    export MYSQL_ROOT_PASSWORD='password'
                    export app_version=v1
                    docker-compose up -d
EOF
                    '''
                    }
                }   
            stage('Run Frontend Test'){
                steps{
                    sh '''
                    ssh adamakcontact@35.189.85.9 <<EOF
                    cd SFIA2/frontend/tests
                    docker-compose exec -T frontend pytest --cov application > frontend-test.txt
EOF
                    '''
                    }
                }                 
            stage('Run Backend Test'){
                steps{
                    sh '''
                    ssh adamakcontact@35.189.85.9 <<EOF
                    cd SFIA2/backend/tests
                    docker-compose exec -T backend pytest --cov application > backend-test.txt

EOF
                    '''
                    }
                }                 
            }

        } 

