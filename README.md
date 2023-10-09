<h2>Run/debug the Spring application in native (no JVM) mode inside docker container</h2>
Currently spring native build based on buildpacks (perhaps plugin should be more investigated)

1. configure pom.xml
   1. configure `org.graalvm.buildtools`
```xml
            <plugin>
                <groupId>org.graalvm.buildtools</groupId>
                <artifactId>native-maven-plugin</artifactId>
                <configuration>
                    <classesDirectory>${project.build.outputDirectory}</classesDirectory>
                    <metadataRepository>
                        <enabled>true</enabled>
                    </metadataRepository>
                    <requiredVersion>17</requiredVersion>
                    <imageName>springDemo</imageName>
                </configuration>
            </plugin>
```
   2. configure execution phase
```xml
    <profiles>
        <profile>
            <id>native</id>
            <build>
                <plugins>
                    <plugin>
                        <groupId>org.graalvm.buildtools</groupId>
                        <artifactId>native-maven-plugin</artifactId>
                        <configuration>
                            <debug>true</debug>
                        </configuration>
                        <executions>
                            <execution>
                                <id>build-native</id>
                                <goals>
                                    <goal>compile-no-fork</goal>
                                </goals>
                                <phase>package</phase>
                            </execution>
                        </executions>
                    </plugin>
                </plugins>
            </build>
        </profile>
    </profiles>
```
2. After import edit (maven before run task): `-P native package` and working directory.
3. 