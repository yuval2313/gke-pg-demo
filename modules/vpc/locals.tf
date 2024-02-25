locals {
    vpc_name = "${var.name}-vpc"
    router_name = "${var.name}-router"
    nat_name = "${var.name}-nat"
    gke_subnet_name = "${var.name}-gke-subnet"
    gke_subnet_pod_range_name = "gke-pod-range"
    gke_subnet_svc_range_name = "gke-svc-range"
}