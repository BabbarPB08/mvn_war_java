
# maven project integration with s2i:

Approach "A"
~~~
git clone https://github.com/BharatBabbar28/mvn_war_java.git

cd mvn_war_java

mvn clean package

oc new-project s2i-test

oc new-build --binary=true --name=test --image-stream=java:8

oc start-build test --from-dir=./target/ --follow

oc get is
~~~

Approach "B"
~~~
git clone https://github.com/BharatBabbar28/mvn_war_java.git

cd mvn_war_java

mvn clean package && mv target/*war .

oc new-project s2i-test

oc apply -f is_bc.yaml

oc start-build test

oc get is
~~~
See Out:
~~~
$ git clone https://github.com/BharatBabbar28/mvn_war_java.git
Cloning into 'mvn_war_java'...
remote: Enumerating objects: 147, done.
remote: Counting objects: 100% (147/147), done.
remote: Compressing objects: 100% (102/102), done.
remote: Total 147 (delta 43), reused 112 (delta 20), pack-reused 0
Receiving objects: 100% (147/147), 4.65 MiB | 1.10 MiB/s, done.
Resolving deltas: 100% (43/43), done.

$ cd mvn_war_java/
[quicklab@upi-0 mvn_war_java]$ mvn clean package && mv target/*war .
[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building sparkjava-hello-world 1.0
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-clean-plugin:2.4.1:clean (default-clean) @ sparkjava-hello-world ---
[INFO] Deleting /tmp/mvn_war_java/target
[INFO] 
[INFO] --- maven-enforcer-plugin:1.3.1:enforce (enforce-java) @ sparkjava-hello-world ---
[...]
[...]
[...]
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Results :
Tests run: 0, Failures: 0, Errors: 0, Skipped: 0
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3.387s
[INFO] Finished at: Thu May 25 06:52:36 EDT 2023
[INFO] Final Memory: 14M/34M
[INFO] ------------------------------------------------------------------------

$ oc new-project s2i-test
Already on project "s2i-test" on server "https://api.babbarcluster0.lab.psi.pnq2.redhat.com:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/e2e-test-images/agnhost:2.33 -- /agnhost serve-hostname

$ oc apply -f is_bc.yaml
imagestream.image.openshift.io/test created
buildconfig.build.openshift.io/test created

$ oc describe bc test | grep "Binary:"
Binary:			provided as file "sparkjava-hello-world-1.0.war" on build

$ oc start-build test
build.build.openshift.io/test-1 started

$ oc get build -w
NAME     TYPE     FROM   STATUS    STARTED          DURATION
test-1   Source          Running   11 seconds ago   
test-1   Source          Running   12 seconds ago   
test-1   Source          Running   12 seconds ago   
test-1   Source          Complete   15 seconds ago   15s

$ oc get is
NAME   IMAGE REPOSITORY                                                 TAGS     UPDATED
test   image-registry.openshift-image-registry.svc:5000/s2i-test/test   latest   15 seconds ago
~~~


Copy the URL for webhook implementation
~~~
URL=$(oc describe bc test | awk '/Webhook GitHub:/ {getline; print $2}')
SECRET=$(oc get bc test -o=jsonpath='{.spec.triggers..github.secret}')
FINAL_URL="${URL/<secret>/$SECRET}"

printf "%s\n$FINAL_URL\n\n"
~~~

