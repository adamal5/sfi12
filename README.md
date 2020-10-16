# SFIA2 Project :
## DevOps

### Contents 
* Project Brief 
  * Objective
  * Minimum Requirements
  * Constraints 
* Risk Assessment 
* Project Tracking 
* Architecture 
* Testing 
* Improvements
* Resources
* Acknowledgements
* Authors

### Project Brief
**Objective:** 

To effciently deploy a working application with use of an an engineered continuous integration pipeline. One must use this to demonstrate an understanding of best practices, key concepts, tools and methodologies as outlined in the _QA Cloud Native_ core modules. 

**Minimum Requirements:** 
1. Demonstrate agile working through devloped a Jira kanban board, including tracking issues or risks faced
2. Detailed risk assessment
3. Python application deployed using containerisation and orchestration tools  
4. Automated testing of the application achieved through a CI Pipeline
5. Use of two managed databases: TESTING and DEVELOPMENT
6. Integration of Webhooks to trigger new builds when changes are made to code
7. Infrastructure management tools employed to configure the project environments 
8. Create and use an ansible playbook to provision the CI Server environment 
9. The deployed application must make use of a reverse proxy to allow public access to the application

**Constraints:**
| Technology               | Constraint  |
| -----------              | ----------- |
| Kanban Board             | Jira        |
| Version Control          | Git|
| CI Server                | Jenkins |
| Configuration Management | Ansible |
| Cloud Server             | AWS EC2 |
| Database Server          | AWS RDS |
| Containerisation         | Docker  |
| Reverse Proxy            | NGINX  |
| Orchestration Tool       | Kubernetes  |
| Infrastructure Management| Terraform  |

### Risk Assessment 
A full risk assessment was carried out before project commencenment and was monitored throughout. It includes mitigation at present but additionally, proposed mitigation in the event of more time and resources. The assessment includes risks associated with developer and technologies employed. 

The risk assessment for this project can be found in full here:
https://docs.google.com/spreadsheets/d/1DwCxxrg-kMp8HfaBWx4tTm-awV12buH7oCKW2RowsOY/edit?usp=sharing


### Project Tracking 
Jira's Kanban board was employed to track project progress, in line with agile working principles. 

The full board with all tasks can be found at the following link:



### Architecture
**Application**

The application being deployed is a simple flask application that employs a frontend, backend and database. Access to the application is achieved through a reverse proxy, nginx. 

**Terraform**

The first tool used in the deployment of this application was terraform. Terraform is used here to provision all the resources required to test and deploy this flask application. Terraform was employed as once the .tf files are created and configured it allows for the provisioning of environments with the same foundation every time regardless of the skill or knowledge base of the user, additionally the removal of the developer in the process of environment provsiioning removes an opportunity for human error to affect the project deployment. The environments provisioned using the terraform files in this repository include:

1. 2 AWS Instances, one which hosts Jenkins and the other which host the appliction test environment 
2. 2 AWS Relational Databases, one for testing and one for production. 
3. 1 AWS Kubernetes Cluster for application production

Additionally with the output.tf file (containing key information for use in later stages such as the database endpoint and instance external ip) can be extracted and placed into a local file to be transferred for use in other environments.

**Ansible**

The second technology employed was ansible, whilst terraform was used to provision the enviornments ansible was used to configure them, another layer of automation. The Ansible playbook in this repository accesses the Jenkins instance and downloads and installs Jenkins, creates a user and copies the file with the variables to the Jenkins instance. This is achieved through a simple script (start.sh) which automates these steps on behalf of the developer. The test-playbook is used to configure the test environment instance including installing docker and docker compose and cloning the repository. 

**Jenkins**

Jenkins was the continous integration platform of choice for this project. The corresponding Jenkinsfiles were designed to automate the process of confguring environments with the approproate respositories, dependencies and packages to allow for the deployment and testing of the application in developent before triggering the automatic deployment of the production environment subject to test results. 

Two pipelines are run in Jenkins- serving the development and master branch of the git hub repository that is home to the application. Jenkins improves the effciency of the development to deployment pipeline for a number of reasosn. It can be triggered manually or better yet with webhooks by making a change to the development branch of the repository which will in turn trigger the process of building, deploying and tetsing the app- as is the case with this project. The workflow is designed to allow testing and deployment of the app largely independent of the developers.

Jenkins Plugins used:
1. Docker Pipeline
2. AWS Pipeline
3. Pipeline Utility

**Docker**

Docker was employed in this project as the containerisation tool of choice, allowing for the building of container environments that can be replicated and scaled quickly. By isolating the tasks of the application into these containers each function(s) can be manipulated without causing damage to other taks/ containers. Their structure means they are lightweight and can be easily and quickly set to start. The images used to create the containers for thsi application are built and stored in docker-hub with their corresponding version tag for implementation of rollback features at a later date.   

**Kubernetes**

Kubernetes is the orchetsration tool used to deploy the application for production. Kubernetes is an ideal tool for deploying containerised applications such as this. Coupled with services offered by cloud providers such as EKS it makes the production process seamless once confgured. The kubernetes file within this repository has the yaml files necessary to provision 4 services- one serving the frontend, backend, database and finally the reverse proxy nginx. 

**Nginx**

Ngnix has been employed in this deployment for 2 reasons, the primary reaosn being security. The only port exposed to users is 80 which reduces the number of access points for potentially malicious attacks. Additionally the proxy can be employed as a load balancer, managing application traffic on behalf of the developers.

### Testing 
Testing for the application is carried out using the pytest command. Upon builing and deployment of the app, test are run on both the frontend and backend to ensure no bugs exist before triggering production. The output of these tests are stored on the test vm in a file should developers wish to access these reports at a later date. 

### Future Improvements 

**Automation & Process Streamlining**
1. Variables: The movement of necessary variables automatically between environments would serve to further automate and streamline the pipeline. As such future improvements will include a Jenkisn pipeline that loads the environment variables from the file on the machine into the workspace for use across environments. 
2. Database Set Up: Currently, the process of creating tables in the database is manual as passwordless connection to the database was not realsied by the dealine (ie through IAM AUthentication). This additional stage in the pipeline would remove the devlopers need to act at this point. 
3. Public Keys: At present, access from the local machine to the Jenkins VM is achieved via ansible without a need to manually eneter public keys, however to move from Jenkins  to the test vm, keys are still being manually input. This is another opportunity to further automate the process and remove resistance to pipeline flow.
4. Rollback: The majority of the underlying framework exists in the development branch Jenkinsfile to allow for rollback however, furture improvements would fully develop this feature to allow for rollback to previous versions.
5. Ansible: Currently I am configuring the test environment by using an ansible playbook to execute a script whcih is not the ideal way to use a playbook, the the future the test environment playbook will have tasks that perform the script function. 

**Security**
1. Confguring a VPC with subnets that only have the necessary ports open and access to each othetr and the internet gateway is the optimal way of deploying the application, future improvements would employ this model of security.
2. Employ secret files with kubernetes to allow sensitive variables to be accessed without unecessary exposure, thus reducing the risk.


### Resources 

Jira Kanban Board:https://ak21.atlassian.net/secure/RapidBoard.jspa?projectKey=SFIA2&rapidView=4

Risk Assessment: https://docs.google.com/spreadsheets/d/168WPpOYIqNN-oN5-1prWPs5vJ7KqBjUfUSYXmCgbJHo/edit?usp=sharing

Presentation: https://docs.google.com/presentation/d/1vrwk2YhZBkXPyp5loHmnUd6g-PDPBXi_sML4jPjTNHc/edit?usp=sharing

### Acknowledgements

A special thank you to my trainer Jay Grindrod for his continued guidance and support during this project. 

### Authors
Adama Kabba
