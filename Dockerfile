FROM rust:latest as build

# create a new empty shell project
RUN USER=root cargo new --bin r09i_blog_api
WORKDIR /r09i_blog_api

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/r09i_blog_api*
RUN cargo build --release

# our final base
FROM rust:latest

# copy the build artifact from the build stage
COPY --from=build /r09i_blog_api/target/release/r09i_blog_api .

# set the startup command to run your binary
CMD ["./r09i_blog_api"]