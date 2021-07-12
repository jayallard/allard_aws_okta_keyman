# AWS Okta KeyMan Login

This container uses the the `aws_okta_keyman` client to login to AWS. This is just a wrapper; all the real work is done by `aws_okta_keyman`.

- aws_okta_keyman: <https://github.com/nathan-v/aws_okta_keyman>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE.txt>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE_MIT.txt>

## Usage

There are two ways to use this container.

- It provides a terminal with the AWS client ready to use. If you just need the AWS CLI, then everything you need is provided.
- If you want to log your host machine into AWS, then the container will log you in and copy the credentials file to the host.

### AWS Cli

USE CASE: You need the AWS CLI.

This will:

- Create a container
- Login to AWS using AWS_OKTA_KEYMAN (if credentials are specified)
- Provide a bash terminal, with the AWS CLI installed.

Change:

- OKTA_ORG
- OKTA_USER
- Optionally, the left part of the `-v` parameter. `%cd%` is windows syntax for Current Folder.

```bash
docker run -it -e OKTA_ORG=MyOrg -e OKTA_USER=MyUserName jayallard/aws_okta_keyman
```

If you omit either environment variable, it will not attempt to log you in. You may login using the `login` alias.

```bash
login Org UserName
```

### Login Host

USE CASE: You want to use the AWS CLI on your machine, not within a container.

This will:

- Create a container
- Login to AWS using AWS_OKTA_KEYMAN
- Copy the AWS credentials file from the container to the host
- exit

Modify the command. Set:

- OKTA_ORG
- OKTA_USER
- The path of your `.aws` folder.

Note that `MODE=COPY_TO_HOST` is required. This instructs the container to copy the credentials to the host (folder specified by `-v`), then exit.

```bash
docker run -it -v "/home/allard/.aws":/usr/src/app/host -e OKTA_ORG=MyOrg -e OKTA_USER=MyUserName -e MODE=COPY_TO_HOST jayallard/aws_okta_keyman
```

## Scripts

If you use this image regularly, creating scripts with the docker commands will be more convenient than memorizing or pasting the commands every time you need them.

For example:

- `aws-cli.cmd` - to open the terminal
  - ie: `docker run -v "/home/allard/.aws":/usr/src/app/host -it -e OKTA_ORG=MyOrg -e OKTA_USER=MyUserName jayallard/aws_okta_keyman`
- `aws-login.cmd` - change the command to mount the docker volume to the .aws folder rater than switch to it every time you need to login.
  - ie: `docker run -it -v "/home/allard/.aws":/usr/src/app/host -e OKTA_ORG=MyOrg -e OKTA_USER=MyUserName -e MODE=COPY_TO_HOST jayallard/aws_okta_keyman`

This step is essential, at least for the author, in order to make the AWS login trivial.

## Troubleshooting

### Docker Container Wrong Date

In Windows, sometimes the docker container has a different date than the host machine and AWS. When that happens, the AWS commands will fail with an error. The error message states that there is a time discrepancy.

This is a windows/docker issue, not a container or AWS issue.

One way to fix:

- open powershell as an admin
- `Restart-Service LxssManager`
- restart docker
