def custom_android_binary(
    name,
    **kwargs
    ):

  base_path = native.package_name()
  module_name = 'base'
  if base_path == 'features/feature1':
      module_name = 'feature1'

  # Create the android bundle rule as well
  native.android_binary(
    name=name,
    **kwargs
  )

  bundle_rule_name = name.replace("bin_", "bundle_module_", 1)
  android_bundle_module_args = dict(kwargs)
  native.android_bundle_module(
    name=bundle_rule_name,
    module_name = module_name,
    **android_bundle_module_args
  )
