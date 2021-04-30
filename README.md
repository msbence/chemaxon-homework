# ChemAxon Homework

*Provide a GIT repository with the code created in the next steps.*

## Coding challenge

Peter can see a clock in the mirror from the place he sits in the office. When he saw the clock shows 12:22. He knows that the time is 11:38

In the same manner:

05:25 --> 06:35  
01:50 --> 10:10  
11:58 --> 12:02  
12:01 --> 11:59

Please create an application which solves the problem.

Return the real time as a string.

Consider hours to be between 1 <= hour < 13.  
So there is no 00:20, instead it is 12:20.  
There is no 13:20, instead it is 01:20.

Please don’t use Bash.

- Package the application as Docker. Push it to ECR.
- Deploy the application to AWS.
- Please create your minimal deployment in Terraform (please be aware of free tier limits).

## Create a Terraform module that deploys the following. It is not necessary to deploy the module as this requires resources over AWS free tier limits, only the code is required

- A VPC with internet access
- 4 subnets
  - 2 subnets public.
  - 2 subnets private with internet access.
- Make sure access to S3 is not leaving the AWS network.

---

*Do it as simply as possible, the UI experience is not important!*

Please share your git repository containing:

- Your applications source code
- Dockerfile
- Terraform files
- Documentation, if needed

Please also give access to your running application, maybe a HTTP API endpoint with instructions on how it works.
