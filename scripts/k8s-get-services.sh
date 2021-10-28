#!/bin/bash

echo "" && \
echo "Sock Shop Services" && \
kubectl get services --namespace=sock-shop && \
echo "" && \
echo "GuestBook Services" && \
kubectl get services --namespace=guestbook
