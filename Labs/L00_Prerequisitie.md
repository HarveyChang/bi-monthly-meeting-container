# Prerequisite

Container 特點：
- 容器依賴底層的作業系統核心，並只包含應用程式所需的庫和依賴。
- 容器運作需要安裝 Container Engine。
- 容器間共享同一個作業系統核心，因此資源使用較為輕量。
- 啟動速度快，所需時間極短，適合用於擴展。

Lab 說明：
- 有別於 GCP Console 的操作，體驗直接透過 `gcloud` 指令建立 VM、virtual Network、Firewall rules。
- 了解安裝 Container Engine 過程。
- 下載本次 Hands-on 需要的 source。


## Task 1 - Create GCP Project and set active project

1. Open a browser and navigate to GCP Console. [Google Cloud Platform](https://console.cloud.google.com/)

2. Navigate directly to [New Project](https://console.cloud.google.com/projectcreate)

3. We need to create a New GCP Project called `pcalt-docker-<employee_id>`

    for example: 
    > 
    > 員工編號：123456
    > 
    > 新增專案名稱：pcalt-docker-123456
    
    ![create_new_project](./images/create_new_project.png)

4. Open `Cloud Shell`

    ![cloud_shell_in_console](./images/cloud_shell_in_console.png)

    > Optional
    > 
    > Navigate direct to [Cloud Shell Editor](https://shell.cloud.google.com/)

5. switch the Active GCP Project to your project `pcalt-docker-<employee_id>`

    **important**
    > 
    > Because it is possible that `<Project Name>` and `<Project ID>` are different.
    >

    首先，使用 環境變數 來存我們的 `pcalt-docker-<employee_id>`
    ```
    PROJECT_NAME=pcalt-docker-<employee_id>
    ```

    確認環境變數
    ```
    echo "Project Name: ${PROJECT_NAME}"
    ```

    switch active project to our project - `pcalt-docker-<employee_id>`
    ```
    PROJECT_ID=$(gcloud projects list --filter="name=${PROJECT_NAME}" --format="value(projectId)")
    gcloud config set project ${PROJECT_ID}
    ```

    success! 
    ![set_project_via_env](images/set_project_via_env.png)

    > 若遇到提示訊息請輸入: y / <Enter> button
    > ![set_active_project_q1](images/set_active_project_q1.png)


6. check Active GCP `ProjectID` again

    ```
    gcloud config get-value project
    ```

    ![get_active_project](./images/get_active_project.png)

    > 
    > pcalt-docker-<employee_id>
    > 

    <employee_id>: 員工編號

    > you will recieve `<Project ID>`, not `<Project Name>`


## Task 2 - Create virtual network and firewall rules

An environment for independent work will be prepared here.

1. Create VPC `docker-network`

    ```
    gcloud compute networks create docker-network --subnet-mode=custom
    ```

    可能會遇到提示－enable API，請按 `<y>`
    > API [compute.googleapis.com] not enabled on project [pcalt-docker-434741-436801]. Would you like to enable and retry (this will take a few minutes)? (y/N)?

2. Create subnet `docker-subnetwork`

    ```
    gcloud compute networks subnets create docker-subnetwork \
        --network=docker-network \
        --range=10.0.0.0/16 \
        --region=asia-east1
    ```

3. Create firewall rules

    ```
    gcloud compute firewall-rules create docker-firewall-ssh \
        --network=docker-network \
        --allow=tcp:22 \
        --source-ranges=0.0.0.0/0

    gcloud compute firewall-rules create docker-firewall-http \
        --network=docker-network \
        --allow=tcp:80,tcp:8080 \
        --source-ranges=0.0.0.0/0

    gcloud compute firewall-rules create docker-firewall-https \
        --network=docker-network \
        --allow=tcp:443,tcp:8443 \
        --source-ranges=0.0.0.0/0
    ```

## Task 3 - Create GCE in GCP and connect to VM

1. Use `use the gcloud compute instances create` command to create VM `docker-vm`:
    ```
    gcloud compute instances create docker-vm \
        --zone=asia-east1-a \
        --machine-type=e2-medium \
        --image-family "debian-11" \
        --subnet "docker-subnetwork" \
        --image-project=debian-cloud \
        --metadata=startup-script='#! /bin/bash
        
        # necessary
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

        # install Docker
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce

        # install Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.29.0/docker-compose-$(uname -s | tr A-Z a-z)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo usermod -aG docker $USER

        # Install Git
        sudo apt update && sudo apt install git -y

        EOF
        '
    ```

    上面的指令會透過 `metadata` 在 VM 建立完成後，背景執行指定的 script。

    以此案例會進行我們 Hands-on 所需要的工具安裝。

2. connect to VM `docker-vm`

    ```
    gcloud compute ssh docker-vm --zone=asia-east1-a
    ```

    > 第一次執行時會有提示訊息需要回應，依序輸入：y, `enter`鍵, `enter`鍵。

    and then you will see the terminal:
    > GCP_USERNAME@docker-vm:~$

    it mean you has logged into the VM.

## Task 4 - Test `git`, `docker` and `docker-compose` commands

wait 1 min ~

1. **important!** for be able to run docker without `sudo`:
    ```
    sudo usermod -aG docker $USER && newgrp docker
    ```

2. check `git` version
    ```
    git --version
    ```

3. check `docker` version
    ```
    docker -v
    ```

4. check `docker compose` version
    ```
    docker compose version
    ```


## Task 5 - Git Clone codes for this hands-on **in VM**

```
cd ~
git clone --recurse-submodules https://github.com/HarveyChang/bi-monthly-meeting-container.git --depth=1
```

## Questions
1. VM 上面能夠直接運行 Docker（Container） 嗎？