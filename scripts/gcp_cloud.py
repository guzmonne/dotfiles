module = dict(
    params = dict(

        )
)

def self_link(module):
        return "https://compute.googleapis.com/compute/v1/projects/{project}/regions/{region}/instanceGroupManagers/{name}".format(**module.params)
