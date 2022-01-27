helm install kruise https://github.com/openkruise/kruise/releases/download/v0.10.0/kruise-chart.tgz \
    --set  manager.image.repository=openkruise-registry.cn-hangzhou.cr.aliyuncs.com/openkruise/kruise-manager \
    --set featureGates="ResourcesDeletionProtection=false\,PreDownloadImageForInPlaceUpdate=false"
