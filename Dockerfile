FROM denoland/deno:1.43.1

# The port that your application listens to.
EXPOSE 8000

WORKDIR /opt

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY deno* deps.ts ./
RUN deno cache deps.ts

COPY . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache main.ts

CMD ["run", "--allow-net", "main.ts"]