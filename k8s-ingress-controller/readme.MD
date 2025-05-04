# Ingress controller set up

REGION_CODE=us-east-1
CLUSTER_NAME=expense-12
ACC_ID=148761662695

1. OIDC provider 

eksctl utils associate-iam-oidc-provider \
    --region $REGION_CODE \
    --cluster $CLUSTER_NAME \
    --approve

#  It connects your EKS cluster with AWS IAM so that your Kubernetes applications (like the Ingress Controller) can get permission to use AWS services. It’s like saying “Hey AWS, allow my EKS cluster to use IAM roles safely.”


2. IAM policy 

curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.12.0/docs/install/iam_policy.json

3. Create IAM policy

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json

# It Creates an IAM policy named AWSLoadBalancerControllerIAMPolicy. If you downloaded a different policy, replace iam-policy with the name of the policy that you downloaded.

4. Provide access to EKS through IAM policy

eksctl create iamserviceaccount \
--cluster=$CLUSTER_NAME \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::$ACC_ID:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region $REGION_CODE \
--approve

# Install drivers

1. Add the EKS chart repo to Helm

helm repo add eks https://aws.github.io/eks-charts

2. Install AWS Loadbalancer controller 

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$CLUSTER_NAME --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

# To see these loadbalacer drivers(controllers) kubectl get pods -n kube-system. These drivers will manager the loadbalancers (like creation/deletion)
