# Lab 01 - Run your first container

==`TODO` add a architecture diagram==

==parent image==

==Docker Storage - docker run whith `-v`==


1. Prepare a html file
    > [bi-monthly-meeting-container/site-content/index.html](../site-content/index.html)

    ![site_content_sample_html](./images/site_content_sample_html.png)


2. Run container with volume

    使用 `docker run -v` 掛載進 container.

    ```
    cd ~/bi-monthly-meeting-container
    docker run -it --rm -d -p 80:80 --name web -v ./site-content:/usr/share/nginx/html:ro nginx
    ```

3. show running container
    ```
    docker ps
    ```
    ![lb01_show_nginx_run](./images/lb01_show_nginx_run.png)

4. use `curl` to access the web page.
    ```
    curl http://localhost:80 -w "\n\n"
    ```

    ![lb01_curl_webpage](./images/lb01_curl_webpage.png)

    (optional) access to VM's public ip
    ```
    curl http://$(curl -s ipinfo.io/ip):80 -w "\n\n"
    ```

    We will observe the content of response is same as `~/bi-monthly-meeting-container/site-content/index.html`.

5. Close and delete this container.
    ```
    docker ps -a -q | xargs -r docker stop && docker ps -a -q | xargs -r docker rm
    ```

6. show running container
    ```
    docker ps
    ```
    ![lb01_no_container](./images/lb01_no_container.png)
