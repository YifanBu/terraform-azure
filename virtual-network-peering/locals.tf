locals {
  resource_group_name="app-grp"
  location="East US"
  environment = {
    staging="10.0.0.0/16"
    test="10.1.0.0/16"
    }
}