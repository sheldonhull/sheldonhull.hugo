import argparse, sys, os
from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, Fargate,EC2
from diagrams.aws.network import (
    VPC,
    PrivateSubnet,
    PublicSubnet,
    InternetGateway,
)
from diagrams.aws.security import WAF
from diagrams.onprem.compute import Server

#######################################################
# Setup Some Input Variables for Easier Customization #
#######################################################
title = "diagrams-as-code-aws-vpc-example"
outformat = "png"
filename = "out/diagrams-as-code-aws-vpc-example"
filenamegraph = "out/diagrams-as-code-aws-vpc-example.gv"
show = False
direction = "LR"
smaller = "0.8"


with Diagram(
    name=title,
    direction=direction,
    show=show,
    filename=filename,
    outformat=outformat,
) as diag:
    # Non Clustered
    waf = WAF("waf")
    user = Server("user")

    # Cluster = Group, so this outline will group all the items nested in it automatically
    with Cluster("vpc"):
        igw_gateway = InternetGateway("igw")

        # Subcluster for grouping inside the vpc
        with Cluster("subnets_public"):
            ec2_server_web_server = EC2("web_server")
        # Another subcluster equal to the subnet one above it
        with Cluster("subnets_private"):
            ec2_server_app_server = EC2("app_server")
            ec2_server_image_processing = EC2("async_image_processing")

    # Now I document the flow here for clarity
    # Could do it in each node area, but I like the "connection flow" to be at the bottom
    ###################################################
    # FLOW OF ACTION, NETWORK, or OTHER PATH TO CHART #
    ###################################################
    user >> waf >> igw_gateway >> ec2_server_web_server >> ec2_server_app_server >> ec2_server_image_processing

diag
