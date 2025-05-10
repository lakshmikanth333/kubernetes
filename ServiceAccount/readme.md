REGION_CODE=us-east-1
CLUSTER_NAME=expense-12
ACC_ID=148761662695

1. OIDC provider 

eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster expense-12 \
    --approve

2. Provide access to EKS through IAM policy

eksctl create iamserviceaccount \
--cluster=expense-12 \
--namespace=expense \
--name=expense-mysql-secret \
--attach-policy-arn=arn:aws:iam::148761662695:policy/expenseMysqlReadpolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve