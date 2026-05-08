// main template for tuppr
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local lib = import 'lib/tuppr.libsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.tuppr;

local aggregatedClusterRole = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      'rbac.authorization.k8s.io/aggregate-to-cluster-reader': 'true',
    },
    name: 'tuppr-crds-cluster-reader',
  },
  rules: [
    {
      apiGroups: [lib.apiGroup],
      resources: ['*'],
      verbs: ['get', 'list', 'watch'],
    },
  ],
};

local talosUpgrades = com.generateResources(params.talos_upgrades, lib.TalosUpgrade);
local kubernetesUpgrades = com.generateResources(params.kubernetes_upgrades, lib.KubernetesUpgrade);

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace.name) {
    metadata+: {
      annotations+: params.namespace.annotations,
      labels+: params.namespace.labels,
    },
  },
  [if params.rbac.aggregated_cluster_reader then '10_cluster_role']:
    aggregatedClusterRole,
} + {
  ['10_talos_upgrade_%s' % res.metadata.name]: res
  for res in talosUpgrades
} + {
  ['10_kubernetes_upgrade_%s' % res.metadata.name]: res
  for res in kubernetesUpgrades
}
