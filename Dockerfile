FROM python:3

WORKDIR /usr/src/app

# installs:
# - python
# - aws client
# - aws_okta_keyman


# aws_okta_keyman:  https://github.com/nathan-v/aws_okta_keyman
# License: https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE.txt
# License: https://github.com/nathan-v/aws_okta_keyman/blob/master/LICENSE_MIT.txt
RUN pip install aws_okta_keyman \
    && apt-get update && apt-get install -yy less \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install  \
    && rm -rf aws  \
    && rm awscliv2.zip

COPY ForContainer/functions.sh .
COPY ForContainer/login.sh .

RUN chmod +x login.sh

# add the functions to the bash profile.
# then delete functions.
RUN cat functions.sh >> ~/.bashrc
RUN rm functions.sh

CMD [ "bash" ]
