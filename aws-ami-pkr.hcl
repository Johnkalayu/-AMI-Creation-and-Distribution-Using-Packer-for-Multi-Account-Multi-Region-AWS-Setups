packer {
    required_plugins {
        amazon = {
            version = ">= 0.0.0"
            source = "github.com/hashicorp/amazon"
        }
    }

}
 

source "amazon-ebs" "amazon-linux" {
    ami_name = "amazon-linux-2-ami"
    instance_type = "t2.micro"
    ami_region = ["ap-southeast-1", "ap-southeast-2"]
    source_ami = "ami-0c3fd0f5d33134a76"
    ssh_username = "ec2-user"
    ami_users = [""]
      
} 

build {
    sources = [ "source.amazon-ebs.amazon-linux"]
}

provisioners = [
    
    { 
        type = "file"
        source = "dev.sh"
        destination = "/tmp/dev.sh"
    },

    {
        type = "shell"
        inline = ["chmod a+x /tmp/dev.sh"]
    },

    {
        type = "shell"
        inline = ["ls -la /tmp"]
    },

    {
        type = "shell"
        inline = ["pwd"]
    },

    {
        type = "shell"
        inline = ["cat /tmp/dev.sh"]
    },

    {
        type = "shell"
        inline = ["/bin/bash /tmp/dev.sh"]
    }

]
 
# The above code is a simple Packer configuration file that creates an Amazon Machine Image (AMI) using the Amazon EBS builder.
# The AMI is based on the Amazon Linux 2 AMI. The configuration file also includes a few shell provisioners that copy a shell script to the instance, make it executable, and run it. 
 #The shell script is a simple script that creates a file in the /tmp directory.