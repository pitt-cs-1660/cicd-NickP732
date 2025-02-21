FROM python:3.11-buster AS builder

WORKDIR /app

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create true \
    && poetry config virtualenvs.in-project true \
    && poetry install --no-root --no-interaction --no-ansi 

RUN ls -l /app/.venv && ls -l /app/.venv/bin

COPY . .

FROM python:3.11-buster AS app

COPY --from=builder /app /app

WORKDIR /app

EXPOSE 8000

ENV PATH="/app/.venv/bin:$PATH"

RUN ls -l /app/.venv/bin

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"]