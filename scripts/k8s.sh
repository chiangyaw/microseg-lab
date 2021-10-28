#!/bin/bash

# Configuring the namespaces
kubectl create namespace sock-shop && \
kubectl create namespace guestbook && \
kubectl create namespace rogue && \
kubectl create namespace victim && \

# Deploying the applications
kubectl config set-context --current --namespace=sock-shop && \
kubectl apply -f sock-shop.yaml && \
kubectl config set-context --current --namespace=guestbook && \
kubectl apply -f guestbook.yaml && \
kubectl config set-context --current --namespace=rogue && \
kubectl apply -f rogue.yaml && \
kubectl config set-context --current --namespace=victim && \
kubectl apply -f victim.yaml
