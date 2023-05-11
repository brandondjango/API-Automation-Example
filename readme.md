# API Automation 

## Introduction

This project is an API automation project. 


## Requirements

At minimum:
*Ruby 2.6


## Running the project
Navigate to project root.

Install the Ruby gem bundler
>gem install bundler

Install the project gems
>bundle install

The command to run the project is 
>bundle exec cucumber 

To choose a particular cucumber profile/set of tests you want to run, see cucumber.yml
>bundle exec cucumber -p regression


## GRPC Test Server

There is a test grpc server and client in this project. To create the grpc ruby classes for the proto file in here, run this:

>grpc_tools_ruby_protoc -I proto --ruby_out=lib --grpc_out=lib proto/helloworld.proto

Then, you'll need to start a server to test against:

>./server/server.rb

If you want to see it in action, you can also run this command after starting the server:

>./client/client.rb

