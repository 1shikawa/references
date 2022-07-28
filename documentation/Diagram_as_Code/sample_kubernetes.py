# pip install diagrams
# brew install graphviz

from diagrams import Cluster, Diagram
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet
from diagrams.k8s.network import Ingress, Service
from diagrams.k8s.podconfig import ConfigMap

with Diagram('Kubernetes Architecture', show=True, outformat="png", filename="./documentation/assets/Kubernetes Architecture"):
    ingress = Ingress('Ingress')

    service = Service('Service')

    with Cluster(''):
        pods = [
            Pod('pod'),
            Pod('pod'),
            Pod('pod')
        ]

    replicaset = ReplicaSet('ReplicaSet')

    deployment =  Deployment('Deployment')

    configmap = ConfigMap('ConfigMap')

    ingress >> service >> pods << replicaset <<  deployment << configmap
