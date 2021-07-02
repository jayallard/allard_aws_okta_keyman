# AWS Okta KeyMan Login

This container uses the the `aws_okta_keyman` client to login to AWS. This is just a wrapper; all the real work is done by `aws_okta_keyman`.

- aws_okta_keyman: <https://github.com/nathan-v/aws_okta_keyman>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE.txt>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE_MIT.txt>

## Usage

There are two ways to use this container.

- It provides a terminal with the AWS client ready to use. If you just need the AWS CLI, then everything you need is provided.
- If you want to log the host machine into AWS, then the container will log you in and copy the credentials file to the host. Run it within your `.aws` folder.

### AWS Cli

```bash

# In the WINDOWS HOST
# Maps the container 'host' folder to the host directory that the container was run in.
docker run -v "%cd%":/usr/src/app/host -it allard/aws_okta_keyman

# IN THE CONTAINER

# login
login MyOrg me@mydomain.com

# Confirm login worked
# makes an aws call for you
test

# or test it yourself
aws sts get-caller-identity
```

Command aliases are provided to the terminal as a convenience. Type `h` to see them.

### Login

Run the container in your `.aws` folder. It will log you in, then copy the credentials from the container to the host. You may then use the aws cli on the host.

Modify the command. Set:

- your Okta org
- your Okta id

```bash
c:
cd \users\jay\.aws
docker run -it -v "%cd%":/usr/src/app/host allard/aws_okta_keyman bash -c "./login.sh MyOrg me@mydomain.com"
```

## Scripts

For easier usage, create scripts and put them in your system path.

- `aws-cli.cmd` - to open the terminal
- `aws-login.cmd` - change the command to mount the docker volume to the .aws folder rater than switch to it every time you need to login.

Examples

### aws-cli.cmd

```bash
@echo off
```

### aws-login.cmd

```bash
@echo off
```

## Troubleshooting

### Docker Container Wrong Date

In Windows, sometimes the docker container has a different date than the host machine and AWS. When that happens, the AWS commands will fail with an error. The error message states that there is a time discrepancy.

This is a windows/docker issue, not a container or AWS issue.

One way to fix:

- open powershell as an admin
- `Restart-Service LxssManager`
- restart docker

