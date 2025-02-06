# Architecture Overview

## Cluster Architecture

```mermaid
graph TD
    subgraph Control Plane
        CP1[Control Plane 1<br>4 CPU, 16GB]
        CP2[Control Plane 2<br>4 CPU, 16GB]
        CP3[Control Plane 3<br>4 CPU, 16GB]

        CP1 --- CP2
        CP2 --- CP3
        CP3 --- CP1
    end

    subgraph Worker Nodes
        W1[Worker 1<br>16 CPU, 128GB]
        W2[Worker 2<br>16 CPU, 128GB]
    end

    subgraph GPU Node
        GPU[GPU Worker<br>16 CPU, 128GB<br>4x Tesla P100]
    end

    Control Plane --> Worker Nodes
    Control Plane --> GPU
```

## Core Components

### Control Plane
- **High Availability**: 3-node control plane configuration
- **Resource Allocation**: 4 CPU, 16GB RAM per node
- **Components**:
  - etcd cluster
  - API Server
  - Controller Manager
  - Scheduler

### Worker Nodes
- **General Purpose Workers**: 2 nodes
- **Resources per Node**:
  - 16 CPU cores
  - 128GB RAM
- **Workload Types**:
  - Application deployments
  - Database workloads
  - Media services
  - Monitoring systems

### GPU Node
- **Specialized Worker**: 1 node
- **Hardware**:
  - 16 CPU cores
  - 128GB RAM
  - 4x NVIDIA Tesla P100 GPUs
- **Workload Types**:
  - ML/AI workloads
  - Video transcoding
  - GPU-accelerated applications

## Network Architecture

```mermaid
graph TD
    subgraph External
        Internet((Internet))
        DNS((DNS))
    end

    subgraph Network Edge
        FW[Firewall]
        LB[Load Balancer]
    end

    subgraph Kubernetes Network
        CP[Control Plane]
        Workers[Worker Nodes]
        GPUNode[GPU Node]

        subgraph Services
            Ingress[Ingress Controller]
            CoreDNS[CoreDNS]
            CNI[Network Plugin]
        end
    end

    Internet --> FW
    DNS --> FW
    FW --> LB
    LB --> CP
    CP --> Workers
    CP --> GPUNode
    Services --> Workers
    Services --> GPUNode
```

## Storage Architecture

```mermaid
graph TD
    subgraph Storage Classes
        NFS[NFS Storage Class]
        OpenEBS[OpenEBS Storage Class]
    end

    subgraph Persistent Volumes
        NFS --> NFS_PV[NFS PVs]
        OpenEBS --> Local_PV[Local PVs]
    end

    subgraph Workload Types
        NFS_PV --> Media[Media Storage]
        NFS_PV --> Shared[Shared Config]
        Local_PV --> DB[Databases]
        Local_PV --> Cache[Cache Storage]
    end
```

## Security Considerations

- Network segmentation using Kubernetes network policies
- Encrypted secrets management with SOPS
- TLS encryption for all external services
- Regular security updates via automated pipelines
- GPU access controls and resource quotas

## Scalability

The cluster architecture is designed to be scalable:
- High-availability control plane (3 nodes)
- Expandable worker node pool
- Specialized GPU node for compute-intensive tasks
- Dynamic storage provisioning
- Load balancing for external services
- Resource quotas and limits management

## Monitoring and Observability

```mermaid
graph LR
    subgraph Monitoring Stack
        Prom[Prometheus]
        Graf[Grafana]
        Alert[Alertmanager]
    end

    subgraph Node Types
        CP[Control Plane Metrics]
        Work[Worker Metrics]
        GPU[GPU Metrics]
    end

    CP --> Prom
    Work --> Prom
    GPU --> Prom
    Prom --> Graf
    Prom --> Alert
```

## Resource Management

### Control Plane
- Reserved for kubernetes control plane components
- Optimized for control plane operations
- High availability configuration

### Worker Nodes
- General purpose workloads
- Balanced resource allocation
- Flexible scheduling options

### GPU Node
- Dedicated for GPU workloads
- NVIDIA GPU operator integration
- Specialized resource scheduling
