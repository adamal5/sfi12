pipeline{
        agent any
        environment {
            app_version = 'v1'
            rollback = 'false'
        }
        stages{
            stage('Install Docker and Docker Compose'){
                steps{
                    sh '''
                    curl https://get.docker.com | sudo bash 
                    sudo usermod -aG docker $(whoami)
                    sudo apt update
                    sudo apt install -y curl jq
                    version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
                    sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                    sudo chmod +x /usr/local/bin/docker-compose
                    sudo chmod 666 /var/run/docker.sock
                    '''
  
            }
        }
            stage('Clone Git Repo If Not Present or CD into Folder'){
                steps{
                    sh '''
                    cd SFIA2
                    '''
            }
        }
      
            stage('Build FrontImage'){
                steps{ 
                    sh "cd SFIA2/frontend"      
                    script{
                        if (env.rollback == 'false'){
                            sh "cd SFIA2/frontend"
                            frontendimage = docker.build("adamal5/sfia2-frontend")
                        }
                    }
                }          
            }
                
            stage('Build Backend Image'){
                steps{ 
                    sh "cd SFIA2/backend"    
                    script{
                        if (env.rollback == 'false'){
                            backendimage = docker.build("adamal5/sfia2-backend")
                        }
                    }
                }          
            }  
                
            stage('Build Database Image'){
                steps{
                    sh "cd SFIA2/database"     
                    script{
                        if (env.rollback == 'false'){
                            databaseimage = docker.build("adamal5/sfia2-database")
                        }
                    }
                }          
            } 
                
            stage('Tag & Push Images'){
                steps{
                    script{
                        if (env.rollback == 'false'){
                            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials'){
                                frontendimage.push("${env.app_version}")
                                backendimage.push("${env.app_version}")
                                databaseimage.push("${env.app_version}")    
                            }
                        }
                    }
                }          
            }
            stage('Deploy App'){
                steps{
                    sh '''
                    ssh ubuntu@ip-172.31.8.181 <<EOF
                    cd SFIA2
                    export DB_PASSWORD='password'
                    export DATABASE_URI='mysql+pymysql://root:password@mysql:3306/users'
                    export TEST_DATABASE_URI='mysql+pymysql://root:password@mysql:3306/testdb'
                    export SECRET_KEY='abcd'
                    export MYSQL_ROOT_PASSWORD='password'
                    export app_version=v1
                    docker-compose pull
                    docker-compose up -d
EOF
                    '''
                    }
                }   
            stage('Run Frontend Test'){
                steps{
                    sh '''
                    ssh ubuntu@ip-172.31.8.181 <<EOF
                    sleep 20
                    cd SFIA2/frontend/tests
                    docker-compose exec -T frontend pytest --cov application > frontend-test.txt
EOF
                    '''
                    }
                }                 
            stage('Run Backend Test'){
                steps{
                    sh '''
                    ssh ubuntu@ip-172.31.8.181 <<EOF
                    cd SFIA2/backend/tests
                    docker-compose exec -T backend pytest --cov application > backend-test.txt

EOF
                    '''
                    }
                }                 
            }

        } 

