/**
 * Library with public helper methods provided by component tuppr.
 */

local apiGroup = 'tuppr.home-operations.com';

local TalosUpgrade(name='') = {
  apiVersion: '%s/v1alpha1' % apiGroup,
  kind: 'TalosUpgrade',
  metadata: {
    name: name,
  },
};

local KubernetesUpgrade(name='') = {
  apiVersion: '%s/v1alpha1' % apiGroup,
  kind: 'KubernetesUpgrade',
  metadata: {
    name: name,
  },
};

{
  TalosUpgrade: TalosUpgrade,
  KubernetesUpgrade: KubernetesUpgrade,

  apiGroup: apiGroup,
}
