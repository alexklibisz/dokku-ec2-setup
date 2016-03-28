# dokku-ec2-setup
These are my setup scripts and notes for deploying and hosting apps on EC2 with Dokku!

## Configuring the EC2 Instance
1. Create an EC2 instance on AWS with at least 1GB of RAM.
2. The instance's security group should allow inbound connections on ports `22`, `80`, and `20000-65535` and outbound connections on all ports.
3. The instance should have an elastic IP address. This IP will be used to set up domain names. It's important that an elastic IP be used in case you decide to spin up a new instance to replace the original one.

## Setup SSH connection to EC2 instance

I use the same key pair for all of my EC2 instances. Here's how I setup the connection in the `~/.ssh/config` file:

```
host aws-dokku
 hostname aa.bb.cc.dd # <- Elastic IP Address
```

And then I can SSH into the instance:

> ssh ubuntu@aws-dokku

## Dokku Installation on EC2 instance

1. Make sure you have private/public keys configured so that you can connect to the instance via SSH.
2. Run the script:
> ./dokku-install.sh [Public IP Address for EC2 Instance]

## Creating and deploying a Node.js app:

(all commands are run locally)

1. Clone the heroku node-js-sample app:  
> git clone https://github.com/heroku/node-js-sample  
> cd node-js-sample  

2. Create the Dokku app:  
> ssh dokku@aws-dokku apps:create node-js-sample  

3. Add the app as a git remote:
> git remote add dokku dokku@aws-dokku:node-js-sample  

4. Push to deploy the app:
> git push dokku master

5. This will launch the app on a random port on your EC2 instance. The exact URL is returned at the end of the push deployment:

```
=====> Application deployed:
       http://aa.bb.cc.dd:25000 (nginx)

To dokku@aws-dokku:node-js-sample
 * [new branch]      master -> master
```

## Command Reference

(all of these use node-js-sample and are executed from the local machine)

### Create an app
> ssh dokku@aws-dokku apps:create node-js-sample  

### Restart an app
> ssh dokku@aws-dokku ps:restart node-js-sample

### Delete a Dokku app

> ssh dokku@aws-dokku apps:delete node-js-sample

### Set environment variables for an app
> ssh dokku@aws-dokku config:set node-js-sample MY_ENV_VAR=foobar

- http://dokku.viewdocs.io/dokku/configuration-management/

### Custom dockerfile for an app

TODO

### Set custom start for an app

- By default dokku expects your app to run on port 5000. I haven't figured out how to change this yet.
- http://dokku.viewdocs.io/dokku/deployment/dockerfiles/

### Set custom domain for an app

In your domain configuration, set an A-record with a blank name to point at your elastic IP address, and another A-record with name `www` to point at the elastic IP address.


> ssh dokku@aws-dokku domains:add node-js-sample mydomain.com www.mydomain.com

> ssh dokku@aws-dokku domains:remove node-js-sample mydomain.com www.mydomain.com


# TODO

- shell script to spin up AWS EC2 instance.
- instructions for setting up custom docker image and run commands
