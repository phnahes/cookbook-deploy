deploy Cookbook
==================
Cookbook used to deploy applications using version on DataBags

Requirements
------------
Require be called on Role and override attribute `node[:deploy]["bag"]` and `node[:deploy]["pkgList"]`

Attributes
----------

#### deploy::default
<table>
  <tr>
    <th>bag</th>
  </tr>
  <tr>
    <td><tt>[:deploy]["bag"]</tt></td>
    <td>String</td>
    <td>Name of Bag</td>
  </tr>
</table>

Usage
-----
#### Cookbook "deploy::default"

Just include `deploy` in your node's `run_list` and override the attributes for each project:

```json
override_attributes(

  "deploy" => {
    "bag" => "bag_name",
    "pkgList" => [ "package1", "package2" ]
  }

)

  "run_list": [
    "recipe[deploy]"
  ]
```

Data Bag
-----
#### Example

Make your databag how below:

```json
{
        "id": "package_name",
        "service": {
                "name": "service_name",
                "action":"action_name"
        },
        "environment1": {
                "version": "12.3.1"
        },
        "environment2": {
                "version": "12.4.5"
        }
}
```

License and Authors
-------------------
Authors: 
Paulo Nahes
