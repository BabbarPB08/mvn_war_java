
# Simple s2i maven project

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

mvn clean package

oc new-project s2i-test

oc apply -f BuildConfig.yaml

oc start-build test

oc get is
~~~

Copy the URL for webhook implementation
~~~
URL=$(oc describe bc test | awk '/Webhook GitHub:/ {getline; print $2}')
SECRET=$(oc get bc test -o=jsonpath='{.spec.triggers..github.secret}')
FINAL_URL="${URL/<secret>/$SECRET}"

echo $FINAL_URL
~~~

