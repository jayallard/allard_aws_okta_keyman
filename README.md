# AWS Okta KeyMan Login

This container uses the the `aws_okta_keyman` client to login to AWS. This is just a wrapper; all the real work is done by `aws_okta_keyman`.

- aws_okta_keyman: <https://github.com/nathan-v/aws_okta_keyman>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE.txt>
- License: <https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE_MIT.txt>

The container provides `aws_okta_keyman` and the `aws cli`. Use them any way you like. Examples are provided.

## Examples

### Work Within the Container

If you need an aws prompt, and no host resources, the launch the container, login, and do your aws work.

```bash
docker run -it -e OKTA_ORG=MyOktaOrg -e OKTA_USER=MyOktaUserName jayallard/aws_okta_keyman
```

That will prompt you to login to Okta. When complete, the bash shell will launch, and `aws` is ready to go.

### Use the Container to Provide AWS Credentials to the Host

In this example (which is my normal usage):

- the aws cli is installed on the host, but aws_okta_keyman is not
- run the container, and login
- the container will put the resulting credential into your host aws folder
- You can use the aws_okta_keyman `--reup` option to stay alive and update the credentials periodically.

`aws_okta_keyman` will stay active, and will periodically refresh your credentials.

`docker run -it -v "/home/jaya/.aws":/root/.aws --entrypoint="aws_okta_keyman" jayallard/aws_okta_keyman -o MY_OKTA_ORG -u MY_EMAIL_ADDRESS --reup`

Of course, creating an alias or a script will be a lot easier than dealing with that every time you need to login.

Explanation:

- -v - map your local host aws folder (left) to the container aws folder (right). When the container writes the credentials, it actually writes them to your host machine.
- entrypoint - run `aws_okta_keyman`
- `jayallard/aws_okta_keyman` - the docker image name
- the aws_okta_keyman parameters follow the image name
  - -o - your okta organization
  - -u - the email address that you login to OKTA with
  - --reup - aws_okta_keyman will keep running, and will periodically refresh your aws credentials. Eventually, you'll have to authenticate again, but it'll be less frequently than you otherwise would need to.

## Shell Aliases

The container provides some aliases that might be helpful.

type `h` to see what is available.

These are minor things that are meant to serve as shortcuts.

## Troubleshooting

### Docker Container Wrong Date

In Windows, sometimes the docker container has a different date than the host machine and AWS. When that happens, the AWS commands will fail with an error. The error message states that there is a time discrepancy.

This is a windows/docker issue, not a container or AWS issue.

One way to fix:

- open powershell as an admin
- `Restart-Service LxssManager`
- restart docker

## Release Notes

### Version 2 - 6/24/2022

Breaking change.

The previous version used to login the host by copying the aws credentials file from the container to the host. That worked well for me, until I wanted to add `--reup` to the aws_okta_keyman command. `--reup` puts the program in a loop, so the program never ends, and the file never gets copied up to the host.

As a result, I changed the approach. Instead of copying from the guest to the host, it now maps the host `aws` folder to the container. Now, when `aws_okta_keyman` sets the credentials, it is written to the host directly. To aws_okta_keyman, it's just the local .aws folder. But, in reality, it's the hosts .aws folder.

As it turns out, this is a much better solution anyway, and it's how it should've been done from the beginning.
