pipeline{
        agent any
        options {
          skipDefaultCheckout true
        }
        environment {
            app_version = 'v1'
            rollback = 'false'
        }
      
          stages{
            stage('Configure Kubectl'){
                steps{
                    withAWS(credentials: 'aws-credentials', region: 'eu-west-2') {
                    sh '''
                    aws eks --region eu-west-2 update-kubeconfig --name sfia2-production
                    '''
            }
          }              
        }                  
                stage('Apply & Deploy with K8'){
                  steps{ 
                    dir('./home/jenkins/SFIA2/kubernetes'){    
                    sh '''
                    kubectl apply -f config-map.yaml
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl apply -f mysql.yaml
                    kubectl apply -f backend.yaml
                    kubectl apply -f frontend.yaml
                    '''
                    }
                } 
                }        
           }

}
