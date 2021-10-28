#!/bin/bash

echo "" && \
echo "Sock Shop Pods" && \
kubectl get pods --namespace=sock-shop && \
echo "" && \
echo "GuestBook Pods" && \
kubectl get pods --namespace=guestbook && \
echo "" && \
echo "Rogue Pods" && \
kubectl get pods --namespace=rogue && \
echo "" && \
echo "Victim Pods" && \
kubectl get pods --namespace=victim
