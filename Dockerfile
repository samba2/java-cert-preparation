# original kernel: https://github.com/SpencerPark/IJava
# this file is based on a fork: https://raw.githubusercontent.com/awslabs/djl/master/jupyter/Dockerfile
# and contains small adoptions
FROM ubuntu:18.04

RUN apt-get update || true
RUN apt-get install -y openjdk-11-jdk-headless
# provide help on TAB pressed
RUN apt-get install -y openjdk-11-source
RUN apt-get install -y python3-pip git
RUN pip3 install jupyter
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
RUN apt-get install -y curl

RUN git clone https://github.com/frankfliu/IJava.git
RUN cd IJava/ && ./gradlew installKernel && cd .. && rm -rf IJava/
RUN rm -rf ~/.gradle

# notebook extensions
RUN pip3 install https://github.com/ipython-contrib/jupyter_contrib_nbextensions/tarball/master
RUN jupyter contrib nbextension install --user

WORKDIR /home/jupyter

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''",  "--NotebookApp.password=''"]
