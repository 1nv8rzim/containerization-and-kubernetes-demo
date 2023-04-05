# Kubernetes Deploy

Once have sucessfully set up your environment and have access to your cluster, it is time to deploy. 

We will be going through the following steps:
1. Make a new Namespace
2. Deploy pods
3. Deploy NodePort service
4. Remote into a container and kill it
5. Delete service
6. Expand deployment
7. Deploy loadbalancer service

## Make a new Namespace

``` bash
kubectl create namespace [namespace]
kubectl config set-context --current --namesapce [namespace]
```

## Deploy Pods
Make a new file called `pods.yaml` with the following contents:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: your_docker_hub_username/your_image_name
        ports:
        - containerPort: 80
```

To deploy this configuration run the following:

``` bash
kubectl apply -f pods.yaml
```

You can watch the deploy run by running:

``` bash
kubectl get pods -w
```

## Deploy NodePort Service

Make a new file called `service-nodeport.yaml` and add the following contents:

``` yaml 
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodeport: 30080
  type: NodePort
```

To deploy the configuration run the following command:

``` bash
kubectl apply -f service-nodeport.yaml
```

To view the deploy you can run:

``` bash
kubectl get services
```

To see the service running, go to http://[nodeip]:30080

## Remote into a container and kill it

Kubernetes is not just for telling container what to do, you can actually get command line access to running container with it.

First you will want to run the following command to get running pods:

``` bash
kubectl get pods
```

From here choose a pod of your choice and copy the name of it and run the following command:

``` bash
kubectl exec -it [pod name] bash
```

You will now have command line access to do as you please, as a fun little bonus see if you can kill the container:

If want to kill the container another way, use the following command:

``` bash
kubectl delete pod [pod name]
```

Now that you killed that pod, immediately check what kubernetes is doing about it with the following command:

``` bash
kubectl get pods -w
```

You should see the dead pod being replace with a new one.

## Delete a service

We are going to move onto an example using a loadbalancer service and no longer require the nodeport one, so let's delete it.

This is as simple as the following command:

``` bash
kubectl delete service webapp-service
```

Then you can check it got deleted by using the following command:

``` bash
kubectl get services
```

## Expand a deployment

Let's say that two containers is no longer doing it for us and we now need 4 or even 10 for that sake, let expand our current pod deployment to something bigger.

You can either edit the local yaml file and reapply it (the old way) or you can edit it with kubectl (what I am about to show you). Run the following command to get an interactive editor of the current deploy:

``` bash
kubectl edit deployments webapp-deployment
```

This is far more verbose that the config we submitted, but it is the same one we had before, just find `spec.replicas` and change the number to your liking (be reasonable).

Run the following command to see your new deployment take shape:

``` bash
kubectl get pods -w
```

## Deploy a loadbalancer service

Finally we are going to end off by deploying a loadbalancing service.

Make a file named `service-loadbalancer.yaml` and add the following contents:

``` yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  selector:
    app: webapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```

Now you just have to apply that service and it will be running without any issue.

``` bash
kubectl apply -f service-loadbalancer.yaml
```

Check the service was installed:

``` bash
kubectl get service
```

This time however you will see a new external IP that is not your node and you will likely not be able reach your service just yet.

Currently your cluster is spinning up an additional loadbalancer through the cloud provider you are using the the traffic will be routed there.


