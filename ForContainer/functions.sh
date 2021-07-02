function login {
    echo "---------------------------------------------------------"
    echo " Login "
    echo "---------------------------------------------------------"
    echo " You will be prompted for your okta password. "
    echo " Okta will send a push to your phone. "
    echo " Verify the login on your phone. "
    echo " If you have access to multiple aws orgs, you will"
    echo " Upon completion, you are ready to run aws commands."
    echo " Run 'test' to confirm connectivity. "
    echo " "
    # $1 = org, $2 = user name
    if [[ -z $1 || -z $2 ]];
    then
        echo "Usage: login ORG USERNAME"
    else
        aws_okta_keyman --org $1 --username $2
    fi
}

function test {
    echo "---------------------------------------------------------"
    echo " Test "
    echo "---------------------------------------------------------"
    echo " This executes a simple AWS command, for test purposes."
    echo " "
    aws sts get-caller-identity
}

function creds {
    echo "---------------------------------------------------------"
    echo " Credentials "
    echo "---------------------------------------------------------"
    echo " For more details: cat ~/.aws/credentials "
    echo " "
    cat ~/.aws/credentials | grep aws_access_key_id && cat ~/.aws/credentials | grep aws_secret_access_key
}

function copyCredsToHost {
    echo "---------------------------------------------------------"
    echo " Copy Creds to Host "
    echo "---------------------------------------------------------"
    echo "This copies the aws credentials file from the docker container to the directory"
    echo "on the host machine from which the container was run."
    echo "For best results, run the container from the host's aws folder so that it can deposit "
    echo "the credentials file directly where it needs to be."
    echo " "
    cp ~/.aws/credentials /usr/src/app/host/credentials
}

function h {
    echo "---------------------------------------------------------"
    echo " Help "
    echo "---------------------------------------------------------"
    echo " Command Aliases: "
    echo "    h - this help screen "
    echo "    login - login to aws "
    echo "          Usage: login ORG USERNAME "
    echo "    test - test aws connectivity "
    echo "    creds - show your temporary access key and secret "
    echo "    copyCredsToHost - copies the aws credentials file to the host machine "
    echo " "
    echo " Once login is complete, you can use the aws cli. "
    echo " "
}

# show the help screen
h