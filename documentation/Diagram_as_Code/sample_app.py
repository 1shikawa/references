# pip install diagrams
# brew install graphviz

from diagrams import Cluster, Diagram
from diagrams.programming.framework import React
from diagrams.programming.language import Go, Java
from diagrams.onprem.database import MySQL, PostgreSQL

with Diagram('SPA Architecture', show=True, outformat="png", filename="./documentation/assets/SPA Architecture"):
    frontend = React('Frontend')

    with Cluster('Service A'):
        frontend >>  Go('Go API') >> MySQL('MySQL')

    with Cluster('Service B'):
        frontend >> Java('Java API') >> PostgreSQL('PostgreSQL')
