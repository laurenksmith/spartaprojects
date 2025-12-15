

# Terraform 

## Terraform Itself

1. First, I created this new directory.
2. Next, I went to the Hashicorp website and downloaded the Windows version of Terraform.
3. Then, I created a folder called cmdl-tools in my C drive (I kept the name short to lower chances of making mistakes going forward)
4. I then extracted the contents of the Terraform folder from my Downloads folder to the new cmdl-tools folder.
5. I went into thr PATH section of my environment variables settings and added the cmdl-tools folder to it, so that my local machine will access Terraform.
6. To test if this was working, I opened a new Bash window and ran 'Terraform --version' and it showed what version I have installed - success!

## Terraform Extension in VS Code

1. In VS Code, I went to extensions and searched for Terraform. I double checked that I had selected the one from Hashicorp (the official one) and installed that here.