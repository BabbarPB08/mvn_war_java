
# Simple s2i maven project

~~~
git clone https://github.com/BharatBabbar28/mvn_war_java.git

cd mvn_war_java

mvn clean package

oc new-project s2i-test

oc new-build --binary=true --name=test --image-stream=java:8

oc start-build test --from-dir=./target/ --follow
~~~

Copy the URL for webhook
~~~
URL=$(oc describe bc test | awk '/Webhook GitHub:/ {getline; print $2}')
SECRET=$(oc get bc test -o=jsonpath='{.spec.triggers..github.secret}')
FINAL_URL="${URL/<secret>/$SECRET}"

echo $FINAL_URL
~~~

