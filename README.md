# Protobuf vs. JSON demo

## Installation

Protobuf gem: https://github.com/ruby-protobuf/protobuf/wiki/Installation

```
$ brew install protobuf
$ bundle install
```


## Compilation

```
protoc -I ./definitions --ruby_out ./lib definitions/**/*.proto
```


## Run demo

```
$ ruby demo.rb
```



## Learn

Syntax: https://developers.google.com/protocol-buffers/docs/proto3

Usage: https://github.com/google/protobuf/tree/master/ruby