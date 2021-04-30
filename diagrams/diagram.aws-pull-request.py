

from diagrams import Cluster, Diagram, Edge
from diagrams.aws.devtools import Codebuild,Codepipeline,Codecommit
from diagrams.aws.storage import S3
from diagrams.aws.integration import SQS
from diagrams.aws.management import CloudwatchEventEventBased
from diagrams.aws.compute import LambdaFunction
from diagrams.onprem.vcs import Github
from diagrams.generic.blank import Blank


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

############################################
# Attributes (LOTS OF EXPERIMINATION HERE) #
############################################
graph_attr = {
    "imagescale": "true",  # true | false | width | height | both
    "fixedsize": "true",  # true | false
    "fontsize": "45",
    "remindcross": "true",
    # "bgcolor": "transparent",
    "bgcolor": "white",
    # "splines": "polyline",
    # "splines": "lines",
    "splines": "splines",
    # "splines": "ortho",
    # "splines": "curved",
    # "splines": "curved",
    # "splines": "compound",
    # "splines": "true",
    "overlap": "false",
    "arrowsize": "10",
    "penwidth": "3",
    # "penwidth": "0",
    # "width": "0.8",
    # "height": "0.8",
    "ratio": "compress",
    # "labeldistance":"10.0",
    "overlap": "scale",
    "overlap_shrink": "true",
    "labelloc": "b",
    "concentrate": "true",
    # "repulsiveforce": "10.0",
    # "rankdir": "LR",
    # "color": "darkblue",
    # "labelfontsize": "18.0",
    # "labelloc":"c",
    # "labelfloat": "false",
    # "layout":"neato",
    # "layout":"fdp",
    # "pack": "true",
}

################################
# PARSE COMMAND LINE ARGUMENTS #
################################
project_directory = os.path.dirname(os.getcwd())
artifact_directory = os.path.join(project_directory, "static","images")
print(f"artifact_directory      : {artifact_directory}")

parser = argparse.ArgumentParser()
parser.add_argument("--filename", help="output file name. Do not include the extension")
parser.add_argument("--outformat", help="default png")
args = parser.parse_args()
outformat = coalesce(args.outformat, "png")

filename = os.path.join(
    artifact_directory, coalesce(args.filename, "diagrams-as-code-03-complex")
)
filenamegraph = os.path.join(
    artifact_directory, coalesce(args.filename, "diagrams-as-code-03-complex.gv")
)
print(f"outformat     : {outformat}")
print(f"filename      : {filename}")
print(f"filenamegraph : {filenamegraph}")

#######################################################
# Setup Some Input Variables for Easier Customization #
#######################################################
title = "diagrams-as-code-03-complex"
show = True
direction = "LR"
smaller = "0.8"

with Diagram(
    name=title,
    direction=direction,
    show=show,
    graph_attr=graph_attr,
    filename=filename,
    outformat=outformat,
) as diag:
    with Cluster("Supported Git Providers"):
        github = Github("github")
        codecommit = Codecommit("Foo")
    with Cluster("AWS Cloud"):
        codebuild = Codebuild("AWS CodeBuild")
        codepipeline = Codepipeline("AWS CodePipeline")
        git_artifacts = S3("Git Artifacts")
        s3_pipeline_source = S3("Pipeline Source")
        sqs = SQS("Amazon Simple Queue Service")
        lambda_function = LambdaFunction("AWS Lambda")
        lambda_function_2 = LambdaFunction("AWS Lambda")
        cloudwatch_events = CloudwatchEventEventBased("Amazon CloudWatch Events")

    colored_flow(
        nodes=(github , codebuild, sqs , lambda_function
        ),
        color="darkblue",
        style="dashed,setlinewidth(5)",
    )
    colored_flow(
        nodes=(codebuild,git_artifacts
        ),
        color="darkgreen",
        style="dashed,setlinewidth(5)",
    )
    colored_flow(
        nodes=(lambda_function, s3_pipeline_source , codepipeline, cloudwatch_events, lambda_function_2, github),
        color="darkorange",
        style="solid,setlinewidth(5)",
    )

diag
