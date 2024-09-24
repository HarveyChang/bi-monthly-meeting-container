# Lab 02 - Build your first docker image
==`TODO` add a architecture diagram==
==Copy files to container in Dockerfile==
==port==
- docker build

這個案例展示的是使用 Docker 作為針對 Java 進行編譯、運行的環境。


1. Build the docker image

    [Dockerfile](..\spring-boot-hello-world\Dockerfile)

    ```
    cd ~/bi-monthly-meeting-container/spring-boot-hello-world
    docker build --tag 'spring-boot-helloworld' .
    ```

2. Run container
    ```
    docker run -d -p 80:8080 spring-boot-helloworld
    ```

3. show running container
    ```
    docker ps
    ```

4. Access this app.
    ```
    curl http://localhost:80 -w "\n\n"
    ```

5. Close and delete this container.
    ```
    docker ps -a -q | xargs -r docker stop && docker ps -a -q | xargs -r docker rm
    ```
