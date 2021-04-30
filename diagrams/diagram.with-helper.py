

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECS, Fargate,EC2
from diagrams.aws.network import (
    VPC,
    PrivateSubnet,
    PublicSubnet,
    InternetGateway,
)
from diagrams.aws.security import WAF
from diagrams.onprem.compute import Server

# Add argument and path packages to help with passing in arguments via command line
import argparse, sys, os
from pathlib import Path

# Simplify optional argument parsing with a coalesce function
def coalesce(*arg):
    for el in arg:
        if el is not None:
            return el
    return None

# Generate a line by providing the nodes to connect in a list.
# Style the lines and color to make it easier to trace several different paths on the same graph
def colored_flow(nodes, color="black", style="", label=""):
    print(f"==> def colored_flow: nodes {nodes}")
    for index, n2 in zip(nodes, nodes[1:]):
        print(f"\t----> {index.label} >> Edge(label={label}) >> {n2.label}")
        index >> Edge(label=label) >> Edge(color=color, style=style) >> n2
    print("completed with colored_flow")


#######################################################
# Setup Some Input Variables for Easier Customization #
#######################################################
title = "diagrams-as-code-aws-vpc-example-with-helper"
outformat = "png"
filename = "out/diagrams-as-code-aws-vpc-example-with-helper"
filenamegraph = "out/diagrams-as-code-aws-vpc-example-with-helper.gv"
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
    colored_flow(
        nodes=(user,
               waf,
               igw_gateway,
               ec2_server_web_server,
               ec2_server_app_server,
               ec2_server_image_processing
        ),
        color="darkblue",
        style="dashed,setlinewidth(5)",
    )
    colored_flow(
        nodes=(ec2_server_image_processing,ec2_server_app_server),
        color="darkgreen",
        style="solid,setlinewidth(5)",
    )
diag
