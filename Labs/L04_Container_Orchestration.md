# Lab 04 - Container Orchestration

Container Orchestration: 自動化部署、管理、擴展和監控容器化應用。

Kubernetes: 開源的容器編排平台，具有高可用性、資源管理和自動化運維等優點。

Infrastructure as Code (IaC): 通過編寫代碼來自動化配置和管理 IT 資源，如伺服器、網絡、存儲和虛擬機。

IaC 解決了傳統手動操作存在的挑戰，包括：人為錯誤、不易擴展、多重環境管理。

常見的 IaC 工具包括：

- 雲原生
    - Azure Resource Manager
    - AWS CloudFormation
    - Google Cloud Deployment Manager 
- Terraform
- Ansible
- Chef/Puppet

本 Lab 將運用 Terraform 來準備練習環境，並使用專為本地開發和測試 Kubernetes 應用的工具 － Minikube。


## Task 1 - Install GCE via Terraform

==in GCP cloud shell==

1. initialize a Terraform workspace containing configuration files and installs plugins for required providers.

    ```
    cd ~
    git clone --recurse-submodules https://github.com/HarveyChang/bi-monthly-meeting-container.git --depth=1
    cd ~/bi-monthly-meeting-container/GCE
    terraform init
    ```

2. constructs an execution plan
    ```
    terraform plan -out=vm-deployment
    ```

    若遇到這個錯誤訊息，請再次檢查 GCP Active Project 的設定.
    > Error: Failed to retrieve project, pid: , err: project: required field is not set

3. executes the actions proposed in a Terraform plan to create
    ```
    terraform apply vm-deployment
    ```


## Task 2 - connect to VM and start Minikube

1. connect to the new VM `terraform-vm`
    ```
    gcloud compute ssh terraform-vm --zone=asia-east1-a
    ```
2. be able to run docker without `sudo`:
    ```
    sudo usermod -aG docker $USER && newgrp docker
    ```

3. Test `git`, `docker`, `docker-compose` and `minikube` commands
    ```
    git --version
    ```

    ```
    docker -v
    ```

    ```
    docker compose version
    ```

    ```
    minikube version
    ```

4. Git Clone codes for this hands-on **in VM**
    ```
    cd ~
    git clone --recurse-submodules https://github.com/HarveyChang/bi-monthly-meeting-container.git --depth=1
    cd ~/bi-monthly-meeting-container/minikube
    ```

5. Start Minikube
    ```
    minikube start --driver=docker
    ```


## Task 3 - deploy app to Minikube

==in VM==

==add a diagram==

1. install and enable Minikube addon
    ```
    minikube addons enable ingress
    ```

2. Apply a configuration to a resource.
    ```
    kubectl apply -f deployment.yaml
    ```

    In [this deployment](../minikube/deployment.yaml), 
    we only deploy 1 pod with `replicas: 1`.

3. simulate large amounts of access to test.

   In `access_app.sh`, 
   we will run 50 times `curl http://...` and collect the Pod name from response.

    ```
    cd ~/bi-monthly-meeting-container/minikube
    bash ./access_app.sh
    ```

    we will get only one line response (because we only deploy one Pod).

    ![lb04_minikube_app_1_response](./images/lb04_minikube_app_1_response.png)

    hello-deployment-< Pod's name >
    

## Task 4 - scale up in manual

1. scale to 10 replicas
    ```
    kubectl scale deployment hello-deployment --replicas=10
    ```

    list all Pods
    ```
    kubectl get pod
    ```


2. simulate large amounts of access to test.

   In `access_app.sh`, 
   we will run 50 times `curl http://...` and collect the Pod name from response.

    ```
    cd ~/bi-monthly-meeting-container/minikube
    bash ./access_app.sh
    ```

    ![l04_access_app_after_scale](./images/l04_access_app_after_scale.png)


## Task 5 - cleanup

1. (optional) remove Pod & stop Minikube
    ```
    kubectl delete -f deployment.yaml
    minikube stop
    ```

2. disconnect `SSH` (and back to GCP Cloud Shell)
    ```
    `Ctrl + D` or exit
    ```

3. remove the VM `terraform-vm`
    ```
    cd ~/bi-monthly-meeting-container/GCE
    terraform destroy -auto-approve
    ```

## (optional) Remove GCP Project

gcloud projects delete pcalt-docker-<員工編號>
```
gcloud projects delete pcalt-docker-123456
```