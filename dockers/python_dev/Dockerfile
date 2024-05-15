FROM mcr.microsoft.com/playwright:jammy
RUN apt update -y
RUN apt install python3-pip -y
RUN apt install python3-dev libpq-dev -y
RUN pip3 install playwright
RUN playwright install
RUN playwright install-deps
RUN echo y | npx playwright install-deps
RUN mkdir /code
WORKDIR /code
COPY ./requirements.txt /code
RUN pip3 install -r requirements.txt
