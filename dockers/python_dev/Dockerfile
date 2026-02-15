FROM mcr.microsoft.com/playwright:jammy
RUN apt update -y
RUN apt install curl -y
RUN apt install python3-dev libpq-dev -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:${PATH}"
RUN uv pip install --system playwright
RUN playwright install
RUN playwright install-deps
RUN echo y | npx playwright install-deps
RUN mkdir /code
WORKDIR /code
COPY ./requirements.txt /code
RUN uv pip install --system -r requirements.txt
