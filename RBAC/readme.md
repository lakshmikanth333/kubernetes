# Ingress controller set up

REGION_CODE=us-east-1
CLUSTER_NAME=expense-12
ACC_ID=148761662695

1. OIDC provider 

eksctl utils associate-iam-oidc-provider \
    --region $REGION_CODE \
    --cluster $CLUSTER_NAME \
    --approve