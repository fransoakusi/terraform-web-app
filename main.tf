# Define VPC
resource "aws_vpc" "my_vpc" {
 cidr_block = "10.0.0.0/16"
}
# Define subnets in multiple AZs with non-conflicting CIDR blocks
resource "aws_subnet" "my_subnet_a" {
 vpc_id = aws_vpc.my_vpc.id
 cidr_block = "10.0.1.0/24" # Make sure this CIDR block does not conflict
 availability_zone = "us-east-1a"
}

resource "aws_subnet" "my_subnet_b" {
 vpc_id = aws_vpc.my_vpc.id
 cidr_block = "10.0.2.0/24" # Make sure this CIDR block does not conflict
 availability_zone = "us-east-1b"
}

# Define RDS DB Subnet Group
resource "aws_db_subnet_group" "my_db_subnet_group" {
 name = "my-db-subnet-group"
 subnet_ids = [aws_subnet.my_subnet_a.id, aws_subnet.my_subnet_b.id]
 tags = {
 Name = "my-db-subnet-group"
 }
}

# Define an EC2 instance
resource "aws_instance" "my_instance" {
 ami = "ami-0ae8f15ae66fe8cda" # Replace with a valid AMI ID
 instance_type = "t2.micro"
 subnet_id = aws_subnet.my_subnet_a.id
}


# Define an RDS database
resource "aws_db_instance" "my_db" {
 allocated_storage = 20
 engine = "mysql"
 instance_class = "db.t3.micro"
 db_name = "mydb" # Correct argument to specify the initial database name
 username = "admin"
 password = "password"
 parameter_group_name = "default.mysql8.0"
 skip_final_snapshot = true
 vpc_security_group_ids = [] # Add security group IDs if required
 db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
}