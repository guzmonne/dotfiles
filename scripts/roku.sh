#!/usr/bin/env bash

while [[ "$#" -gt 0 ]]; do
  case $1 in
    mesh)
      shift
      roku-mesh.sh $@;
      exit;;
    aws-sso)
      shift
      roku-aws-sso.sh $@;
      exit;;
    *)
      echo "Unknown subcommand $1"
      exit 1;;
  esac
done

