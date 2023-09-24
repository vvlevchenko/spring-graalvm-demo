<h2>Run/debug the Spring application in native (no JVM) mode inside docker container</h2>
Currently spring native build based on buildpacks (perhaps plugin should be more investigated)

1. build packs:
   - `cd native_images`
   - `docker run -v $(pwd):/app golang:1.18  /app/scripts/build.sh`
   - `sudo chown $USER:$USER -R bin`
   - `mv bin native-image`
2. Configure pom.xml
```pom.xml
<plugin>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-maven-plugin</artifactId>
   <configuration>
      <image>
         <env>
            <BP_NATIVE_IMAGE_BUILD_ARGUMENTS>
               --no-fallback
               --verbose
               -g
               -O0
               -H:-Inline
            </BP_NATIVE_IMAGE_BUILD_ARGUMENTS>
            <BP_LOG_LEVEL>
                DEBUG
            </BP_LOG_LEVEL>
            <BP_BOM_LABEL_DISABLED>true</BP_BOM_LABEL_DISABLED>
            <!-- -H:ReflectionConfigurationFiles=reflection.json -->
         </env>
         <buildpacks>
            <buildpack>file://<path>/java-native-image</buildpack>
         <buildpack>file://<path>/native-image</buildpack>
         </buildpacks>
      </image>
      </configuration>
   </plugin>
 ```
   
3. Run `mvn spring-boot:build-image -Pnative -DskipTests` 
4. Create a Dockerfile:
   ```Dockerfile
   FROM docker.io/library/spring-graalvm-demo:0.0.1-SNAPSHOT as original
   
   FROM ubuntu
   RUN apt-get update
   RUN apt-get install -y gdbserver
   RUN apt-get install -y libc6-dev
   RUN apt-get install -y libc6-dbg
   RUN apt-get install -y zlib1g-dev
   WORKDIR /workspace
   COPY --from=original /workspace/* ./
   ```
5. Build image from the Dockerfile (4)
6. Create run configuration from GraalVM Native Image with target from the Dockerfile (4)
    - Executable: in image '/workspace/com.example.demo.DemoApplication'
    - Use classpath of module: spring-graalvm-demo
7. Press debug on this run configuration
8. Set desired breakpoints ( in `com/example/demo/DemoApplication.java`)
9. `curl http://localhost:8080/users`


Troubleshooting
https://youtrack.jetbrains.com/issue/IDEA-331760/ It is not possible to set breakpoints for some classes/methods
...