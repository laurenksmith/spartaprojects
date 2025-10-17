# Python Boto3 for S3 Storage

- [Python Boto3 for S3 Storage](#python-boto3-for-s3-storage)
  - [Overview](#overview)
  - [🐍 What is Python Boto3?](#-what-is-python-boto3)
    - [🔧 What it does](#-what-it-does)
    - [🧠 How it works](#-how-it-works)
    - [💡 Why it matters](#-why-it-matters)
  - [The Task](#the-task)
    - [What I Need To Deliver](#what-i-need-to-deliver)
    - [Steps Taken To Complete the Task](#steps-taken-to-complete-the-task)
- [ensure empty](#ensure-empty)
  - [My Take On Why We Did This and The Benefits of Python Boto3 (For Myself as well as the Home Office)](#my-take-on-why-we-did-this-and-the-benefits-of-python-boto3-for-myself-as-well-as-the-home-office)
    - [Why We Did This](#why-we-did-this)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)
  - [Websites I Used](#websites-i-used)

## Overview
This mini-project demonstrates how to use the **AWS CLI** and **Python Boto3 SDK** to interact with Amazon S3 from an EC2 instance.  
The goal is to install all required dependencies, authenticate with AWS, and then create and run individual Python scripts that automate common S3 operations.

## 🐍 What is Python Boto3?
**Boto3** is Amazon Web Services’ official **Software Development Kit (SDK)** for Python.  
It acts as the “translator” between your Python code and AWS services such as S3, EC2, DynamoDB, Lambda, and many others.

In simple terms:
> Instead of clicking buttons in the AWS console, you can write Python scripts that do the same work automatically.

### 🔧 What it does
- Creates and manages AWS resources programmatically  
- Reads and writes data to S3 buckets  
- Starts/stops EC2 instances  
- Automates infrastructure tasks and pipelines  
- Integrates AWS operations into applications and CI/CD workflows  

### 🧠 How it works
When you run:
```python
import boto3
s3 = boto3.client('s3')
s3.list_buckets()
```
Boto3 uses your AWS credentials (from aws configure or IAM role) to send an authenticated API request to AWS S3.
AWS responds with JSON data about your buckets, which Boto3 then makes available to your Python program.

### 💡 Why it matters

* Enables automation and repeatability (“Infrastructure as Code”)
* Reduces manual errors from console operations
* Forms the foundation for serverless apps and DevOps tooling
* Works seamlessly with AWS CLI and other SDKs (Java, Go, etc.)

## The Task

### What I Need To Deliver

* This README.md explaining:
  * How I isntalled AWS CLI dependencies on EC2
  * How I authenticated with AWS CLI
  * How I manipulated S3
* An EC2 instance named `tech511-lauren-s3-boto3-task` with:
  * AWS CLI + Python env set up
  * `aws configure` (or IAM role) done
  * Six separate Python scripts using boto3:
    * list all buckets
    * create bucket
    * upload a file
    * download a file
    * delete an object
    * delete the bucket

### Steps Taken To Complete the Task

1. Created a new EC2 instance on AWS
   * Name: tech511-lauren-s3-boto3-task
   * Usual instance (Ubuntu 22.04 LTS, t3.micro)
   * Usual key pair
   * Ensured security group allowed SSH (port 22) from my IP

2. SSHd in:
* From my .ssh directory

3. Ran update and upgrade:
```
sudo apt-get update -y
sudo apt-get install -y unzip curl python3 python3-venv python3-pip
```

4. Installed AWS CLI v2:
```
curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version
```

5. Authenticated the CLI:
```
aws configure
```
* Then, enter AWS Access Key ID
* Enter AWS Secret Access Key
* Enter default region name (eu-west-1)
* Finally, default output format (I chose json)

6. Created a Python project folder and venv (virtual environment):
```
mkdir -p ~/s3-boto3-task && cd ~/s3-boto3-task
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip boto3
```

7. Chose a bucket name + region:
```
export AWS_REGION="eu-west-1"
export BUCKET_NAME="tech511-lauren-test-boto3-$(date +%s)"
echo "Bucket: $BUCKET_NAME  Region: $AWS_REGION"
```

8. Created the scripts:
   * list_buckets.py
    ```
    # list_buckets.py
    import boto3
    s3 = boto3.client('s3')
    resp = s3.list_buckets()
    print("Buckets:")
    for b in resp.get('Buckets', []):
        print("-", b['Name'])
    ```

    * create_bucket.py
    ```
    # create_bucket.py
    import os, boto3
    region = os.getenv("AWS_REGION", "eu-west-1")
    bucket = os.getenv("BUCKET_NAME")
    s3 = boto3.client('s3', region_name=region)

    create_args = {'Bucket': bucket}
    if region != 'us-east-1':
        create_args['CreateBucketConfiguration'] = {'LocationConstraint': region}

    s3.create_bucket(**create_args)
    print(f"Created bucket: {bucket} in {region}")
    ```

    * upload_file.py
    ```
    # upload_file.py
   import os, boto3
   bucket = os.getenv("BUCKET_NAME")
   local_path = os.getenv("LOCAL_FILE", "/home/ubuntu/puppy.png")
   key = os.getenv("S3_KEY", "puppy.png")
   s3 = boto3.client('s3')
   s3.upload_file(local_path, bucket, key)
   print(f"Uploaded {local_path} to s3://{bucket}/{key}")
    ```

    * download_file.py
    ```
    # download_file.py
   import os, boto3
   bucket = os.getenv("BUCKET_NAME")
   key = os.getenv("S3_KEY", "puppy.png")
   dest = os.getenv("DOWNLOAD_TO", "/home/ubuntu/puppy.png")  
   s3 = boto3.client('s3')
   s3.download_file(bucket, key, dest)
   print(f"Downloaded s3://{bucket}/{key} to {dest}")
    ```

    * delete_object.py
    ```
    # delete_object.py
   import os, boto3
   bucket = os.getenv("BUCKET_NAME")
   key = os.getenv("S3_KEY", "puppy.png")
   s3 = boto3.client('s3')
   s3.delete_object(Bucket=bucket, Key=key)
   print(f"Deleted object s3://{bucket}/{key}")
   ```

    * delete_bucket.py
    ```
    # delete_bucket.py
   import os, boto3
   bucket = os.getenv("BUCKET_NAME")
   s3 = boto3.client('s3')

   # ensure empty
   resp = s3.list_objects_v2(Bucket=bucket)
   for obj in resp.get('Contents', []):
       s3.delete_object(Bucket=bucket, Key=obj['Key'])

   s3.delete_bucket(Bucket=bucket)
   print(f"Deleted bucket: {bucket}")
    ```

9.  Ran the scripts step by step:

* activate venv <br>
`source .venv/bin/activate`

* region + unique bucket <br>
`export AWS_REGION="eu-west-1"
export BUCKET_NAME="tech511-lauren-test-boto3-$(date +%s)"`

* list existing buckets <br>
`python3 list_buckets.py`

* create your new bucket <br>
`python3 create_bucket.py
aws s3 ls | grep "$BUCKET_NAME"`

* UPLOAD puppy.png <br>
`export LOCAL_FILE="/home/ubuntu/puppy.png"
export S3_KEY="puppy.png"
python3 upload_file.py
aws s3 ls "s3://$BUCKET_NAME/"`

* DOWNLOAD puppy.png back to the VM <br>
`export DOWNLOAD_TO="/home/ubuntu/puppy.png"
python3 download_file.py
ls -lh "/home/ubuntu/puppy.png"`

* DELETE the object from S3 <br>
`python3 delete_object.py
aws s3 ls "s3://$BUCKET_NAME/"`

* DELETE the bucket <br>
`python3 delete_bucket.py
aws s3 ls | grep "$BUCKET_NAME" || echo "bucket gone"`

10.  Verified each DOD item from the task:
 * CLI installed `aws --version`
 * Auth works `aws sts get-caller-identity`
 * Python venv + boto3 installed
 * 6 scripts present and executable
 * I ran them in order and validated with `aws s3 ls` / output
 * Final clean-up (bucket deleted)


## My Take On Why We Did This and The Benefits of Python Boto3 (For Myself as well as the Home Office)

### Why We Did This

### Benefits for Me

### Benefits for the Home Office

## Websites I Used
* [Official Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)
* [Pypi Documentation](https://pypi.org/project/boto3/)
* [Developer Guide (AWS)](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/index.html)
* [GeeksforGeeks](https://www.geeksforgeeks.org/devops/what-is-the-difference-between-the-aws-boto-and-boto3/)