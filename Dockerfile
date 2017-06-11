FROM r-base:latest
# FROM rdocker/rdocker
MAINTAINER mukherjeechiranjit@gmail.com
ADD run.sh /
ADD hello_world.R /
WORKDIR /
# RUN sh /run.sh
# RUN Rscript -e "print('hello_world'); print(1+2)"