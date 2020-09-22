
pipeline{
        agent any
        stages{
            stage('SSH into VM'){
                steps{
                    sh "ssh adamakcontact@35.246.66.234 /bin/bash"
                }
            }    
            stage('Clone Repository'){
                steps{
                    sh "ssh adamakcontact@35.246.66.234 <<EOF cd SFIA2 || git clone https://github.com/adamal5/SFIA2/ EOF"
                }
            }
            stage('Install Docker and Docker Compose'){
                steps{
                    sh '''
                     ssh adamakcontact@35.246.66.234 /bin/bash <<EOF
                     curl https://get.docker.com | sudo bash 
                     sudo usermod -aG docker $(whoami)
                     sudo apt update
                     sudo apt install -y curl jq
                     version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name') 
                     sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
                     sudo chmod +x /usr/local/bin/docker-compose 
                     
                     EOF
                     '''
                }
            }
            stage('Deploy Application'){
                steps{
                    sh '''
                    ssh adamakcontact@35.246.66.234 /bin/bash <<EOF
                    cd SFIA2
                    export DB_PASSWORD='password' 
                    export DATABASE_URI='mysql+pymysql://root:password@mysql:3306/users'
                    export TEST_DATABASE_URI='mysql+pymysql://root:password@mysql:3306/testdb'
                    export SECRET_KEY='abcd'
                    export MYSQL_ROOT_PASSWORD='password'
                    docker-compose pull
                    docker-compose up -d
                    
                    EOF
                    '''
                }
            }
        }    
}
